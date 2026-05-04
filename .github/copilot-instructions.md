# GitHub Copilot Instructions — public-docs

See [`CLAUDE.md`](../CLAUDE.md) for the authoritative repo-level contributor guide — Copilot and Claude share the same rules.

## Quick Rules

1. **No proprietary details.** Do not expose model names, rate-limit numbers, crate names, endpoint paths, or internal error codes.
2. **No unimplemented integrations.** If a feature is not implemented in `fseven-controller` / `fseven-agent`, do not document it as a capability.
3. **Latest security audit = Run 27b**. Update both this file and CLAUDE.md when a new run completes.
4. **CI gate:** `pnpm install && pnpm check:claims && pnpm build` must succeed before any PR merges.
5. **Cross-check:** Authoritative technical docs live in `fseven-docs/docs/security/`. Public docs are a simplified subset.

## File Layout

- `content/overview/` — What F7 is, how it works
- `content/privacy/` — GDPR-aligned controls
- `content/security/` — Encryption, authorization, agent security, architecture
- `content/compliance/` — CCPA, SOC 2, ISO 27001 readiness
- `content/legal/` — ToS, DPA, subprocessors, privacy policy

## Forbidden Claims (until implemented)

- "Authenticode-signed Windows installer" — currently only macOS-style signing is in CI
- Specific HRIS connector names unless verified against implemented controller code in the same change
- Compensation data ingestion, salary fields, stock value fields, benefits value fields, or compensation masking as a current customer-facing capability
- Specific SLM architecture or parameter count
