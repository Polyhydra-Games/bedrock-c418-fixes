#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_path="${PACK_OUTPUT:-}"
checksum_path="${PACK_CHECKSUM_OUTPUT:-}"

args=()
if [[ -n "${output_path}" ]]; then
  args+=(--output "${output_path}")
fi
if [[ -n "${checksum_path}" ]]; then
  args+=(--checksum-output "${checksum_path}")
fi

cd "$repo_root"
python3 scripts/package.py "${args[@]}"
