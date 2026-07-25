# Poly C418 Fixes

Audio-free Minecraft Bedrock resource-pack packaging scaffold, delivered as a
user-installed `.mcpack` archive only after the public-readiness gates pass.

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
- [Public delivery contract](docs/public-delivery.md)
- [Private public-readiness audit](docs/public-readiness.md)
- [Third-party names and asset boundary](THIRD_PARTY_NOTICES.md)
