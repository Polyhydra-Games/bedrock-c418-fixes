#!/usr/bin/env python3
"""Static contract checks for the protected all-history Gitleaks invocation."""

from __future__ import annotations

from pathlib import Path


def assert_gitleaks_contract() -> None:
    root = Path(__file__).resolve().parents[1]
    audit_script = (root / "scripts" / "audit-public-readiness.sh").read_text(encoding="utf-8")

    invocation = (
        'gitleaks git "$repo_root" --log-opts="--all" --redact '
        '--report-format json --report-path "$work_dir/gitleaks.json" '
        '>"$work_dir/gitleaks.stdout" 2>"$work_dir/gitleaks.stderr"'
    )
    assert invocation in audit_script, (
        "Gitleaks 8.30.0 must receive the repository as the positional `git` argument "
        "and retain all scanner output in protected evidence files"
    )
    assert "gitleaks git --source" not in audit_script, (
        "Gitleaks 8.30.0 does not support --source for the git command"
    )


if __name__ == "__main__":
    assert_gitleaks_contract()
    print("Protected public-readiness audit contract: OK")
