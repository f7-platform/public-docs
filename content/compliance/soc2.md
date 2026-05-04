# SOC 2 Type II

F7 implements controls aligned with all five SOC 2 trust service criteria. Our goal is to give your security and compliance teams confidence that F7 meets enterprise-grade standards.

## Certification Status

::: warning Current Status
F7 has implemented controls across all five SOC 2 trust service criteria. An independent SOC 2 Type II audit is planned. Contact us at **security@fseven.ai** for the current status.
:::

## Trust Service Criteria

### Security (Common Criteria)

| Criteria | Requirement | F7 Controls |
|----------|------------|-------------|
| **CC1.1** | Integrity and ethical values | Privacy-by-design principles; metadata-only capture; published guarantees on what is never collected |
| **CC5.1** | Control activities over technology | Six authentication layers; role-based access control; input validation; rate limiting; security headers |
| **CC6.1** | Logical access controls | Cryptographic device authentication (Ed25519); Argon2id admin password hashing; OAuth 2.0/OIDC SSO with PKCE; constant-time secret comparison |
| **CC6.2** | Credential issuance controls | Enrollment tokens with usage limits, expiry, and organization binding |
| **CC6.3** | Access restricted to authorized users | Hybrid ReBAC+ABAC PDP authorization; four roles with manager-chain scoping; purpose-specific enforcement toggles; compensation masking; k-anonymity; row-level database security |
| **CC6.6** | Infrastructure credential management | Environment-based key management; key rotation procedures; OS keychain for device credentials |
| **CC6.7** | Transmission restrictions | TLS 1.3; HSTS with 1-year max-age; certificate pinning for agent connections |
| **CC6.8** | Prevention of unauthorized changes | Cryptographic integrity verification on configuration; digital signing on licensing data; trigger-protected immutable audit log |
| **CC7.1** | Detection of unauthorized activity | Rate limiting; audit logging; CSP violation reporting; license tamper detection |
| **CC7.2** | Anomaly monitoring | Clock-jump detection; token replay detection with full device revocation |
| **CC8.1** | Change management | Changelog requirements; automated dependency auditing in CI; proto-drift detection across services |
| **CC9.1** | Vendor risk mitigation | Dependency auditing; memory-safe language (Rust); vetted cryptographic libraries |

### Availability

| Criteria | Requirement | F7 Controls |
|----------|------------|-------------|
| **A1.1** | Environmental safeguards | Cloud or on-premise deployment; configurable connection pooling |
| **A1.2** | Recovery mechanisms | License grace period (30 days); graceful degradation (read-only mode, not hard failure) |

### Confidentiality

| Criteria | Requirement | F7 Controls |
|----------|------------|-------------|
| **C1.1** | Confidential information identified | Published data classification; credentials identified for encryption |
| **C1.2** | Confidential information disposed | Configurable retention periods per data type; full data erasure on request |

### Processing Integrity

| Criteria | Requirement | F7 Controls |
|----------|------------|-------------|
| **PI1.1** | System accuracy | Input validation (size limits, content-type enforcement, allowlists); data integrity verification |

### Privacy

| Criteria | Requirement | F7 Controls |
|----------|------------|-------------|
| **P1.1** | Privacy notice | Agent tray icon; this published Trust Center; personal dashboard planned |
| **P2.1** | Consent | Organizational deployment consent; personal dashboard will be opt-in |
| **P3.1** | Collection limited to purpose | Metadata-only capture; documented field purposes |
| **P4.1** | Restricted use | Data used only for scoring and analytics |
| **P5.1** | Access to personal data | Data access via administrator; personal dashboard planned for self-service |
| **P6.1** | Disclosure restricted | Row-level tenant isolation; anonymized cross-organization analytics |
| **P7.1** | Accuracy maintained | Real-time capture; daily rollup reconciliation |

## Security Testing

F7 maintains an ongoing security program:

- **Run 27b security audit baseline** with documented findings, remediation, and delta tracking
- **Automated dependency auditing** in CI on every commit
- **Memory-safe codebase** (Rust) eliminating buffer overflows, use-after-free, and data races at compile time
- **Third-party penetration testing** planned

## Requesting the SOC 2 Report

Contact **security@fseven.ai** to request the current SOC 2 report or to schedule a security review call.

---

::: info Related
- [Security Architecture](/security/architecture) — Technical details on the six-layer defense model
- [Encryption](/security/encryption) — Cryptographic inventory and key management
:::
