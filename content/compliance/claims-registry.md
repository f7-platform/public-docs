# Public Claims Registry

The public claims registry (`claims-registry.json` in this directory) is a machine-readable index of every material claim made across these public-docs pages. It maps each claim to its source evidence, audit references, SOC 2 criteria, and current release status.

## Purpose

1. **Accuracy enforcement** — `scripts/check-public-claims.sh` reads the registry and fails CI if any `not-available` claim appears in content.
2. **Audit traceability** — each claim links back to the audit run finding IDs that drove its inclusion.
3. **Release gate** — the registry is reviewed each release cycle; claims with `in-progress` status must be promoted or downgraded before major public releases.

## Release Status Values

| Status | Meaning |
|---|---|
| `active` | Feature ships and the claim is accurate |
| `in-progress` | Feature is in development; claim is scoped/qualified on the page |
| `not-available` | Feature not yet shipped; claim is **forbidden** from appearing in content |

## Maintenance

When adding a new public claim:

1. Add an entry to `claims-registry.json` with an evidence reference and `release_status`.
2. If status is `not-available`, add a `check_absent` pattern to `scripts/check-public-claims.sh`.
3. Run `bash scripts/check-public-claims.sh` locally before committing.
4. Reference the claim ID in any PR description that adds content touching the claim.

## Viewing the Registry

The registry is a JSON file at [claims-registry.json](./claims-registry.json). It can be viewed with any JSON viewer or validated with:

```bash
bash scripts/check-public-claims.sh
```
