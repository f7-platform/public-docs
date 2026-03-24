# Security Overview

Security and privacy are foundational design constraints in F7 — not afterthoughts. This page summarizes our security posture for CISOs, procurement teams, and security evaluators.

## Core Security Posture

- **Defense in depth.** Six distinct security layers protect data from endpoint to storage.
- **Privacy by design.** The agent processes data locally before transmitting only structured, PII-scrubbed metadata. Content is never captured.
- **Zero-trust enrollment.** Agents authenticate via a cryptographic enrollment flow that produces per-device credentials stored in the operating system's secure credential store.
- **Modern cryptography.** All algorithms are current-generation with no legacy primitives.
- **Memory-safe codebase.** The platform is built in Rust, eliminating entire classes of vulnerabilities (buffer overflows, use-after-free, data races) at compile time.

## Six Layers of Defense

| Layer | What It Does |
|-------|-------------|
| **1. Transport Security** | TLS 1.3 for all communications. HSTS enforced. Certificate pinning for agent connections. |
| **2. Authentication** | Per-device Ed25519 credentials for agents. Argon2id passwords or OAuth 2.0/OIDC SSO for admins. IdP directory sync with auto-provisioning. |
| **3. Authorization** | Hybrid ReBAC+ABAC policy decision point. Four roles with manager-chain scoping, purpose-specific enforcement, compensation masking, and k-anonymity. |
| **4. Database Isolation** | Row-Level Security on every org-scoped table with read and write enforcement. |
| **5. Audit & Monitoring** | Immutable, trigger-protected audit log. Cannot be modified or deleted even by the application. |
| **6. Encryption at Rest** | AES-256-GCM for server-side secrets. AES-256 encrypted local database on each device. |

## Compliance Quick Reference

| Question | Answer |
|----------|--------|
| Data encrypted in transit? | **Yes** — TLS 1.3 |
| Data encrypted at rest? | **Yes** — AES-256-GCM (server), AES-256 (agent) |
| Role-based access control? | **Yes** — Hybrid ReBAC+ABAC with PDP, four roles, manager-chain scoping, compensation masking |
| SSO / OIDC? | **Yes** — Entra ID, Okta, Google Workspace, JumpCloud, generic OIDC |
| Tenant isolation? | **Yes** — PostgreSQL Row-Level Security on all org-scoped tables |
| Audit logging? | **Yes** — Immutable (trigger-protected), 24-month retention |
| Modern password hashing? | **Yes** — Argon2id |
| Memory-safe language? | **Yes** — Rust |
| Dependency auditing? | **Yes** — Automated in CI pipeline |
| Right to erasure? | **Yes** — Full data deletion on request |
| Can employees pause collection? | **Yes** — Tray icon, per-app exclusion, work-hours mode |

## Audit & Testing

F7 undergoes regular internal security audits following a structured three-pass methodology. We also run automated dependency auditing on every code change to catch known vulnerabilities in third-party libraries.

Independent third-party penetration testing and SOC 2 Type II certification are on our roadmap.

---

::: info Deeper Dives
- [Architecture](/security/architecture) — The six-layer model in detail
- [Authorization](/security/authorization) — PDP authorization model, obligations, and IdP integration
- [Encryption](/security/encryption) — Complete cryptographic inventory
- [Agent Security](/security/agent-security) — How data is protected on the device
:::
