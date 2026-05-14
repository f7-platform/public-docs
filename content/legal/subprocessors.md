# Sub-processors

**Last Updated:** March 13, 2026

F7 Platform, Inc. uses the following sub-processors to provide the F7 AI Workforce Intelligence Platform. We notify customers before engaging new sub-processors.

## Current Sub-processors

| Sub-processor | Purpose | Data Processed | Location |
|---------------|---------|---------------|----------|
| **Railway** | Application hosting and database | Telemetry metadata, user identifiers, aggregated scores | United States |
| **PostgreSQL (via Railway)** | Primary data storage | All server-side data (tenant-isolated via Row-Level Security) | United States |
| **GitHub** | Source code hosting, CI/CD | No customer data | United States |

## Third-Party Event Integrations

When an organization enables third-party event integrations, F7 ingests event metadata from configured providers using credentials the customer provides. These providers are **not sub-processors** for F7-hosted processing — the third-party providers' own privacy policies and terms govern their platforms.

| Provider Category | Implemented Sources | Data Retrieved | Enabled By |
|-------------------|---------------------|----------------|------------|
| **Source control** | GitHub, GitLab, Bitbucket | Commit, pull request, branch, and review event metadata | Admin opt-in |
| **Issue/project management** | Jira, Linear, Asana | Ticket and sprint event metadata | Admin opt-in |
| **CI/CD** | Jenkins, GitHub Actions, GitLab CI, CircleCI | Build, test, and deployment event metadata | Admin opt-in |
| **Calendar/support/feature flags** | Google Calendar, Microsoft Outlook, Zendesk, LaunchDarkly | Meeting, support-ticket, and flag-change event metadata | Admin opt-in |
| **Custom workflows** | Generic webhooks | Customer-defined event metadata | Admin opt-in |

F7 never retrieves document contents, message text, prompt/response text, code diffs, repository contents, support conversation bodies, or file contents from any third-party integration.

## On-Premise Deployments

For on-premise deployments, no sub-processors are involved in customer data processing. The F7 controller runs entirely within the customer's infrastructure.

## What Sub-processors Can Access

Sub-processors provide infrastructure services only. They do not have application-level access to customer data. Database access is protected by:
- Row-Level Security enforcing tenant isolation
- Encrypted credentials (AES-256-GCM)
- Role-based access controls at the application layer

## Changes to Sub-processors

F7 will:
1. Notify customers at least **30 days** before engaging a new sub-processor
2. Provide details on the new sub-processor's role and data access
3. Allow customers to raise objections within the notification period

Subscribe to sub-processor change notifications by contacting **legal@fseven.ai**.

---

::: info Hosting your own?
F7 supports [on-premise deployment](/compliance/#deployment-options) for organizations that require complete data sovereignty with zero third-party data processing.
:::
