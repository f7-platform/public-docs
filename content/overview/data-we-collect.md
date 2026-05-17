# Data We Collect

Transparency is a core F7 value. This page provides a complete breakdown of what the F7 agent captures, what it **never** captures, and why each data point exists.

## What We Capture

| Data Category | Examples | Why We Capture It |
|---------------|----------|-------------------|
| **Application focus** | App name, app category, foreground/background transitions | Understand which tools people use and how they divide their time |
| **Input activity** | Click count, keystroke count, scroll events, idle periods | Measure engagement levels without recording what was typed |
| **Network metadata** | Destination domain, port, detected AI provider | Identify which AI tools are being used and how frequently |
| **Session structure** | Session start/end, duration, focus time, context switches | Understand work patterns, deep work vs. fragmented time |
| **AI interaction metadata** | AI provider name, turn count, request/response sizes, time-to-first-response | Measure depth and sophistication of AI usage |
| **Git metadata** | Commit count, files changed count, insertions/deletions | Correlate AI usage with development output (via webhook, not agent) |

## Employer-Provided Data

In addition to agent-captured metadata, F7 processes organization-provided workforce data such as identity, role, and hierarchy fields when the deploying organization configures those syncs.

| Data Category | Examples | Why It's Used |
|---------------|----------|---------------|
| **Job metadata** | Job title, employment type, cost center, location | Team-level analytics and segmentation |
| **Org hierarchy** | Department, division, team, manager | Reporting structure and rollup views |
| **Employment lifecycle** | Hire date, termination date, active status | Accurate headcount and tenure analysis |
| **Identity** | Email, display name, user principal name | Account linkage and HRIS/IdP sync |

::: warning Employer-Controlled Data
F7 does not independently collect workforce directory data — it is provided entirely by the deploying organization. The organization decides which supported fields to sync and can disable those syncs at any time.
:::

## Third-Party Event Integrations

With your organization's authorization, F7 can ingest **event metadata** from configured controller integrations. This provides richer analytics without relying solely on network-level observation from the agent.

| Integration Category | Implemented Sources | Data Retrieved |
|---------------------|---------------------|----------------|
| **Source control** | GitHub, GitLab, Bitbucket | Commit, pull request, branch, and review event metadata |
| **Issue/project management** | Jira, Linear, Asana | Ticket and sprint event metadata |
| **CI/CD** | Jenkins, GitHub Actions, GitLab CI, CircleCI | Build, test, and deployment event metadata |
| **Calendar/support/feature flags** | Google Calendar, Microsoft Outlook, Zendesk, LaunchDarkly | Meeting, support-ticket, and flag-change event metadata |
| **Custom workflows** | Generic webhooks | Customer-defined event metadata |

::: warning Metadata Only — Never Content
Third-party integrations retrieve **event metadata only** — never document contents, message text, prompt/response text, code diffs, repository contents, calendar descriptions, support conversation bodies, or file contents. F7 requests only the minimum scopes required for the configured event source.
:::

::: info Opt-In Only
Third-party integrations are **not enabled by default**. Each integration must be explicitly authorized by an organization administrator, who grants the specific API credentials and scopes. Integrations can be disconnected at any time.
:::

### Important Details

- **Keystroke count, not keystrokes.** We count how many keys were pressed. We never record which keys or what was typed.
- **App name, not window title.** For non-work applications, we capture only the app name and category.
- **Domain plus AI-provider endpoint path, not full URL.** We record the destination domain and, for AI-provider API calls, the endpoint path used for classification. We never capture query parameters, request bodies, response content, or page content.
- **Sizes, not content.** For AI interactions, we record how large requests and responses were. Never the actual prompt or response text.

## What We Never Capture

| Category | Guarantee |
|----------|-----------|
| **Prompt and response text** | Never captured — not even with advanced features enabled |
| **File contents** | Never read — only metadata like file count and type |
| **Email and chat content** | Never captured — only time-in-app and domain |
| **Screenshots** | Never transmitted off the device — if the optional vision model is enabled, frames are processed locally; current macOS capture streams PNG bytes through stdout and the agent scrubs stale legacy temp files on startup |
| **Clipboard contents** | Never captured under any circumstances |
| **Passwords or credentials** | Never accessed or stored |
| **Browsing history** | Only the active destination domain is captured, with AI-provider API endpoint paths used for classification — never full URLs, query parameters, request bodies, response content, or page content |
| **Personal app activity** | Apps on the exclusion list generate zero telemetry |
| **Individual keystrokes** | Only aggregate counts — never what was typed |

## Where Data Lives

| Location | What's Stored | Encryption |
|----------|--------------|------------|
| **Employee's device** | Raw observations + classified sessions (temporary) | AES-256 encrypted local database |
| **F7 Controller** | Structured metadata + computed scores | Encrypted at rest, tenant-isolated |
| **Dashboards** | Rendered analytics (not stored separately) | Served over HTTPS |

## Data Retention

| Data Type | Default Retention | Configurable? |
|-----------|-------------------|---------------|
| Raw telemetry | 90 days | Yes — per organization |
| Daily/weekly rollups | 12 months | Yes — per organization |
| Audit logs | 24 months | Minimum 24 months |
| Agent local data | Synced then pruned | Automatic |

Organizations can configure retention periods. When data is deleted, it is permanently removed from all storage — not archived.

## Right to Erasure

Any employee's data can be fully erased on request:

1. The organization issues an erasure command through the admin interface
2. The controller deletes all records for that individual
3. The agent receives a remote command to wipe all local data
4. An audit trail of the erasure itself is retained (for compliance — without the original data)

---

::: tip For Procurement Teams
This page is designed to answer common vendor security questionnaire items about data collection scope. For encryption and access control details, see the [Security Overview](/security/).
:::
