# Employee Controls

F7 includes privacy controls that limit what data is collected and when. These controls are configured by your organization's F7 administrator.

## Pause Observation

Administrators can **pause the F7 agent** for individual employees or teams via the controller.

- While paused, **zero data** is captured — no activity, no network metadata, no timing.
- Pause state persists across agent restarts.
- Employees can request a pause through their organization's normal channels.

## Application Exclusion List

Organizations can configure an **application exclusion list** that prevents the agent from capturing any data about specified applications.

- Excluded apps generate **zero telemetry** — no app name, no timing, no activity counts.
- The exclusion is absolute — it's as if the app isn't running.
- Common exclusions include personal messaging apps, health apps, and banking apps.
- Employees can request additions to the exclusion list through their organization.

## Work Hours Mode

Observation can be configured to run **only during defined work hours**.

- Outside configured hours, the agent does not observe or transmit any data.
- Supports timezone-aware scheduling and configurable work days (e.g., Monday–Friday only).
- Work hours are set by the organization and apply per-device.

## Personal Dashboard (Planned)

F7 will include a **personal dashboard** that gives employees direct visibility into the data captured about their work patterns.

- View all data associated with your account — activity metadata, scores, and session history.
- Export your data in JSON format for portability.
- Opt-in — employees choose whether to access it.

This feature is on the roadmap but has not yet been prioritized for release.

## Vision Model (Mode 3 — Interpret)

F7 offers an optional advanced feature (Mode 3 — Interpret) that uses an on-device vision model for continuous interpretation of work activity.

- This feature is **disabled by default** and must be enabled by the organization.
- When enabled, the vision model processes screen frames **entirely on the device** and discards them immediately.
- No frames are stored, transmitted, or accessible to anyone — only structured classification labels (e.g., "deep work", "code review") are produced.

## What Managers and Admins Can See

| Data | Manager | Admin |
|------|---------|-------|
| Individual's raw activity | No | Audit-logged access only |
| Individual's scores | For direct and indirect reports only | Audit-logged access |
| Compensation / salary data | No (masked by PDP) | Only with explicit compensation permission |
| Team aggregates | For their team only | Yes |
| Organization aggregates | No | Yes |
| Small-group aggregates (< 5 people) | Suppressed (k-anonymity) | Suppressed (k-anonymity) |

Access control is enforced by a **Policy Decision Point (PDP)** that evaluates the requesting user's relationship to the data on every request:

- **Manager-chain scoping:** Managers see data only for employees in their direct and indirect reporting chain — not all employees at their level
- **Compensation masking:** Salary and economic valuation fields are automatically redacted unless the user has an explicit `can_view_compensation` permission
- **k-Anonymity:** Aggregate views suppress groups smaller than a configurable threshold (default: 5) to prevent identification of individuals through small-group data
- **Purpose-specific toggles:** Each data purpose (`compensation`, `user_data`, `app_categories`, `team_data`) can be independently enabled or disabled per organization

See [Authorization](/security/authorization) for the full authorization model.

## Privacy by Design

F7's scoring system is designed to assess AI adoption patterns at the team and organizational level. The controls described on this page are **technical enforcement mechanisms** — when observation is paused, the agent's event pipeline stops. When an app is excluded, the filter runs before any data enters the pipeline.

::: info How Controls Are Administered
Privacy controls are configured by your organization's F7 administrator. If you have questions about how F7 is deployed at your company — or want to request changes to your observation settings — contact your IT or HR team.
:::
