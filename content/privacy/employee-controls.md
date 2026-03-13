# Employee Controls

F7 is designed to give employees direct, meaningful control over how their work data is collected and used. These controls are built into the product — they cannot be overridden by administrators.

## Pause Observation

Any employee can **pause the F7 agent** at any time through the system tray icon.

- While paused, **zero data** is captured — no activity, no network metadata, no timing.
- Pausing does not require approval or notification.
- There is no penalty or flag for using the pause function.

## Exclude Applications

Employees can add applications to a **personal exclusion list** (blocklist).

- Excluded apps generate **zero telemetry** — no app name, no timing, no activity counts.
- The exclusion is absolute — it's as if the app isn't running.
- Excludable apps include personal tools, health apps, banking apps, or anything else.

## Work Hours Mode

Observation can be configured to run **only during defined work hours**.

- Outside configured hours, the agent does not observe or transmit any data.
- Work hours boundaries are configurable per device.

## Personal Dashboard

Employees can opt in to a **personal dashboard** that shows exactly what data F7 has captured about their work patterns.

- The dashboard is **opt-in** — it must be actively enabled by the employee.
- It shows the individual's own data **only** — no access to team or organizational data.
- Access is through a separate authentication mechanism scoped to the individual.
- All access to the personal dashboard is logged in the audit trail.

## Vision Model Consent

F7 offers an optional advanced feature (Tier 3) that uses an on-device vision model for deeper workflow analysis.

- This feature is **disabled by default**.
- Enabling it requires **explicit, individual consent** — it cannot be force-enabled by an administrator.
- When enabled, the vision model processes screen frames **entirely on the device** and discards them immediately. No frames are stored, transmitted, or accessible to anyone.

## What Managers and Admins Can See

| Data | Employee | Manager | Admin |
|------|----------|---------|-------|
| Individual's raw activity | Via personal dashboard (opt-in) | No | Audit-logged access only |
| Individual's scores | Via personal dashboard | For their direct reports | Audit-logged access |
| Team aggregates | No | Yes | Yes |
| Organization aggregates | No | No | Yes |

Managers see team-level patterns and aggregated insights. They do not have access to raw activity logs for individual employees.

## No Retaliation Guarantee

By design, exercising any privacy control — pausing observation, excluding apps, declining the vision model — does not generate any negative signal, flag, or marker visible to managers or administrators.

The F7 scoring system is designed to assess AI adoption patterns, not to penalize people for exercising their privacy rights.

---

::: info For Employees
The F7 agent works for your organization, but these controls work for you. Pause when you want, exclude what you want, and see exactly what's captured through the personal dashboard.
:::
