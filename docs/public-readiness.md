# Private public-readiness audit runbook

This runbook is a pre-transfer, pre-visibility gate. It is designed for a
trusted private runner and must not upload reports as Actions artifacts, print
findings to logs, or run on forked pull requests.

## Preconditions

- The candidate SHA is reviewed and the repository remains private.
- The private runner has `git`, `gitleaks` version `8.30.0`, and a protected
  operator-owned report volume outside the checkout.
- The report directory is access-controlled to the audit/release owners. It is
  not a GitHub Actions artifact, repository path, issue attachment, or public
  log location.

## Run the all-history audit

Set `AUDIT_REPORT_DIR` to an absolute protected directory outside the checkout,
then run the exact candidate checkout:

```bash
AUDIT_REPORT_DIR=/var/lib/polyhydra-audits/bedrock-c418 \
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

- [ ] `mod/pack_icon.png` has a documented ownership/license decision in
      `THIRD_PARTY_NOTICES.md`, or it has been replaced and reviewed.
- [ ] Every distributed file matches the license/attribution inventory.
- [ ] The manifest and public docs make no unproven audio-replacement claim.
- [ ] Candidate audit is pass with manual triage complete.
- [ ] Destination organization, final repository name, branch protections,
      Actions permissions, collaborators, webhooks, and external links are
      verified while private after transfer.
- [ ] A fresh independent reviewer approves the exact candidate head.
- [ ] Separate authorization is obtained for visibility, release, CDN, catalog,
      and client-proof operations.
