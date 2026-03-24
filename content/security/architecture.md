# Security Architecture

F7 enforces security at six independent layers. Each layer operates independently — a failure in one does not compromise the others.

## Layer 1: Transport Security

All communication between F7 components is encrypted in transit.

- **TLS 1.3** for all agent-to-controller communication
- **HSTS** with a one-year max-age, enforced on all responses
- **Certificate pinning** (SPKI) for agent connections — the agent validates the controller's public key hash on every connection
- **Mutual TLS** for controller-to-controller federation (multi-site deployments)

No data is ever transmitted in plaintext.

## Layer 2: Authentication

F7 uses distinct authentication mechanisms for different trust levels:

| Actor | Method |
|-------|--------|
| **Device agent** | Ed25519 signed JWT with per-device cryptographic credentials |
| **Admin user** | Argon2id password hash + session tokens (HttpOnly, Secure, SameSite cookies) |
| **Personal dashboard** | Agent-issued JWT scoped to individual's own data |
| **Webhooks** | HMAC-SHA256 per-organization tokens for integrity verification |

There are no shared secrets or static API keys. Every device has its own unique cryptographic identity, established during a one-time enrollment process.

## Layer 3: Authorization

Access is controlled by roles and scopes:

| Role | Can See |
|------|---------|
| **Owner** | Full organization administration + all data |
| **Admin** | Organization configuration + all analytics |
| **Manager** | Their team's analytics and scores |
| **Viewer** | Read-only access to permitted dashboards |

Agent access tokens carry explicit scopes (e.g., `telemetry:write`, `config:read`) that restrict what each device can do.

## Layer 4: Database Isolation

In multi-tenant deployments, PostgreSQL **Row-Level Security (RLS)** ensures that every database query is automatically scoped to the requesting organization. There is no way for one organization to access another's data, even through application-level bugs.

## Layer 5: Audit & Monitoring

Every significant action is recorded in an **append-only audit log**:

- **What was done** (action type, target resource)
- **Who did it** (actor identity)
- **When** (timestamp)
- **From where** (IP address)

The audit log cannot be modified or deleted. It is retained for a minimum of 24 months.

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
