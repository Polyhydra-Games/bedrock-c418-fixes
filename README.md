# Poly C418 Fixes

Minecraft Bedrock resource-pack fixes packaged as a user-installed `.mcpack`
archive.

## Validate and package

Run the repository-native validator:

```bash
bash scripts/validate.sh
```

It verifies the resource-pack manifest, shell packaging helpers, and a
temporary `.mcpack` archive. This repository does not operate a Minecraft
server, telemetry sidecar, or player-session control surface.

## Documentation

- [Documentation index](docs/README.md)
- [Support-ladder decision](docs/decisions/support-ladder-decision.md)
