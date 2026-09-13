# SOC 2

::: warning Status
**F7 does not hold a SOC 2 report for Atlas.** Atlas is not SOC 2 certified, and this page does not present certification as planned. Contact **security@fseven.ai** if your procurement process needs a statement to that effect.
:::

## What exists today

Rather than map self-assessed controls to trust service criteria without an auditor, this page lists what is implemented, grouped the way a reviewer will ask about it. Every item links to the page that describes it.

| Area | What is implemented |
|---|---|
| **Security** | Argon2id password hashing; second factors and passkeys with single-use hashed recovery codes; account lockout; revocable sessions; secrets encrypted at rest; per-request authorisation denied by default; a structured auth event log. See [Accounts and Access](/security/authorization) |
| **Confidentiality** | One instance, one database and one signed ledger per customer, with no shared store; provider keys encrypted under the instance master key; a published, complete list of what leaves the instance. See [Deployment and Trust Architecture](/security/architecture) |
| **Processing integrity** | Every recorded artifact is wrapped in a signed envelope; significant events go to an append-only, hash-chained ledger whose database privileges allow reading and appending only; the export archive carries the public keys to verify it independently. See [Encryption and Signing](/security/encryption) |
| **Availability** | The download runs on your own machine and does not need to reach F7 to run; hosted instances upgrade by image pin. High availability and disaster recovery for the ledger are **not built** |
| **Privacy** | No analytics, tracking or background reporting; voice and Rewind are consent-gated; access and export are product features. See [Privacy Principles](/privacy/) |

## Security testing

- **Run 41 security audit baseline** (completed 2026-09-03): F7's internal three-pass audit program, with every open finding recorded for remediation. The audit's coverage boundary is stated in [Security Overview](/security/#audit-and-testing).
- **Trust Center dependency audit** — this site's deploy workflow runs `npm audit --audit-level=moderate` before GitHub Pages publication, so a known vulnerability in the documentation toolchain blocks the publish. Product dependency evidence is release-scoped in the owning private repository.
- **Independent penetration testing** — no report is available.

## Requesting more

Contact **security@fseven.ai** to schedule a security review call or to request the internal audit's current findings summary.

---

::: info Related
- [Security Overview](/security/) — the posture in one page, including what is not built
- [Compliance Overview](/compliance/) — the questionnaire quick reference
:::
