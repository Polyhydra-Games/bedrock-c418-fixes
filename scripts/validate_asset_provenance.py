#!/usr/bin/env python3
"""Block packaging and release when a distributed asset lacks cleared provenance."""

from __future__ import annotations

import json
import tempfile
from pathlib import Path


REQUIRED_STATUS = "verified-owned"
REQUIRED_LICENSE = "0BSD"


def fail(message: str) -> None:
    raise ValueError(message)


def load_inventory(inventory_path: Path) -> dict[str, object]:
    try:
        inventory = json.loads(inventory_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as error:
        fail(f"invalid asset provenance inventory: {error}")
    if not isinstance(inventory, dict):
        fail("asset provenance inventory must be an object")
    return inventory


def validate_inventory(source_dir: Path, inventory_path: Path) -> None:
    inventory = load_inventory(inventory_path)
    policy = inventory.get("release_policy")
    if not isinstance(policy, dict) or policy.get("unresolved_provenance") != "block":
        fail("asset provenance policy must block unresolved provenance")
    if policy.get("required_rights_status") != REQUIRED_STATUS:
        fail(f"asset provenance policy must require rights_status={REQUIRED_STATUS}")
    if policy.get("required_license") != REQUIRED_LICENSE:
        fail(f"asset provenance policy must require license={REQUIRED_LICENSE}")

    records = inventory.get("distributed_assets")
    if not isinstance(records, dict):
        fail("asset provenance inventory must define distributed_assets")

    actual_paths: set[str] = set()
    for path in sorted(source_dir.rglob("*")):
        if path.is_symlink():
            fail(f"distributed asset must not be a symlink: {path.relative_to(source_dir)}")
        if path.is_file():
            actual_paths.add(path.relative_to(source_dir).as_posix())

    recorded_paths = set(records)
    if missing := actual_paths - recorded_paths:
        fail(f"distributed asset(s) missing provenance: {', '.join(sorted(missing))}")
    if stale := recorded_paths - actual_paths:
        fail(f"asset provenance contains non-distributed path(s): {', '.join(sorted(stale))}")

    for relative_path in sorted(actual_paths):
        record = records[relative_path]
        if not isinstance(record, dict):
            fail(f"asset provenance record must be an object: {relative_path}")
        if record.get("rights_status") != REQUIRED_STATUS:
            fail(f"distributed asset has unresolved provenance: {relative_path}")
        if record.get("license") != REQUIRED_LICENSE:
            fail(f"distributed asset has an unapproved license: {relative_path}")
        if not isinstance(record.get("rights_basis"), str) or not record["rights_basis"].strip():
            fail(f"distributed asset has no rights basis: {relative_path}")


def run_regressions() -> None:
    with tempfile.TemporaryDirectory() as temporary_directory:
        root = Path(temporary_directory)
        source_dir = root / "mod"
        source_dir.mkdir()
        (source_dir / "owned.txt").write_text("owned\n", encoding="utf-8")
        inventory_path = root / "asset-provenance.json"

        inventory_path.write_text(
            json.dumps(
                {
                    "release_policy": {
                        "unresolved_provenance": "block",
                        "required_rights_status": REQUIRED_STATUS,
                        "required_license": REQUIRED_LICENSE,
                    },
                    "distributed_assets": {
                        "owned.txt": {
                            "rights_status": REQUIRED_STATUS,
                            "license": REQUIRED_LICENSE,
                            "rights_basis": "test asset",
                        }
                    },
                }
            ),
            encoding="utf-8",
        )
        validate_inventory(source_dir, inventory_path)

        inventory = json.loads(inventory_path.read_text(encoding="utf-8"))
        inventory["distributed_assets"]["owned.txt"]["rights_status"] = "unverified"
        inventory_path.write_text(json.dumps(inventory), encoding="utf-8")
        try:
            validate_inventory(source_dir, inventory_path)
        except ValueError as error:
            assert "unresolved provenance" in str(error)
        else:
            raise AssertionError("unresolved distributed provenance must block release")

        inventory["distributed_assets"]["owned.txt"]["rights_status"] = REQUIRED_STATUS
        inventory_path.write_text(json.dumps(inventory), encoding="utf-8")
        (source_dir / "unrecorded.txt").write_text("unrecorded\n", encoding="utf-8")
        try:
            validate_inventory(source_dir, inventory_path)
        except ValueError as error:
            assert "missing provenance" in str(error)
        else:
            raise AssertionError("an unrecorded distributed asset must block release")


def main() -> None:
    root = Path(__file__).resolve().parents[1]
    validate_inventory(root / "mod", root / "docs" / "asset-provenance.json")
    run_regressions()


if __name__ == "__main__":
    try:
        main()
    except ValueError as error:
        raise SystemExit(f"error: {error}") from error
    print("Asset provenance contract: OK")
