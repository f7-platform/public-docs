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

## Vision Model (Tier 3)

F7 offers an optional advanced feature (Tier 3) that uses an on-device vision model for deeper workflow analysis.

- This feature is **disabled by default** and must be enabled by the organization.
- When enabled, the vision model processes screen frames **entirely on the device** and discards them immediately.
- No frames are stored, transmitted, or accessible to anyone — only structured classification labels (e.g., "deep work", "code review") are produced.

## What Managers and Admins Can See

| Data | Manager | Admin |
|------|---------|-------|
| Individual's raw activity | No | Audit-logged access only |
| Individual's scores | For their direct reports | Audit-logged access |
| Team aggregates | Yes | Yes |
| Organization aggregates | No | Yes |

Managers see team-level patterns and aggregated insights. They do not have access to raw activity logs for individual employees.

## Privacy by Design

F7's scoring system is designed to assess AI adoption patterns at the team and organizational level. The controls described on this page are **technical enforcement mechanisms** — when observation is paused, the agent's event pipeline stops. When an app is excluded, the filter runs before any data enters the pipeline.

::: info How Controls Are Administered
Privacy controls are configured by your organization's F7 administrator. If you have questions about how F7 is deployed at your company — or want to request changes to your observation settings — contact your IT or HR team.
:::
