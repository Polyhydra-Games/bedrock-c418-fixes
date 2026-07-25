#!/usr/bin/env python3
"""Build the reproducible, audio-free Bedrock resource-pack artifact."""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
import tempfile
from pathlib import Path
from zipfile import ZIP_DEFLATED, ZipFile, ZipInfo


AUDIO_SUFFIXES = {
    ".aac",
    ".aif",
    ".aiff",
    ".flac",
    ".m4a",
    ".mid",
    ".midi",
    ".mp2",
    ".mp3",
    ".oga",
    ".ogg",
    ".opus",
    ".wav",
    ".weba",
    ".wma",
}
NESTED_ARCHIVE_SUFFIXES = {".mcpack", ".zip"}
ZIP_EPOCH = (1980, 1, 1, 0, 0, 0)


def fail(message: str) -> None:
    raise SystemExit(f"error: {message}")


def manifest_version(manifest_path: Path) -> str:
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    header_version = manifest["header"]["version"]
    module_versions = [module["version"] for module in manifest["modules"]]
    if not isinstance(header_version, list) or len(header_version) != 3:
        fail("manifest header version must be a three-part array")
    if any(version != header_version for version in module_versions):
        fail("every manifest module version must match the header version")
    if any(not isinstance(value, int) or value < 0 for value in header_version):
        fail("manifest version values must be non-negative integers")
    return ".".join(str(value) for value in header_version)


def source_files(source_dir: Path) -> list[Path]:
    files: list[Path] = []
    for path in sorted(source_dir.rglob("*")):
        if path.is_symlink():
            fail(f"symlink is not permitted in the pack: {path.relative_to(source_dir)}")
        if not path.is_file():
            continue
        suffix = path.suffix.lower()
        if suffix in AUDIO_SUFFIXES:
            fail(f"audio payload is not permitted in the pack: {path.relative_to(source_dir)}")
        if suffix in NESTED_ARCHIVE_SUFFIXES:
            fail(f"nested archive is not permitted in the pack: {path.relative_to(source_dir)}")
        files.append(path)
    if not files:
        fail("pack source contains no files")
    return files


def run_regressions() -> None:
    with tempfile.TemporaryDirectory() as temporary_directory:
        source_dir = Path(temporary_directory) / "mod"
        source_dir.mkdir()
        (source_dir / "manifest.json").write_text("{}", encoding="utf-8")
        source_files(source_dir)

        target = Path(temporary_directory) / "outside.txt"
        target.write_text("must not be packaged", encoding="utf-8")
        (source_dir / "linked.txt").symlink_to(target)
        try:
            source_files(source_dir)
        except SystemExit as error:
            assert "symlink is not permitted" in str(error)
        else:
            raise AssertionError("a symlink-to-file under mod must block packaging")


def write_archive(source_dir: Path, output_path: Path) -> str:
    files = source_files(source_dir)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.unlink(missing_ok=True)

    with ZipFile(output_path, "w", compression=ZIP_DEFLATED, compresslevel=9) as archive:
        for path in files:
            relative = path.relative_to(source_dir).as_posix()
            entry = ZipInfo(relative, date_time=ZIP_EPOCH)
            entry.compress_type = ZIP_DEFLATED
            entry.create_system = 3
            entry.external_attr = 0o100644 << 16
            entry.extra = b""
            entry.comment = b""
            archive.writestr(entry, path.read_bytes(), compress_type=ZIP_DEFLATED, compresslevel=9)

    return hashlib.sha256(output_path.read_bytes()).hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, help="output .mcpack path")
    parser.add_argument("--checksum-output", type=Path, help="output SHA256SUMS.txt path")
    parser.add_argument("--self-test", action="store_true", help="run packaging regressions")
    args = parser.parse_args()

    if args.self_test:
        run_regressions()
        print("Package regressions: OK")
        return

    repo_root = Path(__file__).resolve().parents[1]
    source_dir = repo_root / "mod"
    version = manifest_version(source_dir / "manifest.json")
    output_path = args.output or repo_root / "dist" / f"Poly-C418-Fixes-v{version}.mcpack"
    checksum_path = args.checksum_output or output_path.parent / "SHA256SUMS.txt"

    if output_path.suffix.lower() != ".mcpack":
        fail("output path must end in .mcpack")
    digest = write_archive(source_dir, output_path)
    checksum_path.parent.mkdir(parents=True, exist_ok=True)
    checksum_path.write_text(f"{digest}  {output_path.name}\n", encoding="utf-8", newline="\n")
    print(f"Pack created: {output_path}")
    print(f"SHA-256: {digest}")
    print(f"Checksum created: {checksum_path}")


if __name__ == "__main__":
    try:
        main()
    except (KeyError, TypeError, ValueError, json.JSONDecodeError) as error:
        fail(f"invalid manifest: {error}")
