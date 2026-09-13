# Encryption and Signing

Atlas uses current-generation cryptography for three jobs: protecting secrets at rest, protecting the connection to a hosted instance, and making the record tamper-evident. This page is the inventory, followed by the honest boundary on key custody.

## Cryptographic inventory

| Purpose | Algorithm |
|---|---|
| Signatures on every recorded artifact and ledger entry | Ed25519 |
| Ledger integrity | A hash chain: each entry folds into a running head hash, so removing or rewriting an entry breaks the chain for every entry after it |
| Password hashing | Argon2id, with a unique salt per password |
| Secrets at rest (provider keys, sign-on client secrets, second-factor secrets, the instance's own keys) | AES-256-GCM file-backed store, or the operating system keychain on macOS |
| Recovery codes | Stored as SHA-256 hashes, single-use |
| Connection to a hosted instance | TLS (HTTPS) |
| Release integrity | SHA-256 checksums on every asset; Apple notarization on macOS; Authenticode signing on Windows; an Ed25519-signed update manifest verified against a key compiled into the app |

## In transit

An instance F7 operates is served over HTTPS. The download runs on your own machine and serves your browser locally, on that machine.

Requests to outside services — the AI provider, the speech provider, sources you fetch, your mail provider — go over HTTPS to those services under their terms.

## At rest

- **Secrets are encrypted.** Provider API keys, single sign-on client secrets and second-factor secrets are held in an AES-256-GCM encrypted store beside the ledger (or in the macOS keychain), and the master key that decrypts them is kept apart from the encrypted files. They are resolved from that store on every request and never live in the configuration file.
- **Passwords are never stored** — only their Argon2id hashes.
- **The database files are not encrypted by Atlas.** On the download, protect the machine with your operating system's disk encryption. On an instance F7 operates, ask F7 about the hosting platform's storage before relying on volume encryption; this page does not claim it.

## Signing and the ledger

Every artifact Atlas records is wrapped in a signed envelope carrying the payload, a hash of it, the signing key's fingerprint, a per-signer sequence number and an Ed25519 signature. Significant events go to an append-only, hash-chained ledger whose database privileges allow reading and appending only.

You can verify all of it without F7: the export archive contains the ledger, your relational data and the public keys needed to check the signatures independently. Verifying a record against a trust store proves integrity, not authority — a signature proves what was signed and by which key, not that the content is true or that the signer was entitled to sign it.

## Key custody

Stated plainly, because a security questionnaire will ask:

- **F7 ships no hardware security module integration and operates no key-management service.**
- The instance's signing key is held in the instance's own encrypted secret store.
- An operator can hold keys in a module they provide — a PKCS#11 module, an ssh-agent, or Google Cloud KMS. Atlas speaks to whatever module it is pointed at; the security then rests on that module's policies, which F7 neither provisions nor attests. A PKCS#11 module can as easily be a software token with the key in a file.
- Signing from the browser uses a non-extractable key held by the browser, which the page can use and never read.
- Not built: hardware custody, high availability and disaster recovery for the ledger, and service-level commitments for revocation.

---

::: info No legacy cryptography
Atlas does not use MD5, SHA-1, 3DES, RC4 or RSA-PKCS1v15 for any of the purposes above.
:::
