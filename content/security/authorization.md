# Authorization Model

F7 implements a **hybrid ReBAC + ABAC** (Relationship-Based + Attribute-Based Access Control) authorization model. Every API request that accesses organization data passes through a Policy Decision Point (PDP) that evaluates relationships, roles, and context to produce an authorization decision.

## Why Not Just RBAC?

Simple role-based access (owner/admin/manager/viewer) doesn't express real-world data visibility rules:

- A **manager** should see data only for their **direct and indirect reports**, not all managers in the organization
- **Compensation data** should only be visible to roles with an explicit **compensation permission**, regardless of their general access level
- **Aggregate views** must enforce **k-anonymity** — if a department has fewer than 5 people, their data shouldn't appear in aggregate charts
- Some admins need access to **specific app categories** (e.g., "AI tools") without seeing all data

F7's PDP evaluates these rules on every request.

## Authorization Model

The authorization model defines six entity types and their relationships:

| Entity | Relationships |
|--------|--------------|
| **Organization** | `owner`, `admin`, `member` |
| **Team** | `org` (parent organization), `manager`, `member` |
| **User data** | `can_view`, `can_view_compensation`, `can_view_aggregate` |
| **App category** | `admin`, `can_view_app_data` |
| **Department** | Scopes visibility by organizational unit |
| **User** | Identity — the subject of authorization decisions |

Relationships are synchronized from your organization's structure: when an admin updates team membership or reporting chains, the authorization model updates automatically.

## How a Request Is Authorized

1. **Identity extraction** — The middleware identifies the requesting user from their session cookie, JWT, or API key
2. **PDP check** — The PDP evaluates whether the user has the required relationship to the requested resource (e.g., "Is this user a manager of the team that contains the requested employee?")
3. **Decision** — The PDP returns `allow` or `deny`, along with any **obligations** (see below)
4. **Response transformation** — If the decision includes obligations, the response is modified before being sent to the client

## Purpose-Specific Enforcement

Authorization is evaluated independently for each **data purpose**:

| Purpose | What It Controls |
|---------|-----------------|
| `user_data` | Access to individual employee telemetry, scores, and profiles |
| `compensation` | Access to salary, compensation, and economic valuation data |
| `app_categories` | Access to application-level usage data filtered by category |
| `team_data` | Access to team-level aggregates and comparisons |

Each purpose can be independently **enabled or disabled** per organization, allowing gradual rollout of fine-grained access controls.

## Manager-Chain Scoping

When a user with the `manager` role requests employee data, the PDP evaluates the **full reporting chain** — not just direct reports:

- A manager sees data for all employees who report to them directly or indirectly
- The reporting chain is computed via a **recursive query with cycle detection** to handle complex organizational structures
- If an employee's manager changes, their data visibility updates automatically

## Post-Response Obligations

The PDP can attach **obligations** to an authorization decision that transform the API response:

### Compensation Masking
If the requesting user lacks `can_view_compensation`, salary and economic valuation fields are automatically redacted from the response. The rest of the profile or dashboard data is returned normally.

### k-Anonymity Enforcement
Aggregate views (team analytics, department summaries) suppress groups smaller than a configurable threshold (default: 5 members). This prevents re-identification of individuals through small-group aggregation.

## Fail-Closed Design

- If the PDP sidecar is unreachable, **all admin-facing routes deny access**
- Agent telemetry ingestion, health checks, and personal-data endpoints are **exempt** — they use device or personal-JWT authentication, not the PDP
- Authorization decisions are **cached for 30 seconds** to minimize latency impact

## IdP Group Mapping

When using SSO, F7 can automatically provision roles from your identity provider's group claims:

- Map IdP groups to F7 roles (e.g., "Engineering Managers" → `manager`, "HR Leadership" → `admin`)
- Group mappings are evaluated at login — role changes in your IdP take effect on the user's next authentication
- Supports Microsoft Entra ID, Okta, Google Workspace, JumpCloud, and generic OIDC group claims

---

::: info Related
- [Security Architecture](/security/architecture) — The six-layer security model
- [Employee Controls](/privacy/employee-controls) — What managers and admins can see
- [SOC 2](/compliance/soc2) — How authorization maps to SOC 2 criteria
:::
