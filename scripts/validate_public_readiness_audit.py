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
    assert '[[ "$version" == "8.30.0" ]] || return 1' in audit_script, (
        "Gitleaks version normalization must accept only exact 8.30.0"
    )
    assert '[[ "$actual_gitleaks_version" == "$expected_gitleaks_version"* ]]' not in audit_script, (
        "Gitleaks version matching must not accept 8.30.0-dev or patched prefixes"
    )


def assert_audit_directory_contract() -> None:
    root = Path(__file__).resolve().parents[1]
    audit_script = (root / "scripts" / "audit-public-readiness.sh").read_text(encoding="utf-8")
    workflow = (root / ".github" / "workflows" / "public-readiness-audit.yml").read_text(encoding="utf-8")

    assert 'audit_base="$(validate_audit_base "${POLYHYDRA_AUDIT_REPORT_DIR:-}")"' in audit_script, (
        "the protected audit must validate the unmodified POLYHYDRA_AUDIT_REPORT_DIR base"
    )
    assert 'report_dir="${audit_base}/${repository_id}"' in audit_script, (
        "the protected audit may append the repository ID only after base validation"
    )
    assert 'POLYHYDRA_AUDIT_REPORT_DIR: ${{ vars.POLYHYDRA_AUDIT_REPORT_DIR }}' in workflow, (
        "the workflow must pass the audit base without constructing a path"
    )
    assert 'GITHUB_REPOSITORY_ID: ${{ github.repository_id }}' in workflow, (
        "the workflow must pass the repository ID separately"
    )
    assert '${{ vars.POLYHYDRA_AUDIT_REPORT_DIR }}/${{ github.repository_id }}' not in workflow, (
        "an empty audit base must never become a root-level repository directory"
    )


if __name__ == "__main__":
    assert_gitleaks_contract()
    assert_audit_directory_contract()
    print("Protected public-readiness audit contract: OK")
