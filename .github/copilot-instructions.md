# GitHub Copilot Instructions — public-docs

See [`CLAUDE.md`](../CLAUDE.md) for the authoritative repo-level contributor guide — Copilot and Claude share the same rules.

## Quick Rules

1. **No proprietary details.** Do not expose model names, rate-limit numbers, crate names, endpoint paths, or internal error codes.
2. **No unimplemented integrations.** If a feature is not implemented in `fseven-controller` / `fseven-agent`, do not document it as a capability.
3. **Latest security audit = Run 27b**. Update both this file and CLAUDE.md when a new run completes.
4. **CI gate:** `pnpm install && pnpm build` must succeed before any PR merges.
5. **Cross-check:** Authoritative technical docs live in `fseven-docs/docs/security/`. Public docs are a simplified subset.

## File Layout

- `content/overview/` — What F7 is, how it works
- `content/privacy/` — GDPR-aligned controls
- `content/security/` — Encryption, authorization, agent security, architecture
- `content/compliance/` — CCPA, SOC 2, ISO 27001 readiness
- `content/legal/` — ToS, DPA, subprocessors, privacy policy

## Forbidden Claims (until implemented)

- "Authenticode-signed Windows installer" — currently only macOS-style signing is in CI
- "HRIS connector for Deel or Oracle HCM" — those two connectors are not implemented. (Workday, BambooHR, SAP SuccessFactors, Rippling, HiBob ARE implemented in `fseven-controller/server/src/hr_sync/`.)
- Specific SLM architecture or parameter count
