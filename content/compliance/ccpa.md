# CCPA / CPRA

How Atlas relates to the California Consumer Privacy Act and the California Privacy Rights Act.

## Applicability

On an instance F7 operates, F7 acts as a **service provider**: it processes personal information only to provide the service, and only as directed by the customer organisation. On the download, F7 does not process the instance's data at all; the only personal information F7 receives is what you give it when you connect an account for licensing.

F7 does not sell personal information and does not share it for cross-context behavioural advertising.

## Rights

| Right | How Atlas meets it |
|---|---|
| **Right to know** (§1798.100) | This Trust Center states every category held and every purpose for which data leaves the instance. Access and export are product features |
| **Right to delete** (§1798.105) | Ordinary records can be deleted. The ledger is append-only and can only be destroyed whole; see [the ledger limit](/privacy/data-retention#the-ledger-limit) |
| **Right to correct** (§1798.106) | Account details and project content can be corrected in the product |
| **Right to opt out of sale or sharing** (§1798.120) | Not needed: F7 does not sell or share personal information |
| **Right to limit use of sensitive personal information** (§1798.121) | Atlas collects no sensitive personal information by design. You can type anything into the content you author, and that content is yours to manage |
| **Right to non-discrimination** (§1798.125) | Exercising a privacy right has no effect on your access to the service |
| **Notice at collection** (§1798.100(b)) | This Trust Center, and the in-product explainers that ask for consent before voice or Rewind is turned on |

## Data categories

| CCPA category | Applicability |
|---|---|
| **Identifiers** | Email address, optional display name, and a pseudonymous identifier in ledger entries that only an authorised reader of the instance can resolve to a person |
| **Commercial information** | Plan and licence binding, where you connect an account |
| **Internet or network activity** | Not collected. Atlas contains no analytics or tracking |
| **Audio, electronic or visual information** | A voice recording is sent to the speech provider for transcription only when voice is configured and consented to. Rewind captures pictures of a reviewer's own screen only when that reviewer turns it on, and is absent from customer deployments today |
| **Professional or employment information** | Whatever you author. Atlas does not collect it from anyone's device |
| **Geolocation, biometric information, protected classifications** | Not collected |
| **Inferences** | None. Atlas builds no profile of a person |

## Service-provider obligations

On instances F7 operates, F7 processes personal information only as directed by the customer, does not retain, use or disclose it for any purpose other than providing the service, and does not sell or share it. The data processing agreement published under [Legal](/legal/dpa) was written for F7's earlier product; an Atlas agreement is in legal review, and **legal@fseven.ai** can provide the current draft.

## Reasonable security

CCPA §1798.150 requires reasonable security procedures and practices. What Atlas implements:

- Argon2id password hashing, never a reversible password
- Second factors (time-based codes, passkeys) and single-use hashed recovery codes
- Secrets encrypted at rest with AES-256-GCM, or held in the operating system keychain
- Access checked on every request, denied by default
- A structured auth event log and an append-only, signed, hash-chained ledger
- One instance and one database per customer, with no shared store
- A memory-safe server implementation (Rust)

See [Security Overview](/security/) for the full posture, including what is not built.
