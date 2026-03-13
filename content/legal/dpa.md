# Data Processing Agreement

**Version:** 1.0
**Effective Date:** March 13, 2026

This Data Processing Agreement ("DPA") forms part of the agreement between F7 Platform, Inc. ("Processor" or "F7") and the customer organization ("Controller" or "Customer") for the provision of the F7 AI Workforce Intelligence Platform (the "Service").

## 1. Definitions

- **Personal Data:** Any information relating to an identified or identifiable natural person, as defined by applicable data protection law.
- **Processing:** Any operation performed on Personal Data, including collection, storage, analysis, and deletion.
- **Sub-processor:** A third party engaged by F7 to process Personal Data on behalf of the Customer.

## 2. Roles and Scope

| Role | Entity | Responsibilities |
|------|--------|-----------------|
| **Data Controller** | Customer | Determines purposes and means of processing; ensures lawful basis; notifies employees |
| **Data Processor** | F7 Platform, Inc. | Processes Personal Data only on Customer's instructions; implements security measures |

F7 processes the following categories of Personal Data:
- Device identifiers and user identifiers (assigned by Customer)
- Work-pattern metadata (application usage, session timing, AI tool interaction metadata)
- Aggregated scoring data

F7 does **not** process: content data, communications, screenshots, file contents, or browsing history.

## 3. Processing Instructions

F7 will process Personal Data only in accordance with:
- The service agreement between F7 and Customer
- Customer's documented instructions
- Applicable data protection law

## 4. Security Measures

F7 implements the following technical and organizational measures:

| Category | Measures |
|----------|---------|
| **Encryption in transit** | TLS 1.3 for all communications |
| **Encryption at rest** | AES-256-GCM (server); AES-256 (agent local storage) |
| **Access control** | Role-based access (four roles); row-level database tenant isolation |
| **Authentication** | Ed25519 cryptographic device auth; Argon2id admin password hashing |
| **Audit logging** | Append-only log with 24-month retention |
| **Local processing** | On-device AI model processes data before transmission |
| **Memory safety** | Rust-based implementation eliminates common vulnerability classes |

## 5. Sub-processors

F7 uses sub-processors to provide the Service. The current list is available at [Sub-processors](/legal/subprocessors).

F7 will:
- Notify Customer before engaging new sub-processors
- Ensure sub-processors are bound by data protection obligations no less protective than this DPA
- Remain liable for sub-processor compliance

## 6. Data Subject Rights

F7 will assist Customer in responding to data subject requests, including:
- **Right of access:** Personal dashboard provides individual data access
- **Right to erasure:** Full data deletion capability (agent and server)
- **Right to portability:** Data export from personal dashboard
- **Right to restriction:** Observation pause, app exclusion, work-hours restriction

## 7. Data Breach Notification

F7 will notify Customer without undue delay (and in any event within 72 hours) upon becoming aware of a Personal Data breach. Notification will include:
- Nature of the breach
- Categories and approximate number of affected individuals
- Likely consequences
- Measures taken or proposed to address the breach

## 8. Data Retention and Deletion

Upon termination of the service agreement:
- F7 will delete all Customer Personal Data within 30 days
- Customer may request data export before deletion
- Audit logs may be retained as required by applicable law

During the term, retention periods are configurable by Customer (see [Data Retention](/privacy/data-retention)).

## 9. International Transfers

Where Personal Data is transferred outside the European Economic Area:
- F7 will ensure appropriate safeguards are in place
- Standard Contractual Clauses (SCCs) are incorporated by reference where applicable
- On-premise deployment option available for full data sovereignty

## 10. Audits

Customer may audit F7's compliance with this DPA:
- With reasonable notice (at least 30 days)
- No more than once per year (unless a breach has occurred)
- F7 will provide reasonable cooperation and access

## 11. Term

This DPA remains in effect for the duration of the service agreement and until all Personal Data has been deleted or returned.

---

::: info Download
A signed PDF version of this DPA is available upon request. Contact **legal@fseven.ai**.
:::
