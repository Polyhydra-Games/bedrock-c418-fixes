# Minecraft-Bedrock-C418

**Location:** `~/code/Minecraft-Bedrock-C418`

**Purpose:** Minecraft Bedrock Edition resource pack that replaces default music with C418's original Java Edition soundtrack.

## Tech Stack

- **Type:** Minecraft Bedrock Resource Pack
- **Format:** .mcpack (add-on package)
- **Audio:** OGG Vorbis (converted from MP3)

## Project Structure

```
Minecraft-Bedrock-C418/
├── mp3s/              # Source MP3 files (C418 tracks)
├── converted/         # OGG files converted from MP3s
├── mod/
│   ├── manifest.json  # Pack metadata (UUID, version)
│   ├── mod.mcpack     # Compiled pack (~64MB)
│   ├── pack_icon.png  # Pack icon
│   └── sounds/        # Sound files by category
│       ├── music/game/
│       ├── music/nether/
│       ├── music/end/
│       ├── music/underwater/
│       └── records/
├── alpha.ps1         # Convert alpha tracks
└── update.ps1        # Build pack from converted files
```

## Entry Points

- `mod/manifest.json` — Pack metadata (name: "Poly C418 Fixes")
- `mod/mod.mcpack` — Ready-to-install package
- `alpha.ps1` / `update.ps1` — Build scripts (PowerShell)

## Dependencies

- **ffmpeg** — Audio conversion (MP3 → OGG)
- **PowerShell** — Build scripts

## Build

```powershell
# Convert MP3s to OGG
./alpha.ps1

# Build .mcpack
./update.ps1
```

## Installation

1. Copy `mod/mod.mcpack` to device
2. Open with Minecraft Bedrock
3. Activate in Settings → Global Resources

## Metadata

- **Pack Name:** Poly C418 Fixes
- **UUID:** 6c3fe9c5-2dc1-94c5-0bb6-e199ac29cacd
- **Version:** 1.0.0
- **Min Engine:** 1.13.0
- **Author:** DreadBreadcrumb