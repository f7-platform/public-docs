# Public Claims Registry

The public claims registry (`claims-registry.json` in this directory) is a machine-readable index of every material claim made across these public-docs pages. It maps each claim to its source evidence, audit references, SOC 2 criteria, and current release status.

## Purpose

1. **Accuracy enforcement** — `scripts/check-public-claims.sh` reads the registry and fails CI if the summary registered for a `not-available` claim, or any entry in a claim's `forbidden_phrases` list, appears on any page under `content/`. Each is matched as an exact phrase, ignoring letter case. It is a phrase check: wording that describes the same unshipped feature in words the registry does not list is not caught by it.
2. **Audit traceability** — each claim links back to the audit run finding IDs that drove its inclusion.
3. **Release gate** — the registry is reviewed each release cycle; claims with `in-progress` status must be promoted or downgraded before major public releases.

## Release Status Values

| Status | Meaning |
|---|---|
| `active` | Feature ships and the claim is accurate |
| `in-progress` | Feature is in development; claim is scoped/qualified on the page |
| `not-available` | Feature not yet shipped; the summary registered here is **forbidden** from appearing on any page under `content/`, and CI fails when it does |

## Forbidden Phrases

A claim may carry an optional `forbidden_phrases` list: other wordings of the claim that must never be published. CI fails when any of them appears on a page under `content/`, matched the same way as a `not-available` summary — the exact phrase, ignoring letter case. The list is enforced on every claim that carries it, whatever its release status, and CI also fails if an entry is blank. A page may still name an unshipped feature, for example to say it is planned, as long as it uses none of the listed phrases.

## Maintenance

When adding a new public claim:

1. Add an entry to `claims-registry.json` with an evidence reference and `release_status`.
2. If status is `not-available`, the summary you register is enforced on its own — CI fails if that exact phrase is published. For every *other* wording of the same unshipped claim that must never appear, add it to that claim's `forbidden_phrases` list. Choose phrases that assert the feature as current and that no accurate page, including one describing the feature as planned, would contain.
3. Run `bash scripts/check-public-claims.sh` locally before committing.
4. Reference the claim ID in any PR description that adds content touching the claim.

## Viewing the Registry

The registry is a JSON file at [claims-registry.json](./claims-registry.json). It can be viewed with any JSON viewer or validated with:

```bash
bash scripts/check-public-claims.sh
```
