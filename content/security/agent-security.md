# Agent Security

The F7 agent runs on employee devices and is the first point of contact with work activity data. Its security design ensures that sensitive data is protected before, during, and after observation.

## Zero-Trust Enrollment

The agent does not ship with any pre-configured credentials. Instead, it goes through a **one-time cryptographic enrollment** process:

1. An administrator creates a time-limited enrollment token with a maximum number of uses.
2. The agent presents this token to the F7 Controller during first-run setup.
3. The controller verifies the token and issues a unique device identity (Ed25519 key pair).
4. The agent stores the device credentials in the OS-native secure credential store (Keychain, Credential Manager, or Secret Service).
5. The enrollment token's use count is decremented. Once exhausted or expired, it cannot be reused.

After enrollment, the agent authenticates every request with a signed JWT — there are no shared secrets between devices.

## What Happens on the Device

```
Raw observation → Privacy filter → Local AI model → Encrypted local store → Sync
```

1. **Raw observation**: The agent observes app names, activity counts, and timing.
2. **Privacy filter**: PII is stripped. Content (keystrokes, prompts, file data) is never captured.
3. **Local AI model**: A purpose-built on-device AI model classifies sessions and scores AI interaction depth. No data leaves the device for this step.
4. **Encrypted local store**: Classified metadata is stored in an AES-256 encrypted database (SQLCipher).
5. **Sync**: Only structured, classified metadata is transmitted to the controller over TLS 1.3.

## What the Agent Does Not Do

| Capability | Status |
|-----------|--------|
| Read file contents | **No** — only file metadata (name, type) for recently-saved files |
| Record keystrokes | **No** — only aggregate keystroke counts |
| Capture screenshots | **No** — the optional vision model processes frames locally and discards them immediately |
| Access clipboard | **No** — never under any circumstances |
| Read email or chat content | **No** — only time-in-app and domain |
| Access passwords or credentials | **No** — the agent never reads credential stores |
| Record browsing URLs | **No** — only the active domain, never the full URL |
| Monitor excluded apps | **No** — apps on the exclusion list generate zero telemetry |

## Employee Controls

Every employee has direct control over the agent:

| Control | How It Works |
|---------|-------------|
| **Pause observation** | Click the system tray icon to pause — no data is captured while paused |
| **Exclude apps** | Add apps to a blocklist — excluded apps generate zero telemetry |
| **Work hours only** | Configure observation to run only during defined work hours |
| **Personal dashboard** | Opt-in to see exactly what data has been captured about your work patterns |

## Credential Protection

Agent credentials are stored in the operating system's native secure credential store:

- **macOS**: Keychain Services
- **Windows**: Credential Manager
- **Linux**: Secret Service API (libsecret)

Credentials are never written to disk as plaintext files, logged, or included in error reports.

## Update & Integrity

- The agent binary is signed to verify integrity before execution.
- Configuration updates from the controller are authenticated using the agent's device credentials.
- The agent validates the controller's TLS certificate on every connection with SPKI (Subject Public Key Info) certificate pinning, ensuring connections are only established with the expected server.

---

::: info Designed for Trust
The F7 agent processes data locally first. By the time any data reaches the server, it's already structured metadata — no content, no PII. Employees have full visibility into what's captured and direct controls to limit data collection.
:::
