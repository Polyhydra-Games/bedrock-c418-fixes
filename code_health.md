# Code Health

## Current state

- Minecraft Bedrock resource-pack/mod repository with shell and PowerShell helper scripts.
- CI validates shell syntax, pack manifest JSON, and DevStudio shape, then uploads a `.mcpack` artifact from `mod/`.
- Generated audio/package outputs are ignored.

## Validation

- `bash scripts/validate.sh`

## Follow-ups

- Add deterministic pack generation tests when the conversion/package command is formalized.
- Keep generated `.ogg`, `.mp3`, `.zip`, and `.mcpack` artifacts out of source control.
