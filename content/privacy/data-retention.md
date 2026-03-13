# Data Retention & Deletion

F7 retains data only as long as it's needed for analytics and scoring. Retention periods are configurable per organization, and any individual's data can be fully erased on request.

## Default Retention Periods

| Data Type | Retention | Notes |
|-----------|-----------|-------|
| **Raw telemetry** | 90 days | Individual activity records from agents |
| **Daily/weekly rollups** | 12 months | Aggregated summaries used for trend analysis |
| **Audit logs** | 24 months minimum | Immutable — cannot be shortened |
| **Agent local data** | Until synced, then pruned | Temporary on-device storage only |

## Configurable Retention

Organizations can adjust retention periods through the admin interface:

- Raw telemetry: Minimum 30 days, default 90 days
- Rollups: Minimum 90 days, default 12 months
- Audit logs: Fixed at 24 months minimum (cannot be reduced for compliance reasons)

When data reaches the end of its retention period, it is **permanently deleted** — not archived, not moved to cold storage.

## Right to Erasure

Any employee's data can be fully erased on request. The process:

1. **Request**: The organization's administrator initiates an erasure command through the admin API or dashboard.
2. **Server deletion**: All server-side records for the individual are permanently removed from all database tables.
3. **Device deletion**: The agent receives a remote command to wipe all local data for the individual.
4. **Audit trail**: A record that the erasure occurred is retained in the audit log — but the original data content is gone.

The erasure is complete and permanent. There is no "soft delete" or recoverability period.

## What Erasure Covers

| Storage Location | What's Deleted |
|-----------------|---------------|
| Controller database | All telemetry, scores, rollups, and analytics for the individual |
| Agent local database | All observations and cached data for the individual |
| Audit log | Original data is deleted; a record of the erasure event is retained |

## Data Portability

A personal dashboard is planned that will allow employees to view all data captured about their work patterns and export it in JSON format. In the meantime, data access requests can be made through the organization's F7 administrator.

## Deletion on Offboarding

When an employee leaves the organization, their data follows the standard retention schedule. The organization can also request immediate erasure through the same right-to-erasure process.

---

::: tip For Compliance Officers
F7's data retention and erasure capabilities are designed to satisfy GDPR Article 17 (right to erasure), CCPA §1798.105 (right to delete), and SOC 2 confidentiality criteria (C1.2). The audit trail of erasure events provides the documentation required for compliance reporting.
:::
