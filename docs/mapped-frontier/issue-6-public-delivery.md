---
title: Mapped-Frontier Build Packet - Public Polyhydra delivery for Bedrock C418 Fixes
status: draft
owner: "@lancer1977"
issue: https://github.com/lancer1977/Minecraft-Bedrock-C418/issues/6
created: 2026-07-23
updated: 2026-07-23
canonical_mfd_plugin: mapped-frontier-development@1.0.0
canonical_mfd_revision: 2b63e8ab6dd21d95da54bc69062c6df873a063eb
---

# Mapped-Frontier Build Packet: Public Polyhydra delivery for Bedrock C418 Fixes

## Intent

Move the currently private `lancer1977/Minecraft-Bedrock-C418` repository to the
exact organization `Polyhydra-Games`, make it public only after public-readiness
gates pass, and ship a real Bedrock resource-pack artifact that a fresh user can
discover, download, install, enable, and verify. GitHub remains the authority for
source, issue #6, review, CI, release, and delivery evidence. GitHub Release is
the immutable source artifact; the approved Polyhydra CDN and Dread catalog are
the customer discovery and download surfaces.

The proposed final repository is `Polyhydra-Games/bedrock-c418-fixes`. The
product owner must explicitly accept that rename or select a different final name
before transfer. The current repository name is retained until that decision and
all pre-transfer gates are green.

Success means the same SHA-256-identified `.mcpack` bytes are available from an
immutable GitHub Release and the approved CDN/Dread catalog, then installed and
enabled on one documented supported Bedrock client with recorded behavior proof.

Non-goals: publishing C418 recordings, Minecraft assets, private source material,
or credentials; claiming affiliation with Mojang, Microsoft, C418, or a store;
operating a Minecraft server; silently changing repository visibility; creating
secrets; implementing the distribution workflow in this Phase 0 change; or
claiming public, release, CDN, catalog, or client-install success before evidence.

## Current behavior

The repository is private at `lancer1977/Minecraft-Bedrock-C418`, default branch
`main`, and has no GitHub Releases, Pages site, Actions secrets, or Actions
variables as of 2026-07-23. The authenticated operator is an active admin of
`Polyhydra-Games`. Existing CI validates the manifest and packages
`dist/Poly-C418-Fixes.mcpack` as an ephemeral Actions artifact.

`mod/manifest.json` currently declares `Poly C418 Fixes`, version `1.0.0`, a
resource module, and minimum engine version `1.13.0`. `scripts/package.sh` makes
an archive from `mod/`; current tracked media is only `mod/pack_icon.png` (13,346
bytes). Preliminary object-name and largest-blob inventories found no tracked or
historical `.mp3`, `.ogg`, `.wav`, `.flac`, `.mcpack`, or `.zip` blob and no blob
larger than that icon. This is limited inventory evidence, **not** a secret scan,
copyright clearance, or a Gitleaks result.

The repository has no license file. Its older documentation and conversion
scripts describe C418 recordings, but the current tree contains no audio payload
or sound override files. Therefore the current generated archive can demonstrate
package integrity and client installation only; it must not be described as
replacing music until a separately approved, lawful asset/behavior contract is
implemented and proved.

## Behavior map

### Primary journey: safe public delivery

1. The product owner approves this immutable packet on issue #6.
2. The implementation PR records a complete current-tree and all-reachable-history
   audit, licensing/attribution decision, deterministic artifact contract, and
   transfer/runbook controls. Any finding that requires rewrite, removal, legal
   clearance, or secret rotation stops the public path and returns a deviation.
3. A reviewer verifies the exact PR head and required CI. A final safety recheck
   runs against that exact head immediately before transfer.
4. An authorized organization administrator transfers the repository to
   `Polyhydra-Games` with the approved final name. It remains private through the
   transfer and redirect/link verification.
5. An authorized administrator makes the transferred repository public only when
   all audit and license gates are explicitly green.
6. CI creates the approved versioned archive and SHA-256 checksum. A GitHub
   Release attaches those immutable bytes; the CDN then serves the same digest and
   Dread lists that canonical CDN URL and checksum.
7. A fresh supported Bedrock client downloads the documented artifact, opens it,
   enables it in Global Resources, restarts/reloads as required, and captures the
   declared behavior proof without exposing private account data.

### Failure and recovery states

| State | Required behavior and recovery |
| --- | --- |
| Secret, private metadata, generated archive, or questionable media is found | Stop transfer/publication. Preserve evidence privately, open a remediation issue, rotate/revoke through the secret owner when warranted, and repeat the audit on rewritten history or corrected tree. |
| No defensible rights for an audio, Minecraft, C418, icon, or other asset | Do not publish that asset or release a pack claiming that behavior. Remove/replace it with owned or properly licensed material, or keep the repository private. |
| Final repository-name decision changes | Keep repository private; update the packet through a material-deviation brief and obtain a new immutable approval before transfer. |
| Release archive checksum differs from CDN download | Do not publish/catalog the CDN URL. Withdraw the CDN object, invalidate the affected cache path, republish only the release-matching bytes, and record the incident. |
| Bedrock import, enable, or declared behavior fails | Mark the release unsupported, delist the catalog entry or label it withdrawn, point users to the last verified version, and open a corrective issue. |
| Transfer breaks Actions, URLs, webhooks, or catalog metadata | Keep or restore private visibility; repair immutable references and integration configuration, verify redirects and CI, then resume the gate. |

### Acceptance scenarios

| Scenario | Actor | Observable result |
| --- | --- | --- |
| S1: pre-public audit | Maintainer/reviewer | Current tree and all reachable history have auditable secret, privacy, media, and provenance evidence; open findings block visibility. |
| S2: lawful public identity | Maintainer/user | Public repository has the approved organization/name, license, attribution, and non-affiliation boundary; no claim exceeds verified content. |
| S3: immutable release | User | GitHub Release `vX.Y.Z` exposes versioned `.mcpack` and SHA-256 checksum whose bytes validate locally. |
| S4: catalog delivery | User | Dread catalog links to approved CDN bytes with the exact release checksum and a durable release/detail page. |
| S5: fresh install and enable | Fresh Bedrock user | The pack opens/imports, appears in Global Resources, enables, and demonstrates the approved declared behavior on the documented client/version. |
| S6: rollback and delisting | Operator/user | A bad release can be delisted and cache-invalidated while users are directed to a known-good immutable release. |

## UI proof

The pack itself has no browser UI. The required customer-facing proof is a
versioned Dread catalog detail page or equivalent approved store record showing
the product name, compatibility, version, release notes, SHA-256, license and
attribution link, download action, install steps, support contact, and a clear
non-affiliation statement. The exact Dread catalog URL, content owner, and visual
reference are unresolved and must be approved before implementation.

Client proof must include non-sensitive screenshots or a short recording of the
Bedrock import confirmation, Global Resources listing, enabled state, and the
declared behavior. Do not capture account identifiers, gamertags, private worlds,
or unlicensed audio in public evidence.

## Technical contract

### Ownership and repository move

- Source owner before transfer: `lancer1977/Minecraft-Bedrock-C418`.
- Required destination organization: `Polyhydra-Games`.
- Proposed final destination: `Polyhydra-Games/bedrock-c418-fixes`; approval must
  state the accepted final name.
- Transfer preserves GitHub redirect behavior where GitHub supports it, but all
  repository-owned references must be searched and updated: `polyhydra.project.json`,
  workflow reusable-action references, documentation, package metadata, badges,
  catalog records, webhooks, external cloning instructions, and deploy templates.
- Before public visibility, verify branch protections, Actions permissions,
  repository metadata, collaborator/team access, issue/PR links, and external
  integrations under the destination owner. No workflow may depend on a
  user-owned repository URL after the approved move except intentional redirects.

### Public-readiness audit gate

The implementation phase must create a private, reviewable audit record for the
exact candidate commit and all reachable Git history. It must include:

1. A fresh mirror or equivalent all-ref inventory, including commits, annotated
   tags, notes where applicable, LFS pointers/objects, submodules, releases,
   Actions artifacts, repository settings, commit messages, and issue/PR
   attachments that could become public or link from public material.
2. A pinned secret scanner invocation (Gitleaks or an approved equivalent), its
   version/configuration, redacted result, and manual triage. This packet does
   **not** claim that Gitleaks has run or passed.
3. Extension, MIME, size, and provenance inventory of every current and historic
   binary. Current preliminary evidence is limited to a 13,346-byte
   `mod/pack_icon.png`; it is not final legal clearance.
4. Review of author/committer email exposure, local paths, private hosts, IPs,
   tokens, credentials, proprietary source, personal data, and generated output.
5. A decision for every finding: remove before publication, preserve under a
   documented right, or block/rewrite history. Never paste a discovered secret or
   unlicensed payload into an issue, PR, or CI log.

### License, attribution, and content boundary

- Add an explicit license only for rights the project owner controls. The
  recommended code/documentation license is MIT, subject to product-owner/legal
  confirmation; it grants no C418, Mojang, Microsoft, Bedrock, or third-party
  asset rights.
- Create an attribution and trademark notice that names the actual authors and
  rights basis for `pack_icon.png`, manifest text, scripts, and every distributed
  asset. Unknown provenance blocks public distribution.
- Use Minecraft, Bedrock, Mojang, Microsoft, and C418 names only descriptively
  where legally appropriate; include a non-affiliation/non-endorsement statement.
- Do not distribute C418 recordings, derived audio, Minecraft game files, or
  other copyrighted content without a documented distribution right. Track names
  and conversion scripts alone are not a right to distribute the recordings.
- Before release, the artifact inventory must match the approved license/
  attribution manifest exactly. A release with no approved audio must describe
  only its verified non-audio behavior.

### Artifact and version contract

- `mod/manifest.json` header and resource module use the same SemVer triplet.
  Any behavior or content change increments the appropriate triplet and release
  tag; do not rewrite a released version.
- CI produces `Poly-C418-Fixes-vX.Y.Z.mcpack` from the exact release commit,
  excludes nested archives and non-runtime source, validates the ZIP, and emits
  `SHA256SUMS.txt` using SHA-256. The release record names the commit SHA and
  checksum.
- GitHub Release tag `vX.Y.Z` is immutable source-of-truth release evidence;
  release assets are not replaced. CDN paths are immutable, for example
  `/minecraft/bedrock-c418-fixes/releases/vX.Y.Z/`, and a versioned catalog
  manifest binds download URL, Git commit, manifest version, checksum, release
  notes, compatibility, and license URL.
- The CDN may expose a mutable `latest` index only if it is cache-controlled,
  checksumed, and points to an immutable version path. It must never overwrite
  immutable release bytes.

### Delivery, observability, and secrets

- Delivery chain: reviewed source commit -> trusted CI artifact -> immutable
  GitHub Release -> checksum comparison -> approved CDN origin -> Dread catalog
  record -> fresh client proof.
- Record release tag, source SHA, artifact SHA-256, CDN URL/digest response,
  catalog URL, client platform/version, tester role, date, and rollback target in
  release evidence. No telemetry or player-session collection is introduced.
- Current inventory is empty: no repository Actions secrets or variables. Future
  CDN/catalog publishing credentials, if required, must first have an
  Infisical stub in the owning project/environment/path and an issue-local
  description of source and use. The actual secret value must be set only by its
  owner and mapped into GitHub Actions minimally. No secret is created in Phase 0.
- The exact Infisical project/environment/path and CDN/Dread integration owner are
  unresolved; implementation cannot add a publishing credential until they are
  approved.

## Verification map

| Requirement | Scenario | Validation | Expected evidence |
| --- | --- | --- | --- |
| R1: public-readiness gate | S1 | Run pinned all-ref secret scan, binary/provenance inventory, LFS/submodule/release/settings review, and manual privacy triage without logging sensitive values. | Private audit report tied to candidate SHA; all findings resolved or blocking. |
| R2: legal/content boundary | S1, S2 | Review every distributed file against license/attribution manifest; verify icon provenance and trademark/disclaimer text. | Reviewed license, notices, asset inventory, and explicit approval or blocker. |
| R3: organization/name transfer | S2 | On a private transferred copy, verify destination owner/name, redirects, permissions, issue/PR URLs, Actions, reusable workflow references, and external links. | Transfer checklist, link/CI evidence, and final safety recheck on exact head. |
| R4: deterministic artifact | S3 | Run repository validation; build twice from the exact tag; inspect archive inventory; validate ZIP; calculate SHA-256; compare artifact bytes or explain permitted metadata variance. | CI logs, artifact inventory, checksum file, tag/commit association, and release asset URLs. |
| R5: canonical distribution | S3, S4 | Download GitHub Release and CDN artifacts independently; calculate SHA-256; verify catalog metadata equals the immutable release record. | Matching digests, HTTP/cache headers, CDN URL, catalog URL, and release evidence. |
| R6: client journey | S5 | On a fresh supported Bedrock client, download, open/import, enable in Global Resources, reload/restart, and observe the approved declared behavior. | Sanitized screenshots/recording, platform/client version, install notes, and pass/fail record. |
| R7: recovery | S6 | Exercise a staging or deliberately withdrawn catalog entry; verify immutable prior-version availability, catalog delist behavior, CDN purge/invalidation, and user guidance. | Timestamped rollback runbook evidence and a known-good version link. |
| R8: secret hygiene | S1, S3 | Confirm repository and workflow secret inventory by name only; if a publish credential is needed, verify its Infisical stub and minimal GitHub mapping without reading values. | Redacted inventory, Infisical folder URL/path, and Actions secret-name verification. |

## Delivery map

| Order | GitHub issue / card | Requirement / scenario | Dependencies | Validation |
| --- | --- | --- | --- | --- |
| 1 | [#6](https://github.com/lancer1977/Minecraft-Bedrock-C418/issues/6) / Hermes Kanban: pending promotion | Approve this immutable Phase 0 packet and final repository name. | Product-owner decision | Issue comment naming exact packet commit. |
| 2 | #6 implementation PR to `main` | R1, R2, R8: audit harness/record, license and attribution boundary, secret-source plan. | Approved packet; legal/asset owner input | Exact-head review and audit evidence. |
| 3 | #6 implementation PR to `main` | R4: deterministic versioned package, checksum, release controls, and runbooks. | R1/R2 green | CI artifact and checksum validation. |
| 4 | #6 authorized transfer operation | R3: transfer privately to `Polyhydra-Games` using approved name; repair links/integrations. | PR merged; destination org admin; final safety recheck | Transfer checklist and green post-transfer CI. |
| 5 | #6 authorized visibility operation | R2/R3: make the transferred repository public. | All public-readiness, license, and transfer gates green | Exact visibility/settings evidence. |
| 6 | #6 release operation | R4/R5: create immutable GitHub Release, publish checksum-matching CDN object and Dread catalog record. | Public repo; approved CDN/Dread ownership and credentials | Digest comparison and catalog evidence. |
| 7 | #6 client-proof operation | R6/R7: fresh supported-client proof and proportionate rollback/delist rehearsal. | Release/CDN/catalog live | Sanitized client and rollback evidence. |

### Rollout and rollback

Promotion proceeds only in this order: private source and review -> private
post-transfer verification -> public repository -> immutable GitHub Release ->
CDN object -> Dread catalog listing -> fresh-client proof. A GitHub Release is
not customer delivery until the approved CDN/catalog journey and client proof
are complete.

The rollback target is the previous checksumed immutable GitHub Release and CDN
path. For a bad release, stop promotion, remove or clearly withdraw the Dread
listing, redirect users to the last known-good version, purge only the affected
mutable CDN index/path, preserve immutable version bytes for forensic/recovery
needs unless legal removal requires otherwise, and publish a transparent release
note. If copyright or secrecy is implicated, immediately stop public access and
follow the rights/security remediation decision instead of preserving the asset.

## Risks and unresolved decisions

| Item | Owner | Resolution or escalation condition |
| --- | --- | --- |
| Final repository name | Product owner (`@lancer1977`) | Approve proposed `bedrock-c418-fixes` or name an alternative before transfer. |
| Rights to C418/Minecraft-related assets and claims | Product owner with rights/legal owner | Written provenance/rights decision for every distributed asset; absent proof blocks public artifact delivery. |
| `pack_icon.png` provenance | Asset owner | Establish original/authorized source and license; replace it if unknown. |
| Current pack has no audio/sound override payload | Product owner | Decide whether public V1 is an installation-only scaffold or defer release until lawful, verified behavior exists. Do not market it as music replacement otherwise. |
| License choice | Product owner | Confirm a license for owned source/docs only and publish matching notices. |
| Supported Bedrock client matrix | Product owner/test owner | Name at least one supported platform and client version before client proof. |
| Dread catalog and CDN owner/path | Delivery owner | Approve exact catalog URL, CDN hostname/origin/path, cache policy, and support contact before implementation. |
| Publishing credential source | Secret owner | Create only an Infisical stub after destination is approved; map least privilege secret by name, never value. |
| Transfer timing and public visibility authority | Organization administrator | Schedule transfer only after final exact-head audit and private post-transfer verification. |
| GitHub redirect and integration drift | Implementation owner | Inventory and prove all owned links, workflows, webhooks, and catalog references after transfer. |

## Approval

- Product owner: `@lancer1977`
- Decision: Pending
- Date: Pending
- Approved commit or immutable revision: Pending
- Approval evidence: Pending GitHub issue #6 decision comment
- Approval brief: Pending post-commit brief tied to this packet revision

Approval authorizes scoped implementation only. It does not authorize merge,
transfer, public visibility, deployment, issue closure, secret access or
rotation, external communication, a GitHub Release, CDN/catalog publication, or
a production-success claim.

## Deviations

| Date | Requirement / boundary | Decision | Approver | Follow-up |
| --- | --- | --- | --- | --- |
| None | None | None | None | None |

## Release controls and closeout evidence

- Target branch: `main`
- Pull request: Pending; this Phase 0 packet is submitted as one draft PR directly to `main` for review, not a release PR.
- Required reviewers: Product owner approval of exact packet revision; fresh independent exact-head review for the eventual transfer/public-readiness implementation PR.
- CI and validation evidence: Packet structure validation, `bash scripts/validate.sh`, and exact-head PR checks; release/client/CDN evidence remains pending implementation.
- Deployment authority: Separate explicit authority is required for transfer, visibility change, GitHub Release, CDN publish, Dread catalog publish, and any credential mapping.
- Live verification: Pending; requires the approved fresh Bedrock install/enable/behavior scenario.
- Rollback evidence: Pending; requires release/catalog rollback rehearsal.
- Deferred follow-ups: Any lawful audio/content implementation, client-matrix expansion, or store expansion not explicitly approved by this packet.
