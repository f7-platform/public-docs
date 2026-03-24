# Data Collection Details

This page provides a detailed breakdown of every category of data the F7 agent collects, along with explicit guarantees about what is **never** collected.

## Captured Data

### Application Focus

| Field | Example | Purpose |
|-------|---------|---------|
| App name | "VS Code", "Slack" | Identify tools used throughout the workday |
| App category | "IDE", "Communication" | Classify work activities for scoring |
| Foreground/background transitions | App moved to foreground at 10:32 | Measure focus time and context-switching patterns |

**Not captured:** Window title content (for non-work apps), text on screen, content of documents.

### Input Activity

| Field | Example | Purpose |
|-------|---------|---------|
| Click count | 47 clicks in 5 minutes | Measure engagement levels |
| Keystroke count | 230 keystrokes in 5 minutes | Measure typing activity |
| Scroll events | 12 scroll actions | Distinguish reading from active work |
| Idle periods | 5 minutes idle | Identify breaks and context boundaries |

**Not captured:** Which keys were pressed, what was typed, mouse coordinates, click targets.

### Network Metadata

| Field | Example | Purpose |
|-------|---------|---------|
| Destination domain | `api.openai.com` | Identify AI tool usage |
| Port | 443 | Classify connection type |
| Process name | "chrome" | Associate network activity with apps |
| Detected AI provider | "OpenAI" | Track AI adoption metrics |

**Not captured:** Full URL, URL path, query parameters, request body, response body, cookies, headers.

### Session Structure

| Field | Example | Purpose |
|-------|---------|---------|
| Session boundaries | Session started 9:00, ended 11:30 | Define work sessions |
| Duration | 2 hours 30 minutes | Measure productive time |
| Focus time | 1 hour 45 minutes uninterrupted | Identify deep work periods |
| Context switches | 8 app switches in 30 minutes | Measure focus vs. fragmentation |
| Depth classification | "Deep work" | Categorize session quality (computed locally by on-device AI) |

### AI Interaction Metadata

| Field | Example | Purpose |
|-------|---------|---------|
| AI provider | "Claude", "ChatGPT", "GitHub Copilot" | Track which AI tools are used |
| Turn count | 12 turns in a session | Measure conversation depth |
| Request/response sizes | 500 bytes sent, 2KB received | Measure interaction complexity |
| Time-to-first-response | 1.2 seconds | Track AI tool performance |

**Not captured:** Prompt text, response text, conversation content, model parameters.

### Git Metadata (via webhook, not agent)

| Field | Example | Purpose |
|-------|---------|---------|
| Commit count | 3 commits today | Correlate AI usage with development output |
| Files changed count | 7 files modified | Measure scope of work |
| Insertions/deletions | +120 / -45 lines | Measure development velocity |
| Branch name | "feature/auth-refactor" | Associate work with project context |

**Not captured:** Diff content, file contents, commit messages.

## Employer-Provided Data

The deploying organization can provide HR data to F7 via HRIS integration (Workday, BambooHR, SAP SuccessFactors, Rippling, HiBob), identity provider sync (Entra ID, Okta, Google Workspace, JumpCloud, SCIM), or CSV/Excel upload.

F7 does **not** independently collect this data — it is supplied entirely by the employer.

### Compensation

| Field | Example | Purpose |
|-------|---------|---------|
| Annual salary | $120,000 | Financial modeling, ROI calculations |
| Stock annual value | $30,000 | Total compensation for cost analysis |
| Benefits annual value | $15,000 | Fully-loaded employee cost |
| Currency | USD, EUR, GBP | Multi-currency normalization |

**Employer controls:** Compensation sync can be disabled entirely. The `sync_compensation` flag controls whether salary, stock, and benefits fields are imported.

### Job Metadata

| Field | Example | Purpose |
|-------|---------|---------||
| Job title | "Senior Backend Engineer" | Role-level segmentation and benchmarking |
| Employment type | Full-time, part-time, contractor | Workforce composition analytics |
| Cost center | "Engineering - Platform" | Financial attribution |
| Location | "San Francisco" | Geographic analysis |

### Org Hierarchy

| Field | Example | Purpose |
|-------|---------|---------||
| Department / team | "Engineering" → "Platform Team" | Reporting structure (up to 16 levels) |
| Manager | Manager email or UPN | Manager-level dashboards |
| Headcount | 12 people on team | Team sizing (includes non-enrolled employees) |

### Employment Lifecycle

| Field | Example | Purpose |
|-------|---------|---------||
| Hire date | 2024-03-15 | Tenure analysis |
| Termination date | (when applicable) | Automatic deactivation |
| Active status | Active / Inactive | Accurate headcount |

### Identity (for account linkage)

| Field | Example | Purpose |
|-------|---------|---------||
| Email | user@company.com | Primary join key for HR sync |
| Display name | "Jane Smith" | Dashboard display |
| User principal name | user@company.onmicrosoft.com | IdP sync key |
| External ID | IdP object ID | Deduplication across syncs |

**Not provided by employer:** Anything about work behavior, AI usage, or application activity — that data comes only from the agent.

## Third-Party App Integrations

With the deploying organization's authorization, F7 can connect to third-party applications via their APIs to retrieve usage metadata. These integrations are **opt-in** — each must be explicitly configured by an organization administrator.

### AI Platforms

| Field | Example | Purpose |
|-------|---------|--------|
| Usage frequency | 45 sessions this week | Measure AI adoption across the org |
| Token / seat usage | 12,000 tokens consumed | Understand consumption levels |
| Workspace membership | User is member of ChatGPT Team workspace | License utilization |
| Session counts | 8 conversations today | Activity volume |

Example integrations: OpenAI / ChatGPT, Anthropic / Claude, Google Gemini.

**Not retrieved:** Conversation content, prompts, responses, uploaded files, or chat history.

### Productivity Suites

| Field | Example | Purpose |
|-------|---------|--------|
| Document activity count | 12 documents edited this week | Measure collaboration levels |
| Collaboration metrics | 3 co-editing sessions | Understand team workflows |
| License utilization | User has E5 license, active in SharePoint | Optimize license spend |
| Feature adoption | Uses Power Automate, Teams, SharePoint | Track tool adoption |

Example integrations: Microsoft 365 / SharePoint, Google Workspace.

**Not retrieved:** Document contents, email bodies, chat messages, file contents, or shared links.

### Writing & Communication Tools

| Field | Example | Purpose |
|-------|---------|--------|
| Usage frequency | Active 4 days this week | Track tool adoption |
| Feature usage | Uses tone detection, rewrite suggestions | Measure feature engagement |

Example integrations: Grammarly, Notion, Confluence.

**Not retrieved:** Text content, corrections, suggestions, page contents, or message bodies.

### Developer Tools

| Field | Example | Purpose |
|-------|---------|--------|
| Suggestion acceptance rate | 32% of completions accepted | Measure Copilot effectiveness |
| Seat utilization | Active Copilot user | License optimization |
| Feature adoption | Uses chat, completions, CLI | Track adoption depth |

Example integrations: GitHub Copilot, GitLab Duo.

**Not retrieved:** Code content, suggestions, prompts, repository contents, or diffs.

### Integration Controls

- **Opt-in only:** No integrations are enabled by default
- **Admin-authorized:** Each integration requires explicit administrator configuration with API credentials
- **Minimum scopes:** F7 requests only the API permissions needed for usage analytics — never broad read access
- **Disconnectable:** Any integration can be revoked at any time; historical data from that integration follows standard retention policies
- **Audited:** All integration connections and data retrievals are recorded in the audit log

## Data Never Captured

These are absolute guarantees about data F7 will never collect:

- **Prompt and response text** from any AI tool
- **File contents** of any kind
- **Email or chat message content**
- **Screenshots** (even when the optional vision model is enabled — frames are processed locally and immediately discarded)
- **Clipboard contents**
- **Passwords, tokens, or credentials**
- **Full browsing URLs** (only domain, never path or query string)
- **Activity from excluded apps** (zero telemetry)
- **Individual keystrokes** (only aggregate counts)

---

::: info Design Principle
These aren't just policies — the agent's code is architecturally incapable of capturing content. There are no code paths for reading prompt text, file contents, or clipboard data. The guarantees are enforced by the codebase, not just by configuration.
:::
