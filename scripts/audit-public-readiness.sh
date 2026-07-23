#!/usr/bin/env bash
# Create a private, all-reachable-history audit record without writing findings to CI logs.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
expected_gitleaks_version="${GITLEAKS_VERSION:-8.30.0}"
report_dir="${AUDIT_REPORT_DIR:-}"
umask 077

fail() {
  echo "error: $*" >&2
  exit 1
}

[[ -n "$report_dir" ]] || fail "AUDIT_REPORT_DIR must be an absolute private directory outside the repository"
[[ "$report_dir" = /* ]] || fail "AUDIT_REPORT_DIR must be absolute"
mkdir -p "$report_dir"
report_dir="$(cd "$report_dir" && pwd -P)"
[[ "$report_dir" != "$repo_root" && "$report_dir" != "$repo_root"/* ]] || fail "AUDIT_REPORT_DIR must be outside the repository"
chmod 700 "$report_dir"

command -v git >/dev/null || fail "git is required"
command -v gitleaks >/dev/null || fail "gitleaks ${expected_gitleaks_version} is required on the private runner"
actual_gitleaks_version="$(gitleaks version 2>/dev/null | tr -d '[:space:]')"
actual_gitleaks_version="${actual_gitleaks_version#v}"
[[ "$actual_gitleaks_version" == "$expected_gitleaks_version"* ]] || fail "required gitleaks version ${expected_gitleaks_version}; found ${actual_gitleaks_version:-unknown}"

work_dir="$(mktemp -d "${report_dir}/candidate.XXXXXX")"
trap 'rm -rf "$work_dir"' EXIT
report_file="${report_dir}/public-readiness-$(date -u +%Y%m%dT%H%M%SZ)-$(git -C "$repo_root" rev-parse --short=12 HEAD).txt"

{
  printf 'candidate_sha=%s\n' "$(git -C "$repo_root" rev-parse HEAD)"
  printf 'gitleaks_version=%s\n' "$actual_gitleaks_version"
  printf 'generated_at_utc=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf '\n[refs]\n'
  git -C "$repo_root" for-each-ref --format='%(refname) %(objectname)'
  printf '\n[notes]\n'
  git -C "$repo_root" notes list || true
  printf '\n[submodules]\n'
  git -C "$repo_root" submodule status --recursive || true
  printf '\n[lfs]\n'
  if command -v git-lfs >/dev/null 2>&1; then git -C "$repo_root" lfs ls-files --all; else printf 'git-lfs unavailable\n'; fi
  printf '\n[object-inventory]\n'
  git -C "$repo_root" rev-list --objects --all | git -C "$repo_root" cat-file --batch-check='%(objecttype) %(objectsize) %(rest)'
  printf '\n[fsck]\n'
  git -C "$repo_root" fsck --full --no-reflogs
} >"$work_dir/history-and-inventory.txt" 2>&1

set +e
gitleaks git --source "$repo_root" --log-opts="--all" --redact --report-format json --report-path "$work_dir/gitleaks.json" >"$work_dir/gitleaks.stdout" 2>"$work_dir/gitleaks.stderr"
gitleaks_status=$?
set -e

if [[ "$gitleaks_status" -ne 0 ]]; then
  {
    printf 'status=blocked\n'
    printf 'candidate_sha=%s\n' "$(git -C "$repo_root" rev-parse HEAD)"
    printf 'reason=gitleaks returned a nonzero status; inspect protected private evidence\n'
    printf 'evidence_directory=%s\n' "$work_dir"
  } >"$report_file"
  trap - EXIT
  printf 'Public-readiness audit blocked; findings were retained only in the protected audit directory.\n' >&2
  exit 1
fi

{
  printf 'status=pass\n'
  printf 'candidate_sha=%s\n' "$(git -C "$repo_root" rev-parse HEAD)"
  printf 'gitleaks_version=%s\n' "$actual_gitleaks_version"
  printf 'evidence_directory=%s\n' "$work_dir"
  printf 'manual_triage_required=true\n'
} >"$report_file"
trap - EXIT
printf 'Public-readiness audit completed; protected report created.\n'
