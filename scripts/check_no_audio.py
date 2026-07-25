#!/usr/bin/env python3
"""Reject tracked audio payloads before public packaging or release."""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

from package import AUDIO_SUFFIXES


def tracked_paths(repo_root: Path) -> list[Path]:
    result = subprocess.run(
        ["git", "-C", str(repo_root), "ls-files", "-z"],
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    return [Path(item) for item in result.stdout.decode("utf-8").split("\0") if item]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", type=Path, default=Path(__file__).resolve().parents[1])
    args = parser.parse_args()
    repo_root = args.repo.resolve()
    violations = sorted(
        path.as_posix() for path in tracked_paths(repo_root) if path.suffix.lower() in AUDIO_SUFFIXES
    )
    if violations:
        print("error: tracked audio payloads are not permitted:", file=sys.stderr)
        print("\n".join(violations), file=sys.stderr)
        raise SystemExit(1)
    print("No tracked audio payloads found.")


if __name__ == "__main__":
    main()
