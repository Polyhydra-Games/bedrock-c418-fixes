# Public delivery contract

This repository is currently private. Nothing in this document authorizes a
transfer, visibility change, GitHub Release, CDN publish, Dread catalog entry,
or client-delivery claim. Those are separate gates in [issue #6](https://github.com/lancer1977/Minecraft-Bedrock-C418/issues/6).

## Delivery destination map

| Surface | Role | Required proof before it is called delivered |
| --- | --- | --- |
| GitHub repository | Source, issue/review, CI, tags, and release authority. Proposed destination after a separate private transfer: `Polyhydra-Games/bedrock-c418-fixes`. | Transfer checklist, destination permissions, exact-head review, and public-readiness audit. |
| GitHub Release | Immutable source artifact. | A signed/approved `vX.Y.Z` tag, `Poly-C418-Fixes-vX.Y.Z.mcpack`, `SHA256SUMS.txt`, and source commit recorded together. Existing release assets are never replaced. |
| Approved Polyhydra CDN | Customer byte transport. | An approved immutable version path, correct content type, cache policy, checksum comparison with the GitHub Release, and a documented invalidation owner. |
| Dread catalog | Discovery, install guidance, compatibility, notices, and support. | A detail record with the immutable CDN URL, exact checksum, release notes, license/notices, support contact, and withdrawal guidance. |
| Supported Bedrock client | Actual user delivery. | Sanitized proof that a fresh supported client imports, lists, enables, and demonstrates the approved behavior. |

The exact CDN hostname, Dread record URL, content type, cache TTL, invalidation
mechanism, support owner, and supported client version are intentionally unset.
They must be approved before a publish workflow or destination credential is
implemented. No external IDs or credentials belong in this repository.

## Artifact contract

`bash scripts/package.sh` reads `mod/manifest.json` and writes a deterministic
artifact named `Poly-C418-Fixes-vX.Y.Z.mcpack`, where `X.Y.Z` is the same
three-part version in the manifest header and resource module. It writes a
SHA-256 entry to `SHA256SUMS.txt` beside the artifact. The archive uses sorted
entries and fixed ZIP metadata so two builds from the same tree have identical
bytes.

The package is deliberately audio-free. It contains only runtime files from
`mod/`, rejects audio and nested archive payloads, and must not be described as
replacing music unless a later approved rights and behavior packet proves that
claim.

## Future operator sequence

1. Pass the private all-history audit and resolve every rights/provenance gate.
2. Transfer privately, repair owned links and integrations, then obtain a final
   exact-head recheck before a separately authorized public visibility change.
3. Create the approved tag and use the manual release workflow. It validates the
   tag/version, produces the artifact and checksum, and refuses to modify an
   existing release.
4. Independently hash the GitHub Release and approved CDN downloads. Do not
   create or promote the Dread catalog record unless the digests match.
5. Record the catalog URL, CDN response content type/cache headers, client
   platform/version, sanitized import/enable evidence, and rollback target on
   issue #6 or its approved release evidence.

## Install, update, and rollback (after an approved release)

1. Download the versioned `.mcpack` only from the approved catalog/CDN link.
2. Verify its SHA-256 against that release's `SHA256SUMS.txt`.
3. Open the verified file with a supported Bedrock client, import it, and enable
   it in **Global Resources**. Restart or reload only if the supported-client
   instructions require it.
4. For an update, repeat those steps with a newer immutable version; do not
   overwrite or relabel an older release.
5. For rollback, disable/remove the affected version and import the prior
   known-good immutable artifact named in the catalog guidance. Operators
   withdraw the catalog entry, point users to that known-good version, and purge
   only mutable CDN indexes/paths—never silently replace immutable bytes.

Do not publish screenshots containing account identifiers, gamertags, private
worlds, or unlicensed audio.
