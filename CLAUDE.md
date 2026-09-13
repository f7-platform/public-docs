# public-docs — Claude Code Instructions

## Repo Identity

- **Repo:** `public-docs` — the F7 Trust Center, the customer-facing documentation site for Atlas (VitePress)
- **Language:** Markdown + VitePress config (TypeScript)
- **Key directories:** `content/overview/`, `content/security/`, `content/privacy/`, `content/compliance/`, `content/legal/`
- **Role:** Public-facing documentation for customers, prospects, and compliance reviewers
- **Product scope:** Atlas only. The earlier F7 workforce-analytics product (device agent, controller, dashboards) was shelved in September 2026; its pages were removed and its legal documents carry a notice. Do not reintroduce it as a current product.

## Content Accuracy Rules

1. **Every technical claim must match implemented code.** Do not document planned or aspirational features as current capabilities. The four status words are shipped, built, designed, not built — and a page may only say "shipped" in the present tense.
2. **No proprietary implementation details.** Do not expose:
   - Model names or prompt contents (name the provider company where data goes, because a privacy disclosure must; never the model)
   - Rate-limit numbers, internal crate names, internal endpoint paths, or error codes
   - Internal architecture decisions or ADR references
3. **State limits as limits.** No hardware security module custody, no SOC 2 report, no independent penetration test report, no published SBOM, no Rewind submission path — each is stated as absent, never as planned, and never omitted where a reader would assume it.
4. **Legal pages are counsel's.** `content/legal/` carries documents written for the earlier product plus the Atlas Rewind subsection reviewed on 2026-09-09. Do not rewrite them; Atlas's own terms and privacy policy land there when they leave legal review.
5. **Audit baseline — single source of truth:** the current security-audit run is the `audit_run` value in `content/compliance/claims-registry.json`. Nothing else in this repo may hardcode it (this file deliberately does not name a run). Bump it with one command:

   ```bash
   npm run bump:audit-run -- <N>   # updates the registry + every public "Run N" mention
   ```

   `npm run check:claims` then fails if any published page, contributor doc, or the live `CHANGELOG.md [Unreleased]` section cites a run other than the baseline — including superseded ones. Released `CHANGELOG.md` sections are historical record and are exempt (they must not be rewritten to match a newer baseline).
6. **Register material claims.** A new public claim gets a `claims-registry.json` entry with evidence paths into the owning repository before the page ships; `check-public-claims.sh` verifies the paths wherever the sibling repository is checked out.

## Verification Sources

| Claim Domain | Verify Against |
|-------------|----------------|
| What the instance holds and what leaves it | `fseven-atlas-mvp/apps/atlas-app/src/legal/privacy-policy.md` (the in-app policy of record) and the outbound modules it describes under `fseven-atlas-mvp/apis/atlas-serve/src/` |
| Deployment models, offline licensing, the bundled database | `fseven-atlas-mvp/apis/atlas-serve/src/bundled_pg.rs`, `license/`, `gateway_client/` |
| Accounts, second factors, sessions, the auth event log | `fseven-atlas-mvp/apis/atlas-serve/src/auth/` |
| Signing envelopes and the ledger | `fseven-atlas-mvp/crates/atlas-schemas/src/signed.rs`, `crates/atlas-controller/migrations/`, `apis/atlas-serve/src/export/` |
| Key custody boundary | `fseven-atlas-mvp/crates/atlas-cli/src/signer/mod.rs` — its header states what F7 does not ship |
| Download and update integrity | `public-atlas-binaries/README.md`, `fseven-atlas-mvp/apis/atlas-serve/src/update.rs` |
| Rewind | `fseven-atlas-mvp/apps/atlas-app/src/legal/privacy-policy.md` section 5 and `terms-of-use.md` section 9 |
| Positioning vocabulary | `fseven-docs/docs/marketing/messaging-house.md` §10 — retired terms never appear here |

## Pre-Push CI Gate

**Before pushing any changes**, verify the VitePress site builds without errors.
CI (`.github/workflows/deploy.yml`) is **npm-authoritative** (`npm ci` against
`package-lock.json`), so use npm locally too — do not commit a `pnpm-lock.yaml`
(it is git-ignored to keep a single authoritative lockfile):

```bash
npm ci && npm run test:claims && npm run check:claims && npm run build
```

Never push content that breaks the docs build. Fix locally first — do not iterate on CI remotely.

## Critical Reminders

- **No sprint docs, handoff docs, or completion summaries anywhere in the platform.**
- Public docs must never expose information that would help an attacker (specific versions, internal paths, key material details).
- When in doubt about whether a feature is implemented, check the code — do not assume.
