# Privacy Policy

**Effective Date:** March 13, 2026
**Last Updated:** March 13, 2026

This Privacy Policy describes how F7 Platform, Inc. ("F7," "we," "us," or "our") collects, uses, and discloses information in connection with the F7 AI Workforce Intelligence Platform (the "Service").

## 1. Who This Policy Applies To

This policy covers:
- **Customer organizations** that deploy F7 in their workplace
- **End users** (employees) whose devices run the F7 agent
- **Visitors** to our website and documentation

## 2. Information We Collect

### From the F7 Agent (Deployed on Employee Devices)

The F7 agent collects **work-pattern metadata only**. This includes:

- **Application focus data:** Application name, window title category (never raw window titles for non-work apps), foreground/background transitions
- **Input activity metadata:** Click count, keystroke count (never individual keystrokes), scroll events, idle periods
- **Network metadata:** Destination domain, optional HTTP method and API endpoint path for AI-provider classification (e.g. `POST /v1/chat/completions`), and approximate request/response byte counts — never query strings, request bodies, or response content
- **Session structure:** Session boundaries, duration, focus time, context switches
- **AI interaction metadata:** AI provider name, turn count, request/response sizes, time-to-first-response — never prompt or response text

### From Employer-Provided Sources

Your organization may provide the following data to F7:

- **Job metadata:** Job title, employment type, cost center, location
- **Org hierarchy:** Department, division, team, manager assignment
- **Employment lifecycle:** Hire date, termination date, active status
- **Identity:** Email, display name, user principal name (for account linkage)

F7 does not independently collect this data — it is provided by your employer through configured identity, directory, or file-based syncs.

### From Third-Party App Integrations (Opt-In)

With your organization's authorization, F7 can connect to third-party applications via their APIs to retrieve **usage metadata**:

- **AI platforms** (e.g., ChatGPT, Claude, Gemini): Usage frequency, session counts, token/seat usage
- **Productivity suites** (e.g., Microsoft 365, Google Workspace): Document activity counts, collaboration metrics, license utilization
- **Writing & communication tools** (e.g., Grammarly, Notion): Feature adoption, usage frequency
- **Developer tools** (e.g., GitHub Copilot): Suggestion acceptance rates, seat utilization

These integrations retrieve usage statistics only — never document contents, message text, prompt/response text, or file contents. Each integration must be explicitly authorized by an organization administrator and can be disconnected at any time.

### What the Agent Never Transmits

- Prompt or response text
- File contents
- Email or chat messages
- Screenshots or screen recordings (see Mode 3 note below)
- Clipboard contents
- Passwords or credentials
- Full URLs, query parameters, or page content
- Personal app activity (for user-excluded apps)

**Mode 3 — Interpret (opt-in).** When an organization enables Mode 3, the agent captures screen frames locally for an on-device vision-language model. Frames are processed in memory and discarded immediately after inference; they are never persisted to disk and never transmitted off the device.

For the complete data inventory, see [Data Collection Details](/privacy/data-collection).

### From Our Website

We collect standard web analytics (page views, referrer) and information you voluntarily provide (e.g., contact forms).

## 3. How We Use Information

We use collected metadata to:
- Compute workforce analytics scores (AI adoption, productivity patterns)
- Power management dashboards and team-level insights
- Power individual personal dashboards (planned)
- Improve the F7 service

We do **not** use collected data to:
- Make automated employment decisions
- Sell to third parties
- Target advertising
- Profile individuals for purposes other than workforce analytics

## 4. How We Protect Information

- **Encryption in transit:** TLS 1.3 for all communications
- **Encryption at rest:** AES-256-GCM (server-side), AES-256 (agent local storage)
- **Access control:** Role-based access with four roles; row-level database tenant isolation
- **Audit logging:** Append-only audit log with 24-month retention
- **Local processing:** On-device AI model processes data locally before transmission

See our [Security Overview](/security/) for full details.

## 5. Data Retention

| Data Type | Default Retention |
|-----------|------------------|
| Raw telemetry | 90 days |
| Aggregated rollups | 12 months |
| Audit logs | 24 months |

Retention periods are configurable by the deploying organization. See [Data Retention & Deletion](/privacy/data-retention).

## 6. Data Sharing

F7 does not sell personal information. We share data only:

- **With the deploying organization:** Aggregated analytics visible to authorized roles (managers see team data, not individual raw data)
- **With service providers:** Infrastructure providers necessary to operate the Service (see [Sub-processors](/legal/subprocessors))
- **As required by law:** In response to valid legal process

## 7. Your Rights

Depending on your jurisdiction, you may have the right to:
- **Access** your personal data (via your organization's F7 administrator; personal dashboard planned)
- **Delete** your data (full erasure on request)
- **Correct** your data
- **Port** your data (export via administrator; self-service export planned)
- **Object** to processing
- **Restrict** processing (pause observation, exclude apps)

To exercise these rights, contact your organization's F7 administrator or reach us at **privacy@fseven.ai**.

## 8. International Data Transfers

For customers outside the United States, data processing may involve transfers to the U.S. These transfers are governed by the [Data Processing Agreement](/legal/dpa), which includes Standard Contractual Clauses where applicable.

On-premise deployments keep all data within the customer's infrastructure.

## 9. Children's Privacy

F7 is a workplace tool and is not directed at children under 16. We do not knowingly collect information from children.

## 10. Changes to This Policy

We may update this Privacy Policy from time to time. We will notify customers of material changes via email or in-product notification.

## 11. Contact Us

For privacy inquiries:

- **Email:** privacy@fseven.ai
- **Mail:** F7 Platform, Inc., [address to be published]

---

::: info Related Documents
- [Data Processing Agreement](/legal/dpa)
- [Sub-processors](/legal/subprocessors)
- [Terms of Service](/legal/terms-of-service)
:::
