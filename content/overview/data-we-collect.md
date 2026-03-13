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

### Important Details

- **Keystroke count, not keystrokes.** We count how many keys were pressed. We never record which keys or what was typed.
- **App name, not window title.** For non-work applications, we capture only the app name and category.
- **Domain, not URL.** We record the destination domain (e.g., `openai.com`). Never the full URL, path, query parameters, or page content.
- **Sizes, not content.** For AI interactions, we record how large requests and responses were. Never the actual prompt or response text.

## What We Never Capture

| Category | Guarantee |
|----------|-----------|
| **Prompt and response text** | Never captured — not even with advanced features enabled |
| **File contents** | Never read — only metadata like file count and type |
| **Email and chat content** | Never captured — only time-in-app and domain |
| **Screenshots** | Never transmitted or stored — if the optional vision model is enabled, frames are processed locally and immediately discarded |
| **Clipboard contents** | Never captured under any circumstances |
| **Passwords or credentials** | Never accessed or stored |
| **Browsing history** | Only the active domain is captured — never full URLs, paths, or page content |
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
