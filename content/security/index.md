# Security Overview

This page summarises Atlas's security posture for security evaluators, procurement teams and compliance reviewers. Every statement below describes implemented behaviour; where a control is not built, the page says so.

## Core security posture

- **Single tenant by construction.** One deployment, one database, one signed ledger per customer. There is no shared multi-tenant store, so there is no cross-tenant query to get wrong.
- **A signed, append-only record.** Every artifact Atlas records is wrapped in a signed envelope, and significant events go to a hash-chained ledger. The database privileges on the ledger tables allow reading and appending and nothing else, so even full administrative access to the instance cannot rewrite history. You can export the whole record with the public keys needed to verify it independently.
- **Account security.** Passwords are hashed with Argon2id and never stored in readable form. Time-based one-time codes and passkeys are supported as second factors, recovery codes are stored hashed and single-use, repeated failed sign-ins lock the account, and sessions can be revoked.
- **Secrets encrypted at rest.** Provider keys and other secrets are kept in an AES-256-GCM encrypted store, or in the operating system keychain on macOS. They are resolved from that store on every request and never live in the configuration file.
- **Access checked on every request.** Project permissions are resolved per request and denied by default.
- **Memory-safe implementation.** The Atlas server is written in Rust.
- **No hardware key custody.** F7 ships no hardware security module integration and operates no key-management service. Keys are held in the instance's secret store, or in a key module an operator points Atlas at. See [Encryption and Signing](/security/encryption#key-custody).

## Compliance quick reference

| Question | Answer |
|---|---|
| Data encrypted in transit? | **Yes** on an instance F7 operates: it is served over HTTPS. The download runs on your own machine and serves your browser locally. |
| Data encrypted at rest? | **Secrets, yes** — provider keys, sign-on client secrets and second-factor secrets are encrypted. **Database files, not by Atlas** — protect the machine that runs it with disk encryption. |
| Tenant isolation? | **Yes** — one instance and one database per customer; no shared store. |
| Audit logging? | **Yes** — sign-in attempts, lockouts, second-factor and passkey changes and administrative account actions are recorded; significant product events are written to the append-only signed ledger. |
| Modern password hashing? | **Yes** — Argon2id. |
| Multi-factor authentication? | **Yes** — time-based one-time codes and passkeys, with single-use recovery codes. |
| Single sign-on? | **Yes** — OAuth 2.0 / OpenID Connect sign-in with a configured identity provider. |
| User provisioning? | **Yes** — inbound SCIM 2.0 for users and groups. |
| Right to erasure? | **Yes for ordinary records.** The ledger is append-only: it can be destroyed in its entirety, never edited entry by entry. |
| On-premise deployment? | **Yes** — the download runs on your own machine or server, and can run with no connection to F7. |
| Dependency auditing? | **Yes** for this Trust Center — its deploy workflow runs `npm audit --audit-level=moderate` before publishing. Product dependency evidence is release-scoped in the owning private repository. |
| Independent penetration test? | **No report is available.** |
| SOC 2 report? | **No.** See [SOC 2](/compliance/soc2). |

## Audit and testing

F7 runs an internal security audit program with a structured three-pass methodology. The current baseline is **Run 41**, completed 2026-09-03: a full baseline over every in-scope repository, with zero critical findings open at close and every open finding recorded for remediation. Its coverage boundary is stated here rather than implied: the earlier device-agent and server products were excluded from this run and the one before it by operator directive, and they are the shelved product this Trust Center no longer describes.

This Trust Center's deploy workflow runs `npm audit --audit-level=moderate` before publishing to GitHub Pages, so a known vulnerability in the site's own toolchain blocks the publish.

No independent penetration test report is available for Atlas, and F7 does not hold a SOC 2 report. Neither is presented here as planned; both are stated as absent.

---

::: info Deeper dives
- [Deployment and Trust Architecture](/security/architecture) — where the instance runs and what talks to what
- [Accounts and Access](/security/authorization) — sign-in, second factors, roles and the auth event log
- [Encryption and Signing](/security/encryption) — the cryptographic inventory and the custody boundary
- [Downloads and Updates](/security/downloads) — how to verify what you installed
:::
