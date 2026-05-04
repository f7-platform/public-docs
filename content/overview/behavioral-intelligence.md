# Behavioral Intelligence: How F7 Measures What Your Workforce Actually Does

## Executive Summary

Organizations have a visibility problem. They know what tools they've purchased. They can see who has logged in. But they don't know how people actually work — how engaged they are, what tools they rely on, how their workflows are evolving as new capabilities like AI enter the picture, or where the real load imbalances are.

F7 provides that visibility. It observes **how people work across all their tools** — not just AI tools — and converts that behavioral data into structured scores that can be baselined, tracked over time, and compared across teams. The result is an objective behavioral picture of workforce engagement, tool adoption, and work patterns that supports development conversations, resource decisions, and strategic planning.

A highly engaged person who hasn't adopted AI tools yet is still visibly valuable. Someone relying on AI as a crutch for minimal effort is also visible. F7 doesn't prescribe what "good" looks like — it provides the data to see what's actually happening.

This paper explains how F7 observes work behavior, how it converts raw telemetry into meaningful scores, what it can and cannot measure, and how organizations use it for workforce development.

---

## The Problem: You Can't Manage What You Can't See

Most organizations operate with significant blind spots in workforce intelligence:

- **License dashboards** tell you who activated a tool — not whether it changed how they work
- **Survey-based assessments** tell you what people say they do — not what they actually do
- **Manager intuition** works for small, co-located teams — and breaks down at scale, across remote and hybrid workforces
- **AI-specific dashboards** (Copilot, Claude, ChatGPT) show usage of one tool in isolation — not how it fits into the broader workflow, and nothing about the person's overall engagement

The harder questions remain unanswered: *Who is carrying the most load? Where are the engagement gaps? How are work patterns actually changing as new tools roll out? Is your workforce developing — or just treading water?*

---

## F7's Approach: Observe All Work Behavior, Not Just AI

F7's on-device agent observes work patterns passively across **every application a person uses** — creation tools, communication tools, browsers, AI tools, terminals, meeting apps, reference tools. It captures structured metadata about *which* tools are in use, *how long* someone spends in each, *when* they switch between them, and *when* work artifacts are produced. This is behavioral metadata, never content. See [Data We Collect](/overview/data-we-collect) for the full breakdown.

AI tool usage is one dimension of what F7 observes — an important one, given the pace of AI investment — but it sits within a broader picture of total work behavior. **A person who is deeply engaged across their tools, producing sustained focused work, and carrying heavy meeting load is visible in F7 whether they use AI or not.**

From this behavioral metadata, F7 builds three layers of insight:

### Layer 1: Effort and Activity Visibility

The foundational layer works for **every role, every customer, from day one**. It answers the most common workforce question: *Who is carrying load, and where are the imbalances?*

This layer uses signals the agent captures across all applications:

- **Active work time** — hours of actual keyboard and mouse activity per day/week
- **Work span** — first-active to last-active clock time (e.g., 6:04 AM – 5:22 PM)
- **Meeting density** — time in meeting applications, meeting count, proportion of the day spent in meetings
- **Tool distribution** — how time splits across creation tools, communication tools, reference tools, browsers, and AI tools
- **Session consistency** — how many days per week show active work sessions; regularity of work patterns
- **Focus blocks** — sustained single-application focus periods without context switching

This layer does **not** claim to measure quality or value. What it provides is **visibility into observable work activity and load distribution** — the foundation for informed conversations about capacity, balance, and where investment is going.

Consider two real workforce scenarios:

**The high-effort coordinator.** On from 6 AM to past 5 PM. Heavy meeting density with customers and internal teams. High active screen time. Uses relatively little AI — their value is sustained coordination, presence, and domain judgment. In a system that only measures AI usage, this person is invisible. In F7, their sustained effort, long work span, and meeting engagement are clearly visible.

**The quiet builder.** Heavy computer usage all day. Attends meetings but participates less vocally (introvert work style). Deep focus blocks in creation tools. High engagement but a pattern that might look "low energy" by meeting-participation metrics alone. In F7, their active time, deep work blocks, and tool engagement are visible regardless of how much they speak in meetings.

**The key principle:** Engagement and sustained effort have value independent of — and often greater than — AI tool adoption. A highly engaged person who hasn't adopted AI yet contributes more than a disengaged person who uses AI as a crutch for minimal work. F7 makes both patterns visible.

### Layer 2: Scored Behavioral Intelligence

Raw telemetry — click counts, active seconds, app names, session durations — is not useful on its own. F7 converts this raw data into **structured scores** that can be baselined, compared, and tracked over time.

This is how telemetry becomes actionable.

### Layer 3: Behavioral Craft Patterns

For roles where F7's observation surface is strong — primarily desktop-application workflows — the platform can measure behavioral patterns around tool interactions in more depth. These include how people engage with tool output, whether they verify and iterate, and how their workflows sequence across tools. This layer is described in more detail below.

---

## How F7 Converts Telemetry Into Scores

### The Scoring Framework

F7 uses a **four-dimensional scoring model** that evaluates each work session across four independent aspects of behavior. Each dimension produces a score from 0 to 100, computed from the behavioral signals captured during that session.

| Dimension | What It Measures | Example Signals |
|---|---|---|
| **Engagement** | How actively and sustainably someone works during a session | Active time percentage, sustained focus duration, context-switching frequency, session length |
| **Effectiveness** | How the person uses the tools available to them — including but not limited to AI tools | Tool interaction depth, workflow cadence, iteration patterns, breadth of tool usage within the session |
| **Integration** | How broadly someone works across different tool categories | Number of meaningful tools used, diversity of tool categories (creation, communication, reference, AI), cross-tool workflows |
| **Impact** | Observable output signals and productive patterns | Work artifacts produced (commits, documents), productive time, sustained deep work blocks |

These four scores are **always computed from behavioral heuristics** — weighted formulas applied to observable session data. They are not subjective ratings, AI-generated assessments, or self-reported metrics.

### From Sessions to Baselines

Individual session scores are rolled up into daily, weekly, and monthly baselines. This creates a **behavioral profile over time** for each person:

```
Raw telemetry (per minute)
    → Session scores (per work session, 4 dimensions × 0-100)
        → Daily rollups (averages, trends)
            → Weekly/monthly baselines (stable behavioral profile)
                → Percentile positioning (within team, role, org)
```

The baselines are what make the data useful for workforce conversations. A single session score is noisy. A 30-day baseline reveals real patterns: *This person consistently shows high engagement and deep focus blocks. This team's integration scores have been declining since Q3. This cohort of new hires is ramping faster than the previous cohort.*

### The Composite Score: AIQ

The four dimension scores are combined into a single composite metric — the **AIQ (AI Intelligence Quotient)** — that provides a headline number for each person's overall behavioral profile. AIQ is a weighted blend of Engagement, Effectiveness, Integration, and Impact, scaled to 0–100.

AIQ is designed to be a **conversation starter, not a verdict.** It tells you where to look, not what to conclude. A low AIQ doesn't mean someone is underperforming — it means their observable behavioral patterns differ from the scoring model's definition of engaged, integrated tool usage. The dimensional breakdown underneath always tells the richer story.

### What the Scores Are — and What They Aren't

**What they are:**

- A structured, consistent framework for converting raw behavioral telemetry into comparable numbers
- A baseline that can be tracked over time to see trends, shifts, and development
- An objective starting point for conversations about workforce patterns — not the ending point
- An evolvable model: the scoring weights, formulas, and dimensions are defined in versioned knowledge models that can be updated as work practices and tools change

**What they aren't:**

- Not a measure of work quality. High engagement ≠ high-quality output. The scores measure observable behavior, not the value of what was produced.
- Not a perfect proxy. Activity-based signals have inherent limits. Someone scrolling quickly through a document has "high engagement density" but may not be reading carefully. Someone sitting still and thinking has "low activity" but may be doing the most important work of the day. F7 acknowledges these limits openly.
- Not a fixed standard. Work practices evolve, tools change, and what "typical" looks like shifts over time. The scoring framework is designed to evolve with these changes — through versioned knowledge models that can be recalibrated — rather than being locked to any single definition.

**The honest framing:** F7's scores are the best available approximation of behavioral patterns from observable metadata. They are not perfect — behavioral proxies never are. But they provide a consistent, objective foundation that organizations can build on: baseline today, measure trends, identify outliers, and have data-informed conversations. The alternative is no data at all, or surveys and gut feel.

---

## Behavioral Craft Patterns: The Deeper Layer

For roles and workflows where F7's observation surface is strong — primarily desktop applications, development tools, and native creative tools — the platform can observe **behavioral patterns that indicate the depth and discipline of tool usage**.

This applies to all tools, but is especially informative around AI interactions because AI tools produce a distinct behavioral pattern: the person asks something, gets a response, and then either engages with that response (reads, verifies, iterates, integrates) or doesn't.

### What F7 Observes in Workflow Sequences

F7 sees application-level behavioral sequences:

```
Tool A active → Tool B active → Tool C active → Work artifact produced
```

Within these sequences, several observable properties carry meaning:

| Observable Property | What It Indicates |
|---|---|
| **Post-interaction engagement** | Whether someone spent meaningful time working with output from a tool, or moved past it immediately |
| **Verification transitions** | Whether someone checked output against other sources — running tests, consulting documentation, opening reference tools |
| **Iteration depth** | Whether someone went through multiple rounds of tool interaction with work in between, or accepted the first result |
| **Multi-source workflows** | Whether someone used multiple tools and sources in combination, or worked in isolation with a single tool |
| **Engagement intensity** | Whether time spent involved active interaction (scrolling, clicking, navigating) or passive presence |

These properties are measured through **behavioral proxies** — scroll and click activity, application focus duration, app-switch sequences, and timing. They are not measured through content inspection.

### Self-Relative and Cohort-Relative Measurement

F7 does not define a universal standard for what "good" work behavior looks like. Instead, it measures each person's behavior **relative to their own baseline** — and, for larger organizations, relative to peers in comparable roles.

Self-relative measurement handles a critical nuance: an expert who works quickly isn't being careless — they're efficient. A senior person who dwells longer isn't slow — they may be reviewing more complex output. What matters is the *pattern relative to that person's own norm*, not an absolute number.

For organizations with enough people in comparable roles (typically 20+ per role group), F7 can compare behavioral patterns across a cohort to identify what distinguishes different work styles. These patterns are discovered from the organization's own data, not predefined by F7, and they update automatically as tools and practices change.

---

## Driving Workforce Development

F7's data is most valuable when it informs **development conversations and strategic decisions** — not when it generates a number on a dashboard.

### For Leaders and Managers

| Use Case | What F7 Provides |
|---|---|
| **Identifying engagement patterns** | See which teams and individuals show sustained high engagement, deep focus, and broad tool integration — and where engagement is declining or inconsistent. A person with declining engagement scores over 90 days warrants a check-in conversation, not a reprimand. |
| **Understanding load imbalances** | Compare active time, work span, and meeting density across teams and roles. Surface where some people are carrying disproportionate load — especially in coordination-heavy roles that traditional metrics miss. |
| **Tracking tool adoption** | See how new tools (including AI) are actually being integrated into workflows over time, not just whether licenses are activated. Adoption isn't a binary — it's a behavioral curve. |
| **Guiding enablement investments** | When a team shows low integration scores, it may mean they need training — or it may mean their tools don't support integrated workflows. The data points to where to dig deeper. |
| **Informing resource conversations** | When team capacity, headcount, and observable work patterns don't align, leaders need data to have honest conversations. F7 makes effort and engagement patterns visible — not to punish, but to inform. |

### For Individuals (Personal Dashboard)

F7's planned personal dashboard will give employees direct visibility into their own behavioral data — their engagement trends, tool distribution, focus patterns, and scores over time. This supports:

- **Self-awareness:** "I didn't realize I spend 40% of my time in meetings and only 15% in deep focus."
- **Personal development:** "My integration score has been flat — I'm not using the new tools my team adopted."
- **Work-life balance signals:** "My work span has stretched to 12 hours/day over the last month."

### The Development Conversation, Not the Performance Review

F7 is designed to power development conversations:

*"Your engagement scores are strong and your focus blocks are some of the longest on the team. You're clearly carrying significant load. Let's talk about whether you have the support you need and whether there are tools that could help."*

*"The team's tool integration has been declining over the last quarter. What's changing in the workflow? Is there a training gap or a tooling gap?"*

*"You've been working 6 AM to 6 PM consistently. Your effort is visible and valued. Let's talk about sustainability and whether we can redistribute some of the coordination load."*

These are different from: *"Your score is 72, you need to get to 85."* F7 provides the data to start the conversation. The conclusion is human.

---

## What F7 Can and Cannot Measure

### What F7 Can Measure

| Capability | How |
|---|---|
| **Engagement and activity levels across all tools** | Active time, focus duration, session consistency, context-switching patterns — for every application, not just AI |
| **Work effort and load distribution** | Work span, meeting density, session hours — visible for every role |
| **Tool adoption and integration depth** | Which tools are used, how they're combined in workflows, whether adoption is growing or stalling |
| **Behavioral patterns around tool interactions** | Post-interaction engagement, verification transitions, iteration depth — strongest for desktop-app-heavy workflows |
| **Trends over time** | Whether engagement, integration, or effort patterns are improving, stable, or declining at individual, team, and org levels |
| **Cross-tool workflow context** | How different tools are used together in the same session — something no single vendor's dashboard reveals |

### What F7 Cannot Measure

| Limitation | Why |
|---|---|
| **Work quality or output value** | F7 observes behavior, not outcomes. High engagement ≠ high quality. Activity is a proxy, not proof. |
| **Content of any kind** | F7 never sees prompts, responses, code, documents, emails, or messages. It observes at the application level, not the content level. |
| **Thinking and judgment** | Some of the most valuable work — deliberation, decision-making, creative insight — produces zero observable telemetry. A pause in activity might be deep thought or a coffee break. F7 can't tell the difference. |
| **Mobile and phone-based work** | The agent runs on desktop/laptop devices. Work on phones, tablets, and in-person interactions is invisible. For people who do significant work on mobile, the captured picture is partial. |
| **Browser-based workflow detail** | When work happens inside browser tabs (Salesforce, Jira, Google Docs), the agent sees the browser and domain — not what's happening inside the web application. This is the most significant observability gap for non-engineering roles. |
| **In-tool micro-interactions** | Features like accepting or rejecting an inline code suggestion happen inside the IDE at a level F7 cannot observe. F7 sees the application and the behavioral sequence around it — not what happens within it. |

---

## Where the Signal Is Strong vs. Limited

F7's behavioral intelligence varies by role based on how much of a person's work happens in observable desktop applications.

| Role Type | Behavioral Depth | Effort Visibility | Notes |
|---|---|---|---|
| **Software engineers** | **Strong** | **Strong** | IDEs, terminals, AI tools, and git are all distinguishable with clear behavioral signals |
| **Designers (native tools)** | **Moderate** | **Strong** | Figma and similar tools are identifiable; canvas-level activity is not |
| **Data analysts / scientists** | **Moderate** | **Strong** | Notebooks, SQL tools, and terminals are distinguishable |
| **Sales, PM, HR, executives** | **Limited** | **Strong** | Browser-based tools limit craft-level patterns; effort and meeting data remain strong |
| **Coordination-heavy roles** | **Limited** | **Strong** | Effort visibility (work span, meetings, sustained presence) is the primary and most honest signal |

**The key takeaway:** Effort and activity visibility is strong across virtually all desktop-based roles. Behavioral craft patterns are an additional layer that increases in depth where the observation surface supports it. For roles where craft-level patterns are limited, F7 doesn't force unreliable scores — it shows what it can see honestly.

---

## The Scoring System: An Evolvable Framework

F7's scoring model is not presented as a perfect measure of human contribution. It is presented as what it is: **a structured, consistent framework for converting observable behavioral signals into numbers that can be baselined and tracked**.

Why this matters:

- **Without a framework, there's nothing to calibrate.** You can't improve what you can't measure. Even an imperfect measure that is consistent, objective, and transparent provides more value than no measure at all — or subjective measures that vary by manager.
- **The framework is designed to evolve.** Scoring weights, signal definitions, and dimensional taxonomy are defined in **versioned knowledge models** — structured data files that can be updated without changing the agent or server software. As work practices change and F7 learns what signals correlate with real outcomes, the models are updated.
- **Customers can participate in the evolution.** Enterprise customers can customize knowledge model parameters — adjusting weights, adding role-specific signal configurations, or tuning thresholds to match their workforce reality.
- **Baselines create accountability — for the model, not just the user.** When F7 establishes a 30-day baseline and that baseline shifts, either the person's behavior changed or the model needs recalibration. This creates a feedback loop: if scores don't align with observed reality, the model improves.

The honest position: F7's scores are a starting approximation built on the best available behavioral signals. They will get better over time as the framework is refined with real-world validation. They're a foundation to build on — not a finished answer.

---

## What F7 Is — and What It Isn't

### F7 Is:

- **A workforce intelligence platform** that provides objective behavioral data about how people work — across all their tools, not just AI.
- **A visibility tool** for engagement, effort, load distribution, and tool adoption — useful for workforce development, resource planning, and strategic decisions.
- **A scoring system** that converts raw behavioral telemetry into structured, comparable metrics that can be baselined and tracked over time.
- **A privacy-first architecture** where content never leaves the device, behavioral classification happens locally, and only structured metadata reaches the server.
- **A neutral measurement instrument** — it reports what it observes. It doesn't define what "good work" looks like for your organization.
- **An evolvable framework** — the scoring models are versioned data, not hard-coded logic. The system is designed to improve as work practices change and as validation data refines the models.

### F7 Is Not:

- **Not a productivity score.** Long hours do not equal good work. High tool usage does not equal effective work. F7 provides data for conversations, not rankings.
- **Not a performance management tool.** F7 data is designed for workforce intelligence and development conversations — not for individual performance reviews, disciplinary decisions, or ranking employees. Managers see team-level aggregates; individual self-service access is planned through the personal dashboard.
- **Not an AI-only tool.** AI adoption is one dimension F7 measures. Engagement, effort, focus, meeting load, tool breadth, and work patterns are measured across all applications. A highly engaged person who hasn't adopted AI yet is clearly visible — and clearly valuable.
- **Not a perfect measure.** Behavioral proxies have inherent limits. F7 is transparent about what it can and cannot see. The scores are a structured starting point, not a final judgment.
- **Not equally deep for all roles.** Behavioral craft patterns are strongest for desktop-app workflows. For browser-heavy roles, F7 provides strong effort visibility but limited behavioral depth. This is stated honestly.
- **Not a content inspector.** F7 never reads prompts, responses, code, documents, emails, or messages. The architecture is designed to make this impossible, not just policy.
- **Not a surveillance system.** A personal dashboard is planned for employees to inspect their own data. Managers see team-level aggregates — never individual behavioral details. The design includes structural guardrails, not just usage guidelines.

---

## Technical Architecture (Summary)

F7's behavioral intelligence runs on a three-stage pipeline:

**1. On-device observation.** A lightweight agent on each device observes application focus, activity levels, tool interactions, and work artifact production across all applications. A local AI model classifies sessions and work patterns entirely on-device. No content is captured at any stage.

**2. Secure transmission.** Only structured metadata — application names, timing data, activity counts, and classification labels — is transmitted to the F7 Controller over TLS 1.3 using Protocol Buffers. Content never leaves the device.

**3. Server-side scoring and analysis.** The Controller computes the four-dimension scores, rolls up baselines, identifies patterns, and powers dashboards. For organizations with sufficient cohort sizes, pattern discovery identifies behavioral differences across role groups — using the organization's own data, not externally defined standards.

### Knowledge Models

F7 uses **versioned, data-driven knowledge models** to define scoring taxonomies, dimensional weights, behavioral classifications, and coaching logic. These models are structured configuration — not hard-coded — and can be updated, versioned, and customized without software changes. This is how the measurement framework evolves as tools, practices, and validated insights change over time.

---

## Privacy and Guardrails

Behavioral intelligence raises legitimate questions about employee experience and data use. F7 addresses these structurally:

| Concern | F7's Approach |
|---|---|
| **"Will my manager see how I spend every minute?"** | Managers see team-level aggregates and distributions only. Self-service visibility into individual behavioral details is planned for the employee's personal dashboard. |
| **"Will this be used in my performance review?"** | F7 is designed for workforce intelligence and development conversations. Individual-level behavioral scores are not exportable. Team-level aggregates are. |
| **"What if I work in ways the system can't see?"** | F7 is transparent about its observation limits. When the system doesn't have enough signal to assess behavioral patterns, it says so — rather than guessing. |
| **"Can I see what F7 knows about me?"** | Data access is available through your organization's F7 administrator today. A personal dashboard for direct self-service access is planned. |
| **"Can I pause or exclude apps?"** | Yes. Employees can pause observation and exclude specific applications from tracking. |

For full privacy details, see the [Privacy Overview](/privacy/) and [Data We Collect](/overview/data-we-collect).

---

## Summary

F7 measures how people work — across all their tools, not just AI.

It provides three layers of value:

1. **Effort and activity visibility** — who is carrying load, where the engagement gaps are, how work patterns compare across teams and roles. This works for every role and every customer.

2. **Structured behavioral scores** — a four-dimensional scoring framework that converts raw telemetry into baselined, trackable metrics. Not a perfect measure — but a consistent, objective, evolvable foundation for workforce intelligence.

3. **Behavioral craft patterns** — deeper insight into how people engage with tool output, verify their work, and iterate on results. Strongest for desktop-app workflows; honest about where signal is limited.

None of these layers inspect content. All use behavioral metadata captured passively by the on-device agent. The system is transparent about where its signal is strong and where it's limited.

The result: organizations get objective, behavioral data to drive workforce development conversations, track tool adoption, and understand the real patterns of how their people work — not another dashboard counting clicks or prompts.

---

::: tip Want to go deeper?
- [Data We Collect](/overview/data-we-collect) — Complete breakdown of captured data
- [How It Works](/overview/how-it-works) — Technical architecture detail
- [Privacy Overview](/privacy/) — Privacy framework and employee controls
- [Security Overview](/security/) — Encryption, access control, and compliance
:::
