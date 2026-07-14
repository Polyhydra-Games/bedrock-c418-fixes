# Support-Ladder Decision: Keep Parked

## Decision

`Minecraft-Bedrock-C418` remains outside the active V0-V5 service-support
ladder. It is an active Minecraft Bedrock resource-pack repository, not a
game-server or operator-control surface.

## Evidence

- The repository metadata describes a Bedrock resource-pack home with packaging
  helpers.
- The documented deliverable is a user-installed `.mcpack` archive.
- The validated source boundary is `mod/manifest.json` plus the shell and
  PowerShell packaging helpers; there is no declared server process, support
  sidecar, telemetry endpoint, or authenticated operator surface.
- The `deploy/` content is reusable template material and does not define a
  project-specific Dockerfile, image, or runtime contract.

## Ownership

Decision owner: `lancer1977`, the repository owner. The owner must assign a
named implementation owner on GitHub issue #3 before changing this decision or
starting a ladder adoption issue.

## Re-entry Conditions

Adopt the V0-V5 ladder only if a separate, approved scope introduces a real
runtime boundary—for example, a dedicated Bedrock-server integration or a
support/telemetry sidecar. That scope must first state:

1. The runtime boundary and owning repository/service.
2. A non-mutating V0 validation path that runs without a live player session.
3. The first V-layer issue, starting at V0 rather than claiming an operator or
   gameplay-control layer.

Until then, maintain this repository through resource-pack packaging, manifest,
and archive validation only. It must not claim server observability, operator
authority, or gameplay mutation capability.
