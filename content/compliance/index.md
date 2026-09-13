# Compliance Overview

Atlas is built for organisations that will be asked to prove things. This page states the compliance posture as it is, including where a certification or report does not exist.

## Status

| Framework | Status | Details |
|---|---|---|
| **GDPR** | Rights supported as product features or through F7 support | Access and export are built in; correction, deletion and objection go through support, with the ledger limit stated. Roles depend on the deployment model. See [GDPR](/compliance/gdpr) |
| **CCPA / CPRA** | No sale of personal information; service-provider role on hosted instances | See [CCPA / CPRA](/compliance/ccpa) |
| **SOC 2** | **No report.** F7 does not hold a SOC 2 report for Atlas | See [SOC 2](/compliance/soc2) |
| **ISO 27001** | **Not certified** | — |
| **Internal security audits** | Run 41 baseline, completed 2026-09-03 | See [Security Overview](/security/#audit-and-testing) |

## Security questionnaire quick reference

Every answer below is backed by implemented behaviour. Where the honest answer is no, it says no.

| # | Question | Answer |
|---|---|---|
| 1 | Is data encrypted in transit? | **Yes** on an instance F7 operates (HTTPS). The download runs on your own machine and serves your browser locally. |
| 2 | Is data encrypted at rest? | **Secrets, yes** (AES-256-GCM store or the operating system keychain). **Database files, not by Atlas** — use disk encryption on the machine that runs it. |
| 3 | Is access control implemented? | **Yes** — per-project reader, writer and administrator roles, checked on every request and denied by default. |
| 4 | Is tenant isolation enforced? | **Yes** — one instance and one database per customer; no shared multi-tenant store. |
| 5 | Is audit logging implemented? | **Yes** — a structured auth event log, and an append-only signed ledger of significant product events. |
| 6 | Are passwords hashed securely? | **Yes** — Argon2id with per-password salts. |
| 7 | Is multi-factor authentication supported? | **Yes** — time-based one-time codes and passkeys, with single-use recovery codes. |
| 8 | Is single sign-on supported? | **Yes** — OAuth 2.0 / OpenID Connect with a configured identity provider; inbound SCIM 2.0 provisioning. |
| 9 | Is the application memory-safe? | **Yes** — the server is written in Rust. |
| 10 | Is personal information collected? | **What you enter.** Account details, plus whatever you author. Atlas installs no agent and observes no one. Usage metering is not linked to a person. |
| 11 | Is the right to erasure supported? | **Yes for ordinary records.** The ledger is append-only and can only be destroyed whole. |
| 12 | Can it be deployed on-premise or air-gapped? | **Yes** — the download runs on your own machine or server and does not need to reach F7 to run. |
| 13 | Are dependencies audited? | **Yes** for this Trust Center: its deploy workflow runs `npm audit --audit-level=moderate` before publishing. Product dependency evidence is release-scoped in the owning private repository. |
| 14 | Has an independent penetration test been performed? | **No report is available.** |
| 15 | Is there a SOC 2 or ISO 27001 report? | **No.** |
| 16 | Are signing keys held in hardware? | **No.** F7 ships no hardware security module integration. An operator can hold keys in a module they provide. |
| 17 | Can records be verified independently? | **Yes** — the export archive carries the public keys needed to verify every signature without F7. |

## Deployment options

| Model | How it works |
|---|---|
| **The download** | One signed installer, one binary with its own private PostgreSQL, on your own machine or server. Full data sovereignty; no access by F7. |
| **An instance F7 operates** | Hosted and administered by F7 on Railway infrastructure in the United States, single-tenant, accessed over HTTPS. |

## Getting more information

- **Legal documents.** The [Legal](/legal/privacy-policy) section currently carries documents written for F7's earlier product, marked with a notice. Atlas's own terms of use and privacy policy are in legal review; contact **legal@fseven.ai** for the current drafts.
- **Detailed mappings.** See the [GDPR](/compliance/gdpr), [CCPA / CPRA](/compliance/ccpa) and [SOC 2](/compliance/soc2) pages.
- **Security questionnaire support.** Contact **security@fseven.ai**.
