# public-docs — Claude Code Instructions

## Repo Identity

- **Repo:** `public-docs` — customer-facing documentation site (VitePress)
- **Language:** Markdown + VitePress config (TypeScript)
- **Key directories:** `content/security/`, `content/privacy/`, `content/compliance/`, `content/overview/`, `content/legal/`
- **Role:** Public-facing documentation for customers, prospects, and compliance reviewers

## Content Accuracy Rules

1. **Every technical claim must match implemented code.** Do not document planned or aspirational features as current capabilities.
2. **No proprietary implementation details.** Do not expose:
   - Specific model names or architectures (use "purpose-built on-device AI model")
   - Specific rate-limit numbers (use "endpoint-specific rate limiting")
   - Internal crate names, endpoint paths, or error codes
   - Internal architecture decisions or ADR references
3. **No unimplemented integrations.** Only list integrations that exist in code (e.g., HRIS providers are NOT implemented — do not list Workday, BambooHR, etc.).
4. **Compensation data ingestion is not implemented.** Do not reference salary, stock value, or benefits value fields.
5. **Audit count:** Currently 19 completed security audit runs. Update this number when new runs are added.
6. **Cross-check with internal docs:** The authoritative security documentation lives in `fseven-docs/docs/security/`. Public docs should be a simplified, non-proprietary subset.

## Verification Sources

| Claim Domain | Verify Against |
|-------------|---------------|
| Agent behavior | `fseven-agent/agent-core/src/` |
| Cryptographic controls | `fseven-docs/docs/security/security-architecture.md` |
| Privacy controls | `fseven-docs/docs/architecture/privacy-framework.md` |
| Compliance mappings | `fseven-docs/docs/architecture/privacy-framework.md` §7-10 |
| Data classification | `fseven-agent/agent-core/src/config.rs` (PrivacyConfig) |
| Controller security | `fseven-controller/server/src/` |

## Pre-Push CI Gate

**Before pushing any changes**, verify the VitePress site builds without errors:

```bash
pnpm install && pnpm build
```

Never push content that breaks the docs build. Fix locally first — do not iterate on CI remotely.

## Critical Reminders

- **No sprint docs, handoff docs, or completion summaries anywhere in the platform.**
- Public docs must never expose information that would help an attacker (specific versions, internal paths, key material details).
- When in doubt about whether a feature is implemented, check the code — do not assume.
