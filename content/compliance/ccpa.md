# CCPA / CPRA Compliance

F7 is designed to satisfy the requirements of the California Consumer Privacy Act (CCPA) and the California Privacy Rights Act (CPRA).

## Applicability

F7 processes workforce data on behalf of customers (the deploying organization). Under CCPA, F7 acts as a **service provider** — processing personal information only as directed by the customer.

## Rights Compliance

| CCPA Right | How F7 Complies |
|-----------|-----------------|
| **Right to know** (§1798.100) | Published Trust Center details all captured data categories; personal dashboard planned for self-service access |
| **Right to delete** (§1798.105) | Full data deletion on request — agent wipes local data, server deletes all records, audit trail of deletion retained |
| **Right to opt-out of sale** (§1798.120) | F7 does not sell personal information. Cross-organization analytics use only anonymized statistical patterns with k-anonymity and differential privacy protections |
| **Right to non-discrimination** (§1798.125) | Exercising privacy rights (pausing observation, excluding apps) does not affect employment status or F7 scoring |
| **Right to correct** (CPRA §1798.106) | Data is captured in real-time from device activity — corrections are handled through the deploying organization's HR processes |
| **Right to limit use of sensitive PI** (CPRA §1798.121) | F7 captures only work-pattern metadata — no sensitive personal information as defined by CPRA |
| **Notice at collection** (§1798.100(b)) | Agent tray icon indicates observation is active; Trust Center publishes data categories collected |

## Data Categories

Under CCPA's data category framework:

| CCPA Category | F7 Applicability |
|---------------|-----------------|
| **Identifiers** | Device ID, user ID (assigned by organization) |
| **Internet or network activity** | Application usage patterns, AI tool interaction metadata (domains and timing only — never content); third-party app usage metadata via opt-in API integrations (session counts, feature adoption — never content) |
| **Professional or employment info** | Work patterns, productivity metrics (agent-captured metadata); job title, salary, department, employment type, hire date (employer-provided via HRIS/IdP/CSV) |
| **Geolocation** | Not collected |
| **Biometric information** | Not collected |
| **Audio, electronic, visual** | Not collected — no screenshots, recordings, or captures |
| **Protected classifications** | Not collected |

## Service Provider Obligations

F7 meets all CCPA service provider requirements:

- Processes personal information **only as directed** by the deploying organization
- Does not retain, use, or disclose personal information for purposes other than providing the F7 service
- Does not sell or share personal information
- Certifies understanding of CCPA restrictions in the [Data Processing Agreement](/legal/dpa)

## Reasonable Security

CCPA §1798.150 requires "reasonable security procedures and practices." F7 exceeds this standard:

- **AES-256-GCM** encryption at rest
- **TLS 1.3** encryption in transit
- **Argon2id** password hashing
- **Ed25519** cryptographic authentication
- **Row-Level Security** for multi-tenant isolation
- **Append-only audit logging** with 24-month retention
- **Memory-safe implementation** (Rust)

---

::: info Need details on what we collect?
See [Data Collection Details](/privacy/data-collection) for a comprehensive breakdown of captured and never-captured data categories.
:::
