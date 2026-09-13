# Frequently Asked Questions

## General

### What does Atlas actually do?
Atlas captures how work actually gets done — through interviews, process maps, decisions, and the standards a business has to satisfy — and records the result so it can be verified later. It signs what it records and keeps an append-only ledger of significant events. See [What Is Atlas?](/overview/what-is-atlas).

### Is Atlas a monitoring tool?
**No.** Atlas installs nothing on anyone's device other than the machine that runs the instance, and it observes no one. The only screen capture in the product, the feedback recorder called Rewind, records the screen of the reviewer who turns it on, and it is absent from customer deployments today. See [Atlas Rewind](/privacy/data-collection#atlas-rewind).

### What happened to the F7 agent product this site used to describe?
F7 previously offered a workforce-analytics product — a device agent, a server and management dashboards. That product has been shelved and is not offered. This Trust Center describes Atlas only; the documents under Legal were written for the earlier product and carry a notice saying so.

### Who can see my data?
- **On the download:** your organisation, according to the project permissions you set. No one at F7 has access to it.
- **On an instance F7 operates:** your organisation, and F7 staff for support, maintenance and security only.
- **Within a project:** what your role allows — reader, writer or administrator — checked on every request.

---

## Privacy

### What leaves the instance?
Only what is on the published list: requests to the AI provider you configure, a voice recording when voice is on, the sources you ask Atlas to fetch, connected repositories, email, and the licence and update checks that keep the download running. The list is complete and is in [How Atlas Runs](/overview/how-it-works#what-leaves-the-instance).

### Does Atlas send analytics or crash reports?
**No.** Atlas contains no analytics, no tracking, and no automatic crash or error reporting. An error report is built and stored in your browser and is sent only if you choose to send it.

### Does F7 train AI models on my content?
F7 trains no AI models on your content. What a model provider does with a request is governed by that provider's terms; on plans where you supply your own key, that is your agreement with them, not F7's.

### Can F7 read my provider key?
Where you supply your own key, Atlas uses it to make the requests you ask for and for nothing else. On an instance F7 operates, that is a commitment rather than an impossibility, because the key is encrypted under an instance master key that F7 holds. If you would rather not rely on a promise, issue Atlas a key that is scoped and spend-limited on your provider account.

### Can I export my data?
**Yes.** Atlas produces a single archive containing the signed ledger, your relational data, and the public keys needed to verify the signatures independently, at any time.

### Can I delete my data?
Ordinary records — account details, project content, memberships — can be corrected or deleted. The ledger is append-only: it can be destroyed in its entirety, never edited entry by entry. See [the ledger limit](/privacy/data-retention#the-ledger-limit).

---

## Security

### How is my data protected?
Passwords are hashed with Argon2id; secrets are encrypted at rest; second factors and passkeys are supported; sessions can be revoked; access to project data is checked on every request and denied by default; sign-in attempts and administrative actions are recorded. Hosted instances are served over HTTPS. See [Security Overview](/security/).

### Is the database encrypted at rest?
Secrets are. The database files are not encrypted by Atlas itself: on the download, use your operating system's disk encryption on the machine that runs it.

### What does a signature prove?
That specific content was signed by a specific key and has not changed since. It does not prove that the content is true, that the signer had authority, or that the key belongs to who you think it does. See [Encryption and Signing](/security/encryption).

### Are signing keys held in hardware?
**No.** F7 ships no hardware security module integration and operates no key-management service. An operator can hold keys in a module they provide.

### Has Atlas been penetration tested? Is it SOC 2 certified?
No independent penetration test report is available, and F7 does not hold a SOC 2 report. Both are stated as absent rather than as planned. See [SOC 2](/compliance/soc2).

### How do I verify a download?
Every release attaches checksums, and the macOS and Windows artifacts are notarized and Authenticode signed respectively. Updates arrive through a manifest signed with a key whose public half is published and compiled into the app. See [Downloads and Updates](/security/downloads).

---

## Deployment

### How is Atlas installed?
Download the signed installer for macOS or Windows. One download is the whole product: the web application is compiled into the binary and it starts its own private PostgreSQL. Open it and your browser opens with Atlas running locally.

### Can it run on-premise or air-gapped?
**Yes.** The download runs on your own machine or server. Licences verify offline against keys compiled into the app, and the download includes a 14-day trial, so it does not need to reach F7 to run.

### What operating systems are supported?
macOS 13 or later (Apple Silicon and Intel) and Windows x64.

### How do updates work?
Only the download updates itself, through a signed manifest verified before it is parsed and a release asset whose checksum is verified before it is applied. Server builds never self-update.

### Where are hosted instances run?
On Railway infrastructure in the United States. F7 does not currently operate instances outside the United States.

---

## Contact

| Topic | Contact |
|---|---|
| Security inquiries and questionnaires | security@fseven.ai |
| Privacy questions and requests | privacy@fseven.ai |
| Legal and compliance | legal@fseven.ai |
| General questions | hello@fseven.ai |
