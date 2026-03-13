# Sub-processors

**Last Updated:** March 13, 2026

F7 Platform, Inc. uses the following sub-processors to provide the F7 AI Workforce Intelligence Platform. We notify customers before engaging new sub-processors.

## Current Sub-processors

| Sub-processor | Purpose | Data Processed | Location |
|---------------|---------|---------------|----------|
| **Railway** | Application hosting and database | Telemetry metadata, user identifiers, aggregated scores | United States |
| **PostgreSQL (via Railway)** | Primary data storage | All server-side data (tenant-isolated via Row-Level Security) | United States |
| **GitHub** | Source code hosting, CI/CD | No customer data | United States |

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
