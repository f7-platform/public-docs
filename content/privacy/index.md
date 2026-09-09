# Privacy Principles

Privacy is not an add-on feature in F7 — it's a design constraint that shapes every technical decision. Here are the principles that govern how F7 handles data.

## 1. Metadata, Never Content

The F7 agent captures work-pattern metadata — application names, activity counts, timing, and session structure. It never uploads content: no prompts, no files, no emails, no clipboard data, and no screenshots. This principle, and everything else on this page, is about the F7 agent; the Atlas Rewind exception is stated below.

This isn't a policy choice. The agent's code physically does not have the capability to read prompt text, file contents, or clipboard data.

**Vision (Mode 3 — Interpret) caveat.** When an organization explicitly enables Mode 3, the agent processes screen frames locally for an on-device vision-language model. Frames are never uploaded and never leave the device. Current macOS builds stream capture bytes through stdout for local inference and scrub stale legacy vision temp files on startup. See [Vision Model controls](/privacy/employee-controls#vision-model-mode-3-interpret).

**Atlas Rewind is a different product and a different promise.** Atlas is a separate F7 product from the agent, and it contains a feedback recorder called Rewind. When a reviewer working in Atlas turns Rewind on, it takes picture-only snapshots of the tab or screen that reviewer chooses, and those pictures are not covered by the agent promises above. Rewind records no audio. A capture stays on the customer's own Atlas instance unless the reviewer asks an AI model to describe the frames they selected, which sends those frames to the configured model provider with the reviewer's per-capture permission. Sending a capture to F7 is planned and not built, and Rewind is not shown on any customer deployment today; it is offered only where a customer has been asked for consent and has given it. See [Atlas Rewind](/legal/privacy-policy#from-atlas-rewind-atlas-only-not-the-f7-agent).

## 2. Local-First Processing

The on-device AI model performs classification and scoring **before any data leaves the device**. Only structured, PII-scrubbed metadata is transmitted to the server. Raw observations stay on the device temporarily and are pruned after syncing.

## 3. Data Minimization

Every captured field has a documented purpose. If a data point isn't needed for scoring or analytics, it isn't captured. This follows the principle of data minimization required by GDPR (Article 5(1)(c)) and CCPA's reasonable collection standard.

## 4. Aggregation Over Identification

Management dashboards show **team and department aggregates**. Individual-level data is visible only to:
- The person themselves (through a planned personal dashboard)
- Authorized roles with explicit audit logging of every access

Scores and insights are designed to inform workforce strategy, not to surveil individuals.

## 5. Consent, Not Coercion

- A **personal dashboard** is planned — employees will be able to view their own data.
- The **vision model** (Mode 3 — Interpret) must be explicitly enabled by the organization.
- Organizations can **pause observation** for employees at any time.
- Exercising privacy controls has no impact on work status — by design.

## 6. Right to Erasure

Any employee's data can be fully deleted on request:
- All server-side records are permanently removed.
- All device-side data is wiped via a remote command.
- An audit trail of the erasure event is retained for compliance — without the original data content.

## 7. Transparency

We publish exactly what we collect, what we never collect, and how every piece of data is used. See our [Data Collection Details](/privacy/data-collection) for the complete breakdown.

Once the personal dashboard is available, employees will be able to see every data point captured from their device.

---

::: tip Learn More
- [Data Collection Details](/privacy/data-collection) — What we capture and why
- [Employee Controls](/privacy/employee-controls) — How employees control their data
- [Data Retention & Deletion](/privacy/data-retention) — How long data is kept and how to delete it
:::
