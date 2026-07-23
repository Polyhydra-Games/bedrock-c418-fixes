#!/usr/bin/env bash
# Create a private, all-reachable-history audit record without writing findings to CI logs.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
umask 077

fail() {
  echo "error: $*" >&2
  exit 1
}

normalize_gitleaks_version() {
  local version
  version="$(printf '%s' "$1" | tr -d '\r\n')"
  version="${version#v}"
  [[ "$version" == "8.30.0" ]] || return 1
  printf '%s\n' "$version"
}

validate_audit_base() {
  local base="$1"
  [[ -n "$base" ]] || return 1
  [[ "$base" = /* && "$base" != "/" ]] || return 1
  mkdir -p "$base"
  base="$(cd "$base" && pwd -P)"
  [[ "$base" != "$repo_root" && "$base" != "$repo_root"/* ]] || return 1
  printf '%s\n' "$base"
}

if [[ "${1:-}" == "--self-test" ]]; then
  [[ "$(normalize_gitleaks_version 'v8.30.0')" == "8.30.0" ]] || fail "version normalization regression"
  for rejected_version in '8.30.0-dev' '8.30.0-patched' '8.30.1' '8 .30.0'; do
    ! normalize_gitleaks_version "$rejected_version" >/dev/null || fail "version regression accepted $rejected_version"
  done
  ! validate_audit_base '' >/dev/null || fail "empty audit-base regression"
  ! validate_audit_base '/' >/dev/null || fail "root audit-base regression"
  printf 'Public-readiness audit regressions: OK\n'
  exit 0
fi

configured_gitleaks_version="${GITLEAKS_VERSION:-8.30.0}"
expected_gitleaks_version="$(normalize_gitleaks_version "$configured_gitleaks_version")" \
  || fail "GITLEAKS_VERSION must normalize exactly to 8.30.0"
audit_base="$(validate_audit_base "${POLYHYDRA_AUDIT_REPORT_DIR:-}")" \
  || fail "POLYHYDRA_AUDIT_REPORT_DIR must be a non-root absolute private base outside the repository"
repository_id="${GITHUB_REPOSITORY_ID:-}"
[[ "$repository_id" =~ ^[0-9]+$ ]] || fail "GITHUB_REPOSITORY_ID must be a numeric repository ID"
report_dir="${audit_base}/${repository_id}"
mkdir -p "$report_dir"
report_dir="$(cd "$report_dir" && pwd -P)"
chmod 700 "$audit_base" "$report_dir"

command -v git >/dev/null || fail "git is required"
command -v gitleaks >/dev/null || fail "gitleaks ${expected_gitleaks_version} is required on the private runner"
actual_gitleaks_version="$(normalize_gitleaks_version "$(gitleaks version 2>/dev/null)")" \
  || fail "required gitleaks version ${expected_gitleaks_version}; found an unapproved version"

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
# Gitleaks 8.30.0 takes the repository as the positional argument to `git`.
# Keep scanner output exclusively in the protected work directory: findings
# must never be emitted into the Actions log.
gitleaks git "$repo_root" --log-opts="--all" --redact --report-format json --report-path "$work_dir/gitleaks.json" >"$work_dir/gitleaks.stdout" 2>"$work_dir/gitleaks.stderr"
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
