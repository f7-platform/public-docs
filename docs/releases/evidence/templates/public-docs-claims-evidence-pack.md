# Release Evidence Pack — Public Docs Claims Accuracy
<!--
  Template: fill one copy per public-docs release or significant content update.
  File as: docs/releases/evidence/public-docs-claims-{YYYYMMDD}.md
-->

## Release Metadata

| Field | Value |
|---|---|
| Review date | YYYY-MM-DD |
| Docs version / tag | _(git tag or commit SHA)_ |
| Reviewer | _(name)_ |
| Claims registry version | _(SHA of claims-registry.json)_ |

## Pre-Release Check Script

```bash
cd public-docs
bash scripts/check-public-claims.sh
```

- [ ] Script exits 0 (no forbidden claims found)
- [ ] Paste output here:

```
(paste script output)
```

## Claims Registry Audit

Review every claim in `content/compliance/claims-registry.json`:

| Claim ID | Summary | Current Status | Verified Accurate? | Notes |
|---|---|---|---|---|
| CLM-001 | Privacy by design | active | ✅ / ❌ | |
| CLM-002 | Encryption in transit and at rest | active | ✅ / ❌ | |
| CLM-003 | Employee data access controls | active | ✅ / ❌ | |
| CLM-004 | SOC 2 controls implemented | in-progress | ✅ / ❌ | |
| CLM-005 | GDPR-compliant data processing | active | ✅ / ❌ | |
| CLM-006 | CCPA opt-out supported | active | ✅ / ❌ | |
| CLM-007 | SOC 2 certification | in-progress | ✅ / ❌ | Scope still "planned"? |
| CLM-008 | Data retention and deletion | active | ✅ / ❌ | |
| CLM-009 | Personal behavioral dashboard | not-available | N/A — forbidden | Confirm absent from content |

## New Claims Check

- [ ] No new capability claims added to content since last review
- [ ] If new claims added: each has a claims-registry.json entry
- [ ] If new claims are `in-progress` or `not-available`: check script updated

## Evidence Signoff

| Reviewer | Date | Notes |
|---|---|---|
| _(name)_ | YYYY-MM-DD | |
