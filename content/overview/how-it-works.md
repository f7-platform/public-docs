# How It Works

F7 uses a **local-first architecture** designed around a core principle: process data on the device, transmit only what's needed, and protect privacy at every step.

## Data Flow

```
┌─────────────────────────────────────┐
│          Employee's Device          │
│                                     │
│  Work activity → Privacy filter →   │
│  Local AI model → Encrypted store   │
│                                     │
│  ✓ Only metadata (app names,        │
│    timing, click counts)            │
│  ✗ Never: prompts, files, emails,   │
│    screenshots, clipboard           │
└───────────────┬─────────────────────┘
                │  Encrypted (TLS 1.3)
                │  Structured metadata only
                ▼
┌─────────────────────────────────────┐
│           F7 Controller             │
│                                     │
│  Receives metadata → Computes       │◄──────────────────────┐
│  scores → Powers dashboards         │                       │
│                                     │   ┌───────────────────┴───────┐
│  ✓ Tenant isolation per org         │   │  Third-Party APIs (opt-in)│
│  ✓ Role-based access control        │   │                           │
│  ✓ Comprehensive audit logging      │   │  ChatGPT, Microsoft 365,  │
└───────────────┬─────────────────────┘   │  GitHub Copilot, etc.     │
                │                         │                           │
                │                         │  ✓ Usage metadata only    │
                │                         │  ✗ Never content          │
                │                         └───────────────────────────┘
                ▼
┌─────────────────────────────────────┐
│           Dashboards                │
│                                     │
│  Executives: team & org analytics   │
│  Managers: team-level insights      │
│  Employees: personal data only      │
└─────────────────────────────────────┘
```

## Step 1: On-Device Observation

The F7 agent runs on each employee's device and observes work patterns:

- **Which applications** are in use (app name and category — never window content)
- **Activity levels** (click counts, keystroke counts — never individual keystrokes)
- **AI tool interactions** (which AI provider, turn count, response sizes — never prompt or response text)
- **Session structure** (focus time, context switches, session duration)

The agent includes a **privacy filter** that strips personally identifiable information before any further processing.

## Step 2: Local AI Classification

A purpose-built on-device AI model runs **entirely on the device** to classify work patterns:

- Categorizes sessions by type (deep work, collaboration, admin, etc.)
- Scores AI interaction depth (surface use vs. integrated workflow)
- Detects anomalies locally

This classification happens before any data leaves the device. The model never sends prompts, responses, or content to any server.

## Step 3: Secure Transmission

Only structured, classified metadata is transmitted to the F7 Controller:

- Encrypted with **TLS 1.3** in transit
- Authenticated with per-device cryptographic credentials
- Compressed using Protocol Buffers for minimal bandwidth

What's transmitted is a structured record — app names, timing, counts, and classification labels. Never raw content.

## Third-Party Integrations (Opt-In)

Organizations can optionally connect F7 to third-party apps (e.g., ChatGPT, Microsoft 365, GitHub Copilot, Grammarly) via their APIs. When enabled, F7 retrieves **usage metadata** — session counts, feature adoption, seat utilization — never document contents, message text, or prompts. Each integration must be explicitly authorized by an administrator.

## Step 4: Scoring & Analytics

The F7 Controller computes insights from all data sources — agent metadata, employer-provided HR data, and third-party integration data:

- **AIQ Score**: A composite measure of AI adoption sophistication
- **Workflow patterns**: How teams integrate AI into their work
- **Trend analysis**: How adoption changes over time

## Step 5: Dashboard Access

Insights are presented through role-appropriate dashboards:

| Role | Sees | Access Method |
|------|------|---------------|
| **Executive** | Org-wide and team aggregates | Authenticated web dashboard |
| **Manager** | Their team's analytics | Authenticated web dashboard |
| **Employee** | Only their own data | Personal dashboard (planned) |

Managers see team-level patterns. They do not see individual employees' raw activity — only aggregate insights and scores.

---

::: info Key Takeaway
The F7 agent does the heavy lifting on the device. By the time data reaches the server, it's already structured metadata — no content, no PII, no surprises.
:::
