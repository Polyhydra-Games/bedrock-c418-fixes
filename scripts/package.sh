#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="${repo_root}/mod"
output_path="${PACK_OUTPUT:-${repo_root}/dist/Poly-C418-Fixes.mcpack}"

mkdir -p "$(dirname "${output_path}")"
rm -f "${output_path}"

(
  cd "$source_dir"
  zip -qr "$output_path" .
)

echo "Pack created: ${output_path}"
