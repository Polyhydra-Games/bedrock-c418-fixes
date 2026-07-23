# Private public-readiness audit runbook

This runbook is a pre-transfer, pre-visibility gate. It is designed for a
trusted private runner and must not upload reports as Actions artifacts, print
findings to logs, or run on forked pull requests.

## Preconditions

- The candidate SHA is reviewed and the repository remains private.
- The private runner has exactly the GitHub Actions labels `self-hosted`,
  `Linux`, `X64`, `pr-validation`, and `minecraft-c418`, plus `git`,
  `gitleaks` version `8.30.0`, and a protected operator-owned report volume
  outside the checkout. These labels are selected only for owner-authored,
  same-repository pull requests; forks and other untrusted pull requests use
  hosted `ubuntu-latest` and receive no secret mapping.
- The report directory is access-controlled to the audit/release owners. It is
  not a GitHub Actions artifact, repository path, issue attachment, or public
  log location.

## Run the all-history audit

Set `POLYHYDRA_AUDIT_REPORT_DIR` to an absolute protected **base** directory
outside the checkout and set the numeric GitHub repository ID separately. The
script rejects an empty, root, relative, or checkout-local base before it
appends the repository ID, then runs the exact candidate checkout:

```bash
POLYHYDRA_AUDIT_REPORT_DIR=/var/lib/polyhydra-audits/bedrock-c418 \
GITHUB_REPOSITORY_ID=123456789 \
GITLEAKS_VERSION=8.30.0 \
bash scripts/audit-public-readiness.sh
```

The command inventories all reachable refs, notes, submodules, LFS state,
objects, and Git integrity data, then runs redacted Gitleaks across `--all`
history. It writes detailed evidence only to the protected report directory.
Console output intentionally reports only pass/blocked status. A blocked result
must be triaged privately; do not paste raw matches, tokens, private paths, or
unlicensed payload into GitHub.

## Required manual review

Review the protected record for binary MIME/size/provenance, author and
committer metadata, private hosts/IPs/paths, releases and Actions artifacts,
submodules/LFS, generated output, repository settings, issue/PR attachments,
and links that could become public. Record only a redacted summary tied to the
candidate SHA. Any secret, personal data, rights gap, or questionable asset
blocks transfer and visibility until remediated and rescanned.

## Transfer and public-readiness checklist

- [ ] Every distributed file, including `mod/pack_icon.png`, has a
      verified-owned 0BSD record in `docs/asset-provenance.json`; the automated
      provenance validator passes with no missing or stale entries.
- [ ] The manifest and public docs make no unproven audio-replacement claim.
- [ ] Candidate audit is pass with manual triage complete.
- [ ] Destination organization, final repository name, branch protections,
      Actions permissions, collaborators, webhooks, and external links are
      verified while private after transfer.
- [ ] A fresh independent reviewer approves the exact candidate head.
- [ ] Separate authorization is obtained for visibility, release, CDN, catalog,
      and client-proof operations.
