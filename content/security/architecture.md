# Deployment and Trust Architecture

Atlas has one trust boundary that matters: the instance. This page says where the instance runs, who administers it, what it talks to, and how its record is made tamper-evident.

## Single tenant

Every Atlas deployment is one instance with one database and one signed ledger, for one customer. Your data is not pooled with another customer's, and no shared multi-tenant store exists to pool it in. The isolation between customers is the absence of a shared system, not a row filter inside one.

## The download

- The web application is compiled into a single binary that starts and supervises its own private PostgreSQL. Nothing else is installed.
- It runs on the machine you put it on and serves your browser there. No one at F7 has access to it, a copy of its data, or the ability to read, export or delete anything in it.
- Licences verify offline against keys compiled into the app, and the download includes a 14-day trial, so the instance can run on a machine with no route to F7.
- On plans where F7 supplies AI capacity, the instance opens a session with F7's credit gateway using a key it mints for itself and keeps in its secret store, and metered AI requests pass through that gateway to the provider. A bring-your-own-key instance mints no such key and opens no such session.

## An instance F7 operates

- F7 hosts and administers the deployment on Railway infrastructure in the United States, and you sign in over HTTPS.
- F7 staff can access the systems holding your data for support, maintenance and security, and F7 commits to accessing it only for those purposes.
- Hosted instances upgrade by image pin; they never reach for a release asset and never self-update.

## Who administers what

| | The download | An instance F7 operates |
|---|---|---|
| Runs the machine | You | F7 |
| Holds the database | You | F7 |
| Holds the instance master key | You | F7 |
| Can read your data for support | No one at F7 | F7 staff, for support, maintenance and security only |
| Chooses the AI provider | You | You, within your plan |
| Where the data is | Wherever you run it | The region in your order or deployment agreement; United States today |

## The signed record

- **Signed envelopes.** Every artifact Atlas records is wrapped in an envelope carrying the payload, a hash of it, the signer's key fingerprint, a per-signer sequence number, and an Ed25519 signature. The verification path is enforced at the type level in the code: an envelope from untrusted bytes yields its payload only by verifying.
- **Two ledgers.** An append-only per-tenant event ledger and a governance chain each fold a running head hash, so tampering is detectable. The signed ledger append lands before the database write, so a crash leaves the ledger ahead of the database, never the reverse.
- **Privilege, not policy.** The database role the application runs as may read and append to the ledger tables and nothing else. There is no deletion to perform on those tables, even with full administrative access to the instance.
- **Portable verification.** The export archive contains the ledger, your relational data, and the public keys needed to verify the signatures independently. It deliberately excludes the instance's credentials and secrets.
- **Revocation as history.** Revoking a signing key appends a signed event to the ledger; from that position onward the key no longer verifies content, while everything it signed earlier stays valid.

What this does and does not prove: a signature proves that specific content was signed by a specific key and has not changed since. It does not prove the content is true, that the signer had authority, or that the key belongs to who you think it does — those depend on how your organisation manages its keys and approvals.

## Key custody

F7 ships no hardware security module integration and operates no key-management service. What exists:

- The instance's own signing key is held in the instance's secret store (AES-256-GCM file store, or the operating system keychain on macOS).
- An operator can point Atlas at a key module they provide — a PKCS#11 module, an ssh-agent, or Google Cloud KMS. The security then rests on that module and its policies, which F7 neither provisions nor attests.
- Signing from the browser uses a non-extractable key held by the browser, which the page can use and never read.

**Not built:** hardware custody, high availability and disaster recovery for the ledger, and service-level commitments for revocation. None of these should be answered as current controls on a vendor questionnaire.

---

::: tip For security reviewers
The property to test is not "is there a permission check" but "is there a second tenant to leak to". There is not: the boundary is the instance, and the instance is yours.
:::
