# Mapped-Frontier Phase 0 Approval Brief: Public Polyhydra delivery for Bedrock C418 Fixes

## Decision requested

Review this single brief and record one decision on the owning GitHub issue.

- [ ] **Approve** the immutable packet revision for scoped implementation
- [ ] **Request changes** listed below
- [ ] **Reject** the proposed direction

Approval authorizes only scoped implementation through normal review and release
controls. It does not authorize a merge, transfer, public visibility, release,
CDN/catalog publication, secret access or rotation, external communication, or a
production-success claim.

## Outcome and non-goals

**Outcome:** Transfer the repository to `Polyhydra-Games`, make it public only
after hard public-readiness and licensing gates, then deliver a checksumed Bedrock
`.mcpack` from an immutable GitHub Release through the approved CDN/Dread catalog
and prove fresh-client install, enable, and declared behavior. The proposed final
repository is `Polyhydra-Games/bedrock-c418-fixes`.

**Non-goals:** Publishing C418 recordings, Minecraft assets, credentials, private
material, or unsupported behavior; silently changing visibility; creating
secrets; shipping workflows in Phase 0; or treating a GitHub Actions artifact as
customer delivery.

## Experience and behavior

- Primary journeys: approval -> private public-readiness audit -> private
  Polyhydra transfer -> final safety recheck -> public repository -> immutable
  GitHub Release -> checksum-matching CDN/Dread listing -> fresh Bedrock
  download/import/enable/behavior proof.
- Failure and recovery states: any secret, private metadata, questionable media,
  rights gap, checksum mismatch, broken integration, or failed client journey
  stops promotion; withdraw/delist as appropriate, invalidate the affected
  mutable CDN path, and direct users to the last known-good immutable release.
- UI proof: the future Dread catalog detail page and sanitized Bedrock
  install/Global Resources/behavior evidence are required; no browser UI proof
  exists yet.

## Boundaries requiring judgment

- Technical and integration: GitHub is source/release authority; CDN/Dread are
  customer delivery. Versioned `.mcpack` bytes and SHA-256 must match across
  release and CDN. The final CDN/Dread owner, URL/path, and cache policy are not
  chosen yet.
- Authentication, authorization, privacy, and security: repository stays private
  until all-ref audit, exact-head review, destination permissions, and final
  recheck pass. Current evidence is only preliminary: no Actions secrets or
  variables, no releases/Pages, and no tracked/historical audio/archive blobs;
  it is explicitly not a Gitleaks result or copyright clearance.
- Data, migration, and retention: no player data is introduced. Git history
  becomes public on visibility change, so secrets/private metadata require
  remediation before that point. Release tags/assets and immutable CDN paths are
  retained for rollback unless a legal/security removal is required.
- License and attribution: apply 0BSD only to original owned source, manifests,
  docs, and the icon after its provenance is proved. `THIRD_PARTY_NOTICES.md`
  must make clear that 0BSD grants no rights to Minecraft, Bedrock, Mojang,
  Microsoft, C418, their marks, game content, or music.
- Operations, rollout, rollback, and cost: promotion order is private review,
  private transfer verification, public visibility, GitHub Release, CDN, Dread
  listing, and fresh-client proof. Each external operation needs separate
  authority. Rollback delists the catalog entry and restores a known-good
  immutable version; only affected mutable cache indexes are invalidated.

## Verification summary

| Requirement | Scenario | Planned validation | Expected evidence |
| --- | --- | --- | --- |
| R1 public-readiness | S1 | Pinned all-ref secret/privacy/binary/provenance audit and manual triage. | Private redacted audit tied to candidate SHA; blockers resolved. |
| R2 lawful identity | S2 | License, asset provenance, attribution, and non-affiliation review. | Approved notices and per-asset inventory. |
| R3 transfer integrity | S2 | Verify private destination owner/name, redirects, Actions, links, and permissions. | Transfer checklist and green post-transfer CI. |
| R4/R5 release delivery | S3/S4 | Build/checksum exact tag; compare GitHub Release and CDN bytes; validate catalog metadata. | Matching SHA-256, release/CDN/catalog URLs. |
| R6/R7 client and recovery | S5/S6 | Fresh supported-client install/enable/behavior proof and proportionate rollback rehearsal. | Sanitized proof and rollback record. |

## Delivery destination map

| Destination | Customer or control-plane role | Required proof |
| --- | --- | --- |
| `Polyhydra-Games/bedrock-c418-fixes` | Source, review, CI, tags, and release authority | Private transfer integrity and final public safety check. |
| GitHub Release | Immutable source `.mcpack` and checksum | Version/tag/source SHA and SHA-256 asset evidence. |
| Polyhydra CDN | Public byte transport | CDN download digest equals the GitHub Release digest. |
| Dread catalog | Discovery, install information, and support surface | Catalog detail record carries exact CDN URL, checksum, compatibility, notices, and support. |
| Supported Bedrock client | Actual delivery destination | Fresh import, enable, and declared behavior proof. |

## Delivery summary

| Order | GitHub issue / card | Outcome | Dependencies |
| --- | --- | --- | --- |
| 1 | [#6](https://github.com/lancer1977/Minecraft-Bedrock-C418/issues/6) / Hermes Kanban: pending promotion | Immutable Phase 0 decision and final name choice. | Product-owner decision. |
| 2 | #6 direct-to-`main` implementation PR | Audit, license/attribution, artifact/release controls, and runbooks. | Approved packet and rights input. |
| 3 | #6 authorized transfer/visibility | Private Polyhydra transfer, integration proof, then public visibility. | Exact-head CI/review and safety gates. |
| 4 | #6 authorized release/delivery | GitHub Release, matching CDN/Dread listing, fresh-client proof, and rollback evidence. | Approved distribution owner/path and credentials. |

## Risks and unresolved decisions

| Item | Owner | Recommendation or decision needed |
| --- | --- | --- |
| Final name | `@lancer1977` | Approve `bedrock-c418-fixes` or name an alternative before transfer. |
| 0BSD/license boundary | Product/rights owner | 0BSD covers only original owned material and its required AS-IS/no-warranty/no-liability terms; third-party names/content stay outside it in `THIRD_PARTY_NOTICES.md`. |
| C418/Minecraft content rights | Product/rights owner | No public artifact that includes or claims unproven audio/content behavior. |
| Icon provenance | Asset owner | Prove `mod/pack_icon.png` ownership/license or replace it. |
| Current no-audio pack behavior | `@lancer1977` | Decide whether V1 is installation-only scaffold or defer public release until lawful, verified behavior exists. |
| CDN/Dread destination and secrets | Delivery/secret owner | Choose owner/path/cache/support model, then create Infisical stubs before any credential mapping. |
| Supported client | Test owner | Name at least one Bedrock platform/client version for the release gate. |

## Approval record

- Owning GitHub issue: https://github.com/lancer1977/Minecraft-Bedrock-C418/issues/6
- Immutable build-packet revision: [`6a6e92b7c6412947405f92e66102da47d79f838e`](https://github.com/lancer1977/Minecraft-Bedrock-C418/blob/6a6e92b7c6412947405f92e66102da47d79f838e/docs/mapped-frontier/issue-6-public-delivery.md)
- Product owner: `@lancer1977`
- Decision: Pending
- Decision comment: Pending on issue #6
- Decision date: Pending

## Requested changes

None.

## Material-deviation return

If execution changes the delivery destination, public/rights/security boundary,
artifact contract, name, cache/rollback behavior, credential model, or supported
client, return a focused decision brief naming the affected requirements,
scenarios, risk, and recommended decision before proceeding.

## Closeout delivery

At Phase 4, update or reply to this brief with the exact implementation PR,
transfer/public evidence, audit and rights evidence, release/CDN/catalog digests,
client proof, rollback evidence, deviations, and deferred issues.
