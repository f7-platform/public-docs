# GitHub Copilot Instructions — public-docs

See [`CLAUDE.md`](../CLAUDE.md) for the authoritative repo-level contributor guide — Copilot and Claude share the same rules.

## Quick Rules

1. **Atlas only.** This site describes Atlas. The earlier F7 workforce-analytics product (device agent, controller, dashboards) was shelved in September 2026; do not reintroduce it as a current product.
2. **No proprietary details.** Do not expose model names, rate-limit numbers, crate names, internal endpoint paths, or internal error codes. Provider companies that receive data are named because a privacy disclosure must name them.
3. **Audit baseline is single-sourced.** The latest security-audit run lives only in `content/compliance/claims-registry.json` (`audit_run`) — never hardcode it here or anywhere else. Bump it with `npm run bump:audit-run -- <N>`; `npm run check:claims` fails if any public page or contributor doc cites a different run.
4. **CI gate:** `npm ci && npm run test:claims && npm run check:claims && npm run build` must succeed before any PR merges. CI is npm-authoritative (`package-lock.json`); do not commit a `pnpm-lock.yaml` (it is git-ignored).
5. **Cross-check:** the in-app Atlas privacy policy (`fseven-atlas-mvp/apps/atlas-app/src/legal/privacy-policy.md`) and the code it describes are the source for every data-handling claim; `CLAUDE.md` lists the verification path per claim domain.

## File Layout

- `content/overview/` — What Atlas is, how it runs, what it holds
- `content/privacy/` — Principles, the field-level inventory (including Rewind), controls, retention
- `content/security/` — Overview, deployment and trust architecture, accounts, encryption and signing, downloads
- `content/compliance/` — Overview, GDPR, CCPA/CPRA, SOC 2, the claims registry
- `content/legal/` — Documents written for the earlier product, carrying a notice, plus the reviewed Atlas Rewind subsection; counsel's to change

## Forbidden Claims

- SOC 2 certified, ISO 27001 certified, or independently penetration tested — none exists
- Keys held in a hardware security module, or any HSM-backed custody
- Rewind submitting captures to F7 as a current capability
- A published software bill of materials
- Any multi-tenant description of a hosted instance — the isolation is one instance per customer
- Retired positioning vocabulary from `fseven-docs/docs/marketing/messaging-house.md` §10: workforce intelligence, behavioral telemetry, observing or tracking employees, AIQ, employee scoring
