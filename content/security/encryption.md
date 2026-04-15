# Encryption

F7 uses modern, industry-standard cryptographic algorithms throughout the platform. No legacy algorithms (MD5, SHA-1, 3DES, RSA-PKCS1v15) are used anywhere.

## Cryptographic Inventory

| Purpose | Algorithm | Standard |
|---------|-----------|----------|
| Data in transit | TLS 1.3 | IETF RFC 8446 |
| Digital signatures (agent auth) | Ed25519 | IETF RFC 8032 |
| Encryption at rest (server) | AES-256-GCM | NIST SP 800-38D |
| Encryption at rest (agent) | AES-256-CBC + HMAC (SQLCipher) | NIST SP 800-38A |
| Password hashing | Argon2id | IETF RFC 9106 |
| Integrity verification | HMAC-SHA256 | IETF RFC 2104 |
| Key derivation | HKDF-SHA256 | IETF RFC 5869 |

## Encryption in Transit

All data moving between any F7 component is encrypted with **TLS 1.3** — the most current version of the Transport Layer Security protocol.

- HSTS headers enforce HTTPS on all connections.
- Certificate pinning infrastructure is compiled into the agent; operational pins are applied per-deployment to prevent man-in-the-middle attacks.
- Data is serialized using Protocol Buffers and transmitted over HTTPS — never in plaintext.

## Encryption at Rest

### Server Side

Integration credentials (API keys for connected services like identity providers and HR systems) are encrypted with **AES-256-GCM** before being stored in the database.

- Encryption uses a versioned ciphertext format to support algorithm migration without downtime.
- Keys are managed through environment-scoped secrets, not hardcoded.
- Key rotation is supported.

### Agent Side

The agent stores observation data locally in an encrypted database using **SQLCipher** (AES-256-CBC with HMAC integrity verification).

- The database encryption key is derived from device-specific material.
- Even if the agent's data files are copied, they cannot be read without the encryption key.

### Credential Storage

Device credentials (enrollment keys, refresh tokens) are stored in the operating system's native secure storage:

| Platform | Storage |
|----------|---------|
| macOS | Keychain |
| Windows | Credential Manager |
| Linux | Secret Service (libsecret) |

Credentials are never stored in plaintext files, environment variables, or application configuration.

::: info macOS Keychain & Code Signing
On macOS, seamless Keychain access requires the agent binary to be code-signed with an Apple Developer ID certificate. The Keychain records the code signing identity when credentials are first stored, and silently grants access to the same signed binary on subsequent launches. In enterprise deployments, an MDM-deployed PPPC configuration profile pre-authorizes Keychain access so that even the initial enrollment is fully silent — no password prompts appear.
:::

## Password Security

Admin passwords are hashed with **Argon2id** — the winner of the Password Hashing Competition and the current OWASP recommendation.

- Each password has a unique, randomly generated salt.
- The algorithm is resistant to GPU and ASIC-based brute-force attacks.
- Passwords are never stored in a reversible format.

## Key Management

- Server encryption keys are deployed through environment-scoped secrets (not checked into source code).
- Agent keys are stored in the OS-native credential store.
- Key rotation is supported for both server-side encryption and agent JWT signing.
- There is a versioned ciphertext format (`v1:`) that allows seamless migration to new algorithms in the future.

---

::: info No Legacy Crypto
F7 does not use MD5, SHA-1, 3DES, RC4, RSA-PKCS1v15, or any other deprecated algorithm. All cryptographic operations use current-generation NIST or IETF-recommended standards.
:::
