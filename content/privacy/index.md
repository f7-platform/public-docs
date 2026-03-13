# Privacy Principles

Privacy is not an add-on feature in F7 — it's a design constraint that shapes every technical decision. Here are the principles that govern how F7 handles data.

## 1. Metadata, Never Content

The F7 agent captures work-pattern metadata — application names, activity counts, timing, and session structure. It never captures content: no prompts, no files, no emails, no screenshots, no clipboard data.

This isn't a policy choice. The agent's code physically does not have the capability to read prompt text, file contents, or clipboard data.

## 2. Local-First Processing

The on-device AI model performs classification and scoring **before any data leaves the device**. Only structured, PII-scrubbed metadata is transmitted to the server. Raw observations stay on the device temporarily and are pruned after syncing.

## 3. Data Minimization

Every captured field has a documented purpose. If a data point isn't needed for scoring or analytics, it isn't captured. This follows the principle of data minimization required by GDPR (Article 5(1)(c)) and CCPA's reasonable collection standard.

## 4. Aggregation Over Identification

Management dashboards show **team and department aggregates**. Individual-level data is visible only to:
- The person themselves (through an opt-in personal dashboard)
- Authorized roles with explicit audit logging of every access

Scores and insights are designed to inform workforce strategy, not to surveil individuals.

## 5. Consent, Not Coercion

- The **personal dashboard** is opt-in — employees choose whether to view their own data.
- The **vision model** (advanced Tier 3 feature) requires explicit consent.
- Employees can **pause observation** at any time.
- Exercising privacy controls has no impact on work status — by design.

## 6. Right to Erasure

Any employee's data can be fully deleted on request:
- All server-side records are permanently removed.
- All device-side data is wiped via a remote command.
- An audit trail of the erasure event is retained for compliance — without the original data content.

## 7. Transparency

We publish exactly what we collect, what we never collect, and how every piece of data is used. See our [Data Collection Details](/privacy/data-collection) for the complete breakdown.

Employees with access to the personal dashboard can see every data point captured from their device.

---

::: tip Learn More
- [Data Collection Details](/privacy/data-collection) — What we capture and why
- [Employee Controls](/privacy/employee-controls) — How employees control their data
- [Data Retention & Deletion](/privacy/data-retention) — How long data is kept and how to delete it
:::
