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

- **macOS**: Keychain Services — requires the agent binary to be code-signed with an Apple Developer ID certificate for silent access. In enterprise (MDM) deployments, a PPPC configuration profile pre-authorizes Keychain access so no password prompts appear, even on first enrollment.
- **Windows**: Credential Manager
- **Linux**: Secret Service API (libsecret)

Credentials are never written to disk as plaintext files, logged, or included in error reports.

## Update & Integrity

The agent updates itself through a secure, controller-managed pipeline. Updates are never pulled from public repositories — every binary is verified cryptographically before execution.

### How Updates Work

```
Controller publishes update → Agent checks eligibility → Download → Verify → Swap → Restart
```

1. **Controller-driven distribution.** The F7 Controller includes update instructions in its periodic configuration response. This means administrators control exactly when and how updates roll out — there is no autonomous update behavior.
2. **Download.** The agent downloads the new binary from the URL specified by the controller.
3. **SHA-256 hash verification.** The downloaded binary is compared against the expected hash digest. Any mismatch aborts the update immediately.
4. **Ed25519 signature verification.** The binary's integrity is verified against an Ed25519 digital signature using a public key compiled into the agent at build time. This ensures the binary was produced by F7 and has not been tampered with. Signing keys are managed in the controller's model signing infrastructure.
5. **Atomic A/B swap.** The current binary is moved to a rollback slot, and the verified new binary takes its place. This is an atomic file operation — the agent is never in a partially-updated state.
6. **Supervised restart.** The agent exits with a well-known code, and the process supervisor restarts it with the new binary.

### Rollback Protection

If the new binary crashes repeatedly within five minutes of an update, the agent automatically restores the previous version from the rollback slot. Failed updates are reported to the controller for administrator visibility.

### Administrator Controls

| Control | Description |
|---------|-------------|
| **Gradual rollout** | Updates can target a percentage of devices (1–100%) using deterministic device hashing — no random selection |
| **Update windows** | Restrict updates to specific hours (e.g., overnight) to avoid disrupting work |
| **Version pinning** | Lock specific devices or groups to a maximum version, preventing updates beyond that release |
| **Update channels** | Choose between stable, beta, or nightly update tracks per organization |
| **Pause rollout** | Set rollout percentage to 0% to immediately halt an in-progress rollout |

### Configuration Authentication

Configuration updates from the controller are authenticated using the agent's device credentials. The agent validates the controller's TLS certificate on every connection using the OS trust store and webpki root certificates. Optional SPKI certificate pinning is available as an additional hardening measure for deployments that require it. No unsigned or unauthenticated configuration is ever applied.

---

::: info Designed for Trust
The F7 agent processes data locally first. By the time any data reaches the server, it's already structured metadata — no content, no PII. Employees have full visibility into what's captured and direct controls to limit data collection.
:::
