# Security Architecture

F7 enforces security at six independent layers. Each layer operates independently — a failure in one does not compromise the others.

## Layer 1: Transport Security

All communication between F7 components is encrypted in transit.

- **TLS 1.3** for all agent-to-controller communication
- **HSTS** with a one-year max-age, enforced on all responses
- **Certificate pinning** (SPKI) for agent connections — the agent validates the controller's public key hash on every connection when operational pins are configured. Pin infrastructure is compiled into the agent binary; pins are rotated via agent updates.
- **Mutual TLS** for controller-to-controller federation (multi-site deployments)

No data is ever transmitted in plaintext.

## Layer 2: Authentication

F7 uses distinct authentication mechanisms for different trust levels:

| Actor | Method |
|-------|--------|
| **Device agent** | Ed25519 signed JWT with per-device cryptographic credentials |
| **Admin user (password)** | Argon2id password hash + session tokens (HttpOnly, Secure, SameSite cookies) |
| **Admin user (SSO)** | OAuth 2.0 / OIDC authorization code flow with PKCE |
| **Personal dashboard (planned)** | Agent-issued JWT scoped to individual's own data |
| **API integrations** | Org-scoped API keys for programmatic access |
| **Webhooks** | HMAC-SHA256 per-organization tokens for integrity verification |

There are no shared secrets. Every device has its own unique cryptographic identity, established during a one-time enrollment process.

### Single Sign-On (SSO)

F7 supports enterprise SSO via the **OAuth 2.0 / OIDC** authorization code flow with PKCE:

- **Supported identity providers:** Microsoft Entra ID (Azure AD), Okta, Google Workspace, JumpCloud, and any generic OIDC-compliant provider
- **IdP directory sync:** F7 can sync user identities and group memberships from your IdP, enabling automatic role provisioning based on IdP group claims
- **Auto-provisioning:** New users authenticated via SSO are automatically created with the role mapped from their IdP group membership
- **CSRF protection:** OAuth state is stored server-side in the database (not in-memory), surviving restarts and working across replicas

### API Keys

Organizations can generate **org-scoped API keys** for programmatic access to the F7 API. API keys are hashed before storage and carry the same role-based permissions as the admin user who created them.

## Layer 3: Authorization

F7 implements a **hybrid Relationship-Based Access Control (ReBAC) + Attribute-Based Access Control (ABAC)** authorization model powered by an [OpenFGA](https://openfga.dev)-compatible Policy Decision Point (PDP).

### Roles

| Role | Can See |
|------|---------|
| **Owner** | Full organization administration + all data |
| **Admin** | Organization configuration + all analytics |
| **Manager** | Their direct reports' analytics and scores |
| **Viewer** | Read-only access to permitted dashboards |

### Beyond Static Roles: Policy Decision Point

Unlike simple RBAC, F7's PDP evaluates **relationships and context** on every request:

- **Manager-chain scoping:** Managers see only data for their direct and indirect reports, determined by a recursive subordinate query with cycle detection
- **Purpose-specific enforcement:** Authorization is evaluated per data purpose — `user_data`, `app_categories`, and `team_data` — each with independent enforcement toggles
- **App-category delegation:** Admins can be granted access to specific app categories (e.g., "can view AI tool usage") without blanket access to all data
- **Department scoping:** Access can be scoped by department for cross-functional visibility without full organizational access

### Post-Response Obligations

The PDP attaches **obligations** to authorization decisions that transform responses after they are generated:

- **k-Anonymity enforcement:** Aggregate views suppress groups smaller than a configurable threshold (default: 5) to prevent re-identification

### Implementation

- **Fail-closed:** If the PDP is unreachable, admin-facing routes deny access. Agent telemetry and health-check paths are exempt because they use device authentication
- **Decision caching:** Authorization decisions are cached for 30 seconds to minimize latency
- **Exempt paths:** Agent telemetry ingestion and health checks bypass the PDP

Agent access tokens carry explicit scopes (e.g., `telemetry:write`, `config:read`) that restrict what each device can do.

See [Authorization](/security/authorization) for the full authorization model.

## Layer 4: Database Isolation

PostgreSQL **Row-Level Security (RLS)** ensures that every database query is automatically scoped to the requesting organization. There is no way for one organization to access another's data, even through application-level bugs.

- **Read and write enforcement:** RLS policies include `WITH CHECK` clauses that prevent INSERT and UPDATE operations from targeting another organization's rows — not just reads
- **Comprehensive coverage:** RLS is enforced on every organization-scoped table including users, teams, telemetry, scores, coaching, role profiles, enrollment tokens, and admin users
- **No bypass path:** Even direct SQL access through the application's database role is scoped by RLS. Only the superuser role (used for migrations) bypasses RLS.

## Layer 5: Audit & Monitoring

Every significant action is recorded in an **append-only, immutable audit log**:

- **What was done** (action type, target resource)
- **Who did it** (actor identity)
- **When** (timestamp)
- **From where** (IP address)

The audit log is protected by a **database trigger** that physically prevents UPDATE and DELETE operations — any attempt to modify or remove an audit entry raises a database exception. It is retained for a minimum of 24 months.

Additional monitoring includes:
- Rate limiting on all endpoint categories to prevent abuse
- Security headers (Content-Security-Policy, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy)
- CSP violation reporting and logging

## Layer 6: Encryption at Rest

| Data | Encryption |
|------|-----------|
| Server-side integration credentials | AES-256-GCM with versioned key format |
| Agent local database | AES-256 encrypted (SQLCipher) |
| Device credentials and tokens | OS-native secure storage (macOS Keychain, Windows Credential Manager, Linux Secret Service) |

Encryption keys are managed through environment-scoped secrets with support for key rotation.

## Input Validation & Rate Limiting

All inputs are validated before processing:

- Request payload size limits enforced (1 MB for telemetry, 256 KB general)
- Content-type verification on all requests
- Endpoint-specific rate limiting to prevent abuse

Requests exceeding rate limits receive a standard `429 Too Many Requests` response.

---

::: tip For Security Reviewers
F7 is built in Rust — a memory-safe language that eliminates buffer overflows, use-after-free, null pointer dereference, and data race vulnerabilities at compile time. The security benefits are not just policy — they're enforced by the compiler.
:::
