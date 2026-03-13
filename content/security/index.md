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
| **2. Authentication** | Per-device Ed25519 cryptographic credentials for agents. Argon2id password hashing for admins. |
| **3. Authorization** | Role-based access control with four roles (owner, admin, manager, viewer). Scope-based access tokens. |
| **4. Database Isolation** | Row-Level Security ensures each organization can only access its own data. |
| **5. Audit & Monitoring** | Append-only audit log recording every significant action with actor, timestamp, and IP address. |
| **6. Encryption at Rest** | AES-256-GCM for server-side secrets. AES-256 encrypted local database on each device. |

## Compliance Quick Reference

| Question | Answer |
|----------|--------|
| Data encrypted in transit? | **Yes** — TLS 1.3 |
| Data encrypted at rest? | **Yes** — AES-256-GCM (server), AES-256 (agent) |
| Role-based access control? | **Yes** — Four roles with scope-based tokens |
| Tenant isolation? | **Yes** — PostgreSQL Row-Level Security |
| Audit logging? | **Yes** — Append-only, 24-month retention |
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
- [Encryption](/security/encryption) — Complete cryptographic inventory
- [Agent Security](/security/agent-security) — How data is protected on the device
:::
