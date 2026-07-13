#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

required_paths=(
  "readme.md"
  "mod/manifest.json"
  "alpha.sh"
  "beta.sh"
  "scripts/package.sh"
  "code_health.md"
  "docs/project-atlas/README.md"
  ".devstudio/project.yaml"
)

for path in "${required_paths[@]}"; do
  if [[ ! -e "$path" ]]; then
    echo "Missing required path: $path" >&2
    exit 1
  fi
done

bash -n alpha.sh
bash -n beta.sh
bash -n scripts/package.sh
python3 -m json.tool mod/manifest.json >/dev/null

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

PACK_OUTPUT="${tmp_dir}/Poly-C418-Fixes.mcpack" bash scripts/package.sh >/dev/null
zip -T "${tmp_dir}/Poly-C418-Fixes.mcpack" >/dev/null

if command -v devstudio >/dev/null 2>&1; then
  devstudio validate --repo "$repo_root"
else
  echo "devstudio not available; skipping DevStudio validation"
fi
