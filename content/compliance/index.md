# Compliance Overview

F7 is designed for enterprise deployment. Our security and privacy controls are built to satisfy the requirements of major regulatory frameworks and industry standards.

## Compliance Status

| Framework | Status | Details |
|-----------|--------|---------|
| **GDPR** | Controls implemented | Privacy by design, data minimization, right to erasure, right of access |
| **CCPA / CPRA** | Controls implemented | Right to know, right to delete, right to opt-out |
| **SOC 2 Type II** | Controls implemented, certification planned | All five trust criteria addressed |
| **ISO 27001** | Controls aligned | Key Annex A controls addressed across the platform |

## Security Questionnaire Quick Reference

This table addresses the most common vendor security questionnaire items. Every answer is backed by implemented functionality — not planned features.

| # | Question | Answer |
|---|----------|--------|
| 1 | Is data encrypted in transit? | **Yes** — TLS 1.3 for all communications |
| 2 | Is data encrypted at rest? | **Yes** — AES-256-GCM (server), AES-256 (agent) |
| 3 | Is role-based access control implemented? | **Yes** — Hybrid ReBAC+ABAC with PDP, manager-chain scoping, app-category delegation, k-anonymity |
| 4 | Is multi-tenant isolation enforced? | **Yes** — PostgreSQL Row-Level Security on all org-scoped tables |
| 5 | Is audit logging implemented? | **Yes** — Immutable (trigger-protected), 24-month retention |
| 6 | Are passwords hashed securely? | **Yes** — Argon2id with per-password salts |
| 6a | Is SSO supported? | **Yes** — OAuth 2.0/OIDC (Entra ID, Okta, Google Workspace, JumpCloud, generic OIDC) |
| 7 | Is the application memory-safe? | **Yes** — Written in Rust |
| 8 | Is PII collected? | **Minimal** — Metadata only, never content |
| 9 | Is right to erasure supported? | **Yes** — Full data deletion on request |
| 10 | Can employees pause collection? | **Yes** — Tray icon, app exclusion, work-hours mode |
| 11 | Are dependencies audited? | **Yes** — Automated in CI on every commit |
| 12 | Can it be deployed on-premise? | **Yes** — Single-binary deployment available |
| 13 | Is rate limiting enforced? | **Yes** — Per-endpoint rate limits |
| 14 | Are security headers implemented? | **Yes** — HSTS, CSP, X-Frame-Options, and more |
| 15 | Is session management secure? | **Yes** — HttpOnly, Secure, SameSite cookies |

## Deployment Options

F7 supports both cloud and on-premise deployment with identical security controls:

| Model | How It Works |
|-------|-------------|
| **Cloud (SaaS)** | Hosted by F7, tenant-isolated via Row-Level Security, managed updates |
| **On-premise** | Single-binary deployed in the customer's infrastructure, full data sovereignty |

On-premise deployments give organizations complete data sovereignty — no data leaves the customer's environment.

## Getting More Information

If you need additional compliance documentation for your evaluation:

- **Data Processing Agreement (DPA):** Available in our [Legal](/legal/dpa) section
- **Sub-processor list:** Available in our [Legal](/legal/subprocessors) section
- **Detailed compliance mappings:** See our [GDPR](/compliance/gdpr), [CCPA](/compliance/ccpa), and [SOC 2](/compliance/soc2) pages

For security questionnaire support or custom compliance inquiries, contact us at **security@fseven.ai**.

---

::: info Framework-Specific Details
- [GDPR Compliance](/compliance/gdpr) — Article-by-article mapping
- [CCPA / CPRA Compliance](/compliance/ccpa) — Rights and obligations
- [SOC 2 Type II](/compliance/soc2) — Trust criteria control mapping
:::
