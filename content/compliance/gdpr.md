# GDPR Compliance

The F7 platform is designed with the EU General Data Protection Regulation (GDPR) as a foundational constraint — not an afterthought. Privacy by design (Art. 25) is embedded in every architectural decision.

## Lawful Basis

F7 processes workforce metadata under **legitimate interest** (Art. 6(1)(f)) of the deploying organization. The processing is proportionate: only work-pattern metadata is captured, never content.

## Data Controller vs. Processor

| Role | Entity |
|------|--------|
| **Data Controller** | Your organization (the F7 customer) |
| **Data Processor** | F7 Platform, Inc. |

F7 processes data only as directed by the deploying organization. A [Data Processing Agreement](/legal/dpa) governs this relationship.

## Article-by-Article Compliance

| Article | Requirement | How F7 Complies |
|---------|-------------|-----------------|
| **Art. 5(1)(a)** | Lawfulness, fairness, transparency | Organizational deployment with employee notification; personal dashboard shows what's captured |
| **Art. 5(1)(b)** | Purpose limitation | Each captured field has a documented purpose (scoring inputs only) |
| **Art. 5(1)(c)** | Data minimization | Metadata only — never content, screenshots, clipboard, or passwords |
| **Art. 5(1)(d)** | Accuracy | Real-time capture with session boundaries; daily rollups reconciled |
| **Art. 5(1)(e)** | Storage limitation | Configurable retention: 90 days raw, 12 months rollups |
| **Art. 5(1)(f)** | Integrity and confidentiality | TLS 1.3 in transit; AES-256-GCM at rest; role-based access control |
| **Art. 12** | Transparent information | Personal dashboard shows all captured data; this Trust Center is published publicly |
| **Art. 13** | Information at collection | Agent tray icon indicates active observation; personal dashboard accessible |
| **Art. 15** | Right of access | Personal dashboard provides full access to an individual's own data |
| **Art. 17** | Right to erasure | Full data deletion on request — agent wipes local data, server deletes all records |
| **Art. 20** | Right to data portability | Data export available via personal dashboard |
| **Art. 22** | Automated decision-making | Scores are advisory only — they inform managers but are never used for automated employment decisions |
| **Art. 25** | Data protection by design | Local-first processing; PII filtering before transmission; encryption at rest and in transit |
| **Art. 28** | Processor obligations | Data Processing Agreement available; F7 acts as processor under customer's controllership |
| **Art. 30** | Records of processing | Comprehensive audit log captures all data processing actions |
| **Art. 32** | Security of processing | Modern cryptography, role-based access, row-level tenant isolation, audit logging |
| **Art. 33** | Breach notification | Audit logging supports breach detection; incident response per customer DPA |
| **Art. 35** | Data Protection Impact Assessment | This documentation provides the required analysis inputs for enterprise DPIA |

## Key Privacy Safeguards

### Local-First Processing
The on-device AI model classifies behavior locally before any data is transmitted. Only structured, PII-scrubbed metadata reaches the server.

### Employer-Provided HR Data
In addition to agent-captured metadata, F7 processes HR data provided by the deploying organization (compensation, job title, department, hire date, etc.). This data is provided under the controller's authority — F7 does not independently collect it. Lawful basis and employee notification for this data is the responsibility of the deploying organization as data controller. See [Data Collection Details](/privacy/data-collection#employer-provided-data) for the full inventory.

### Third-Party App Integrations
With the controller's authorization, F7 can connect to third-party applications (e.g., ChatGPT, Microsoft 365, GitHub Copilot, Grammarly) via their APIs to retrieve usage metadata — session counts, feature adoption, seat utilization. These integrations are opt-in, admin-authorized, and retrieve **usage statistics only** — never document contents, prompts, messages, or file data. Under GDPR, the deploying organization (as data controller) is responsible for ensuring appropriate legal basis and notice before enabling each integration. See [Data Collection Details](/privacy/data-collection#third-party-app-integrations) for the full inventory.

### Content Is Never Captured
F7 never captures prompt text, file contents, email or chat messages, screenshots, clipboard contents, or browsing history. See [What We Never Collect](/privacy/data-collection#what-f7-never-captures) for the full list.

### Employee Controls
Employees can pause observation, exclude specific apps, restrict to work hours, and access their own data. See [Employee Controls](/privacy/employee-controls).

### Data Retention
Retention periods are configurable by the deploying organization. Defaults: 90 days for raw telemetry, 12 months for aggregated rollups. See [Data Retention](/privacy/data-retention).

## Data Protection Impact Assessment

Organizations deploying workforce analytics tools are recommended to conduct a DPIA under Art. 35. F7's documentation — including this Trust Center, the DPA, and the sub-processor list — provides the required analysis inputs.

---

::: info Need a DPA?
See our [Data Processing Agreement](/legal/dpa) for the contractual framework governing F7's role as data processor.
:::
