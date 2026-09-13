# GDPR

How Atlas relates to the EU General Data Protection Regulation. The answers depend on which deployment model you use, so the page says which model each statement is about.

## Roles

| Deployment | Your organisation | F7 |
|---|---|---|
| **The download** | Controller. You run the instance; F7 has no access to it, no copy of its data, and no ability to read, export or delete anything in it | Not a processor of the instance's data. F7 processes only what the instance sends outward for licensing and updates, and, on credit plans, the AI requests that pass through F7's gateway |
| **An instance F7 operates** | Controller | Processor. F7 hosts and administers the instance and processes data only to provide the service |

Regardless of model, the outside services listed in [How Atlas Runs](/overview/how-it-works#what-leaves-the-instance) process data in their own locations under their own terms, and on bring-your-own-key plans the AI provider is engaged under your agreement with them, not F7's.

## Lawful basis

Where a legal basis is required, F7 relies on performance of its agreement with you for providing the service, and on legitimate interests for security and metering. For the content you author, you are responsible for having the rights to whatever you put in.

## Rights and how they are met

| Article | Requirement | How Atlas meets it |
|---|---|---|
| **Art. 5(1)(c)** | Data minimisation | Atlas holds what you enter and the records the product needs. Usage metering is not linked to a person, and there is no analytics or tracking |
| **Art. 5(1)(e)** | Storage limitation | Usage metering is deleted after 90 days; links and sessions expire; the ledger is retained for the life of the instance by design |
| **Art. 12–13** | Transparency and information at collection | This Trust Center; the in-product explainers for voice and Rewind, which ask for consent at the point of enabling |
| **Art. 15** | Right of access | A product feature: you can see and export everything on the instance |
| **Art. 16** | Right to rectification | Account details, project content and memberships can be corrected |
| **Art. 17** | Right to erasure | Ordinary records can be deleted. The ledger is append-only: it can be destroyed in its entirety, never edited entry by entry, and this limit is stated in [Data Retention and Deletion](/privacy/data-retention#the-ledger-limit) |
| **Art. 20** | Right to data portability | The export archive: the signed ledger, your relational data, and the public keys needed to verify it, in a single file |
| **Art. 22** | Automated decision-making | Atlas makes no decision with legal effect on a person. The model never signs anything and never changes the record on its own; a person puts its output into the record |
| **Art. 25** | Data protection by design | Single-tenant instances; a complete, published list of what leaves; no background reporting; the AI provider under your control |
| **Art. 28** | Processor obligations | Apply to instances F7 operates. The data processing agreement published under [Legal](/legal/dpa) was written for F7's earlier product; an Atlas agreement is in legal review |
| **Art. 30** | Records of processing | The auth event log and the signed ledger record who did what on the instance |
| **Art. 32** | Security of processing | Argon2id password hashing, encrypted secrets, second factors and passkeys, per-request authorisation, a tamper-evident ledger. See [Security Overview](/security/) |
| **Art. 44–49** | International transfers | Hosted instances are operated in the United States only. If F7 begins serving customers where a transfer mechanism such as Standard Contractual Clauses is required, this page will be updated before that expansion |

## Requests

You already hold the access and export rights technically. For correction, deletion or objection, contact **privacy@fseven.ai**, and F7 will respond within 45 days. On the download, direct requests to whoever operates your instance, because F7 has no access to it.

## Data protection impact assessment

Organisations that need to conduct a DPIA can draw on this Trust Center: the deployment models, the complete list of what leaves the instance, the field-level inventory in [Data Atlas Holds (Details)](/privacy/data-collection), and the ledger limit. Atlas installs nothing on employees' devices and observes no one, so the assessment concerns the content your people choose to enter, not surveillance of them.
