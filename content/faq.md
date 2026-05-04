# Frequently Asked Questions

## General

### What does F7 actually do?
F7 is a workforce intelligence platform that observes how employees use AI tools and work applications. It captures behavioral metadata — not content — to help organizations measure AI adoption, identify skill gaps, and optimize workforce strategy.

### Is F7 a keylogger or surveillance tool?
**No.** F7 never captures individual keystrokes, file contents, emails, chat messages, or any content sent off the device. It captures metadata only — things like "which application was in the foreground" and "how many clicks occurred," not "what was typed."

The optional Mode 3 — Interpret vision feature processes screen frames **locally on the device** for an on-device vision-language model and discards them immediately after inference; frames never leave the device and are never uploaded. Mode 3 is opt-in and must be explicitly enabled by the organization. See [Vision Model controls](/privacy/employee-controls#vision-model-mode-3-interpret).

### Who can see my data?
- **You** will be able to see your own data through a personal dashboard (planned)
- **Your manager** can see analytics for their direct and indirect reports only — enforced by a Policy Decision Point (PDP) that evaluates reporting chains on every request
- **Admins** see organization-level analytics and configuration pages, with audit logging for individual-data access
- **Aggregate views** enforce k-anonymity — groups smaller than 5 people are suppressed to prevent re-identification
- **F7 staff** cannot see your data — it's encrypted and tenant-isolated

---

## Privacy

### What exactly does F7 collect?
Work-pattern metadata: application names, click/keystroke counts (not content), time-in-app, AI tool interaction timing, session structure. See [Data We Collect](/overview/data-we-collect) for the full list.

### What does F7 never collect?
Prompt text, file contents, emails, chat messages, screenshots, clipboard contents, passwords, full URLs, or personal app activity for excluded apps. See [What We Never Capture](/privacy/data-collection#what-f7-never-captures).

### Can I pause F7?
**Yes.** You can pause observation at any time using the agent's tray icon. You can also exclude specific apps and restrict observation to work hours. See [Employee Controls](/privacy/employee-controls).

### Can I see what F7 has collected about me?
**Yes.** A personal dashboard is planned that will show all data associated with your account. In the meantime, you can request your data through your organization's F7 administrator.

### Can I delete my data?
**Yes.** Data deletion can be requested through your organization's F7 administrator. Deletion removes data from both the agent (your device) and the server.

---

## Security

### How is my data encrypted?
- **In transit:** TLS 1.3 for all agent-to-server communication
- **At rest on device:** AES-256 encrypted local database
- **At rest on server:** AES-256-GCM for sensitive data; database-level encryption

See [Encryption](/security/encryption) for details.

### Is F7 built with security in mind?
F7 is written in **Rust**, a memory-safe language that eliminates entire classes of vulnerabilities (buffer overflows, use-after-free, data races) at compile time. The platform uses modern cryptography throughout and is tracked through the Run 27b security audit baseline.

### Where is my data stored?
For cloud deployments, data is stored in the United States on Railway infrastructure with PostgreSQL. For on-premise deployments, data stays entirely in your infrastructure. See [Sub-processors](/legal/subprocessors).

### Can F7 be deployed on-premise?
**Yes.** F7 supports single-binary on-premise deployment with identical security controls. No data leaves your environment.

---

## Compliance

### Is F7 GDPR compliant?
**Yes.** F7 implements privacy by design (Art. 25), data minimization (Art. 5(1)(c)), right to erasure (Art. 17), right of access (Art. 15), and more. See [GDPR Compliance](/compliance/gdpr).

### Is F7 SOC 2 certified?
F7 has implemented controls aligned with all five SOC 2 trust service criteria. Independent certification is planned. Contact **security@fseven.ai** for the current status. See [SOC 2](/compliance/soc2).

### Do you have a DPA?
**Yes.** See our [Data Processing Agreement](/legal/dpa).

### How do I fill out a security questionnaire for F7?
Our [Compliance Overview](/compliance/) includes a quick-reference table addressing the 15 most common vendor security questionnaire items. For detailed support, contact **security@fseven.ai**.

---

## Deployment

### How is the agent installed?
The F7 agent is a lightweight binary deployed to employee devices. Enrollment uses a one-time token that binds the device to your organization — no shared secrets or manual configuration required.

### What operating systems are supported?
The F7 agent supports macOS and Windows, with Linux support planned.

### Does the agent affect device performance?
The agent is designed to be lightweight. The on-device AI model runs during idle periods and does not interfere with foreground work.

### What happens if the agent loses connection to the server?
The agent stores data locally in an encrypted database and syncs when connectivity is restored. No data is lost.

---

## Contact

| Topic | Contact |
|-------|---------|
| Security inquiries | security@fseven.ai |
| Privacy questions | privacy@fseven.ai |
| Legal and compliance | legal@fseven.ai |
| General questions | hello@fseven.ai |
