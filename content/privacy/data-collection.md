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
