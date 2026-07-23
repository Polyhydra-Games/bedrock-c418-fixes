#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

required_paths=(
  "README.md"
  "mod/manifest.json"
  "alpha.sh"
  "beta.sh"
  "scripts/package.sh"
  "scripts/package.py"
  "scripts/check_no_audio.py"
  "scripts/validate_runner_routing.py"
  "scripts/validate_public_readiness_audit.py"
  "scripts/audit-public-readiness.sh"
  "LICENSE"
  "THIRD_PARTY_NOTICES.md"
  "docs/public-delivery.md"
  "docs/public-readiness.md"
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
bash -n scripts/audit-public-readiness.sh
python3 -m json.tool mod/manifest.json >/dev/null
python3 scripts/check_no_audio.py --repo "$repo_root" >/dev/null
python3 scripts/validate_runner_routing.py >/dev/null
python3 scripts/validate_public_readiness_audit.py >/dev/null

tmp_dir="$(mktemp -d)"
trap 'rm -rf "${tmp_dir}"' EXIT

PACK_OUTPUT="${tmp_dir}/first.mcpack" PACK_CHECKSUM_OUTPUT="${tmp_dir}/first.SHA256SUMS.txt" bash scripts/package.sh >/dev/null
PACK_OUTPUT="${tmp_dir}/second.mcpack" PACK_CHECKSUM_OUTPUT="${tmp_dir}/second.SHA256SUMS.txt" bash scripts/package.sh >/dev/null
cmp "${tmp_dir}/first.mcpack" "${tmp_dir}/second.mcpack"
zip -T "${tmp_dir}/first.mcpack" >/dev/null
python3 - "${tmp_dir}/first.mcpack" <<'PY'
from pathlib import Path
from zipfile import ZipFile

archive_path = Path(__import__("sys").argv[1])
audio_suffixes = {".aac", ".aif", ".aiff", ".flac", ".m4a", ".mid", ".midi", ".mp2", ".mp3", ".oga", ".ogg", ".opus", ".wav", ".weba", ".wma"}
with ZipFile(archive_path) as archive:
    names = archive.namelist()
    assert names == sorted(names), "archive entries are not deterministic"
    assert "manifest.json" in names, "manifest is missing"
    assert not any(Path(name).suffix.lower() in audio_suffixes for name in names), "archive contains audio"
PY

if command -v devstudio >/dev/null 2>&1; then
  devstudio validate --repo "$repo_root"
else
  echo "devstudio not available; skipping DevStudio validation"
fi
