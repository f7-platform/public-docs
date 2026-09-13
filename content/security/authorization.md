# Accounts and Access

How people sign in to Atlas, what protects the account, and how access to project data is decided.

## Signing in

| Method | How it works |
|---|---|
| **Email and password** | The password is hashed with Argon2id and never stored in readable form. Repeated failed attempts lock the account, and the lockout is durable. |
| **Single sign-on** | OAuth 2.0 / OpenID Connect sign-in with an identity provider the operator configures. The provider's client secret lives in the same encrypted store as provider API keys. |
| **Second factor** | Time-based one-time codes, with the secret stored encrypted, and passkeys (WebAuthn). Single-use recovery codes are stored as hashes. |
| **Invitations** | Membership on an instance and its projects is granted by invitation, and the invitation is recorded against the account. |
| **Provisioning** | An identity provider can push user lifecycle into the instance over inbound SCIM 2.0: create on hire, profile updates, and deactivation on offboarding. |

Password-reset and verification links expire. Sessions expire and can be revoked, and deactivating an account revokes its sessions.

## Who can do what

Access to project data is checked on every request and denied by default.

| Level | What it can do |
|---|---|
| **Project reader** | See the project. |
| **Project writer** | Add and change content, and stop an autonomous run. |
| **Project administrator** | Manage membership and arm autonomous runs. |
| **Instance owner or administrator** | Everything on the instance, including its audit records. On the download that is your organisation; on an instance F7 operates it is F7 for support, maintenance and security only. |

Roles are membership rows resolved against a policy decision point with a fail-closed fallback, and a membership ceiling can lower a role but never raise one.

## What is recorded

Every authentication lifecycle transition is written to a structured auth event log: sign-in success and failure, lockout, sign-out, second-factor enrolment, verification and removal, passkey registration and use, password and email changes, single sign-on admissions and denials, and administrative account actions. The log never blocks authentication: a failure to write it is logged as a warning and never becomes a sign-in outage.

Separately, significant product events — who authorised, reviewed, approved or voted on something — go to the append-only signed ledger described in [Deployment and Trust Architecture](/security/architecture#the-signed-record).

## Acceptances and consent

- Your acceptance of the terms is recorded against a specific version, so a material change asks you again.
- Consent to voice input is asked for at the point you turn it on, not implied by your plan.
- Consent to the Rewind feedback recorder is recorded against a deployment and can be withdrawn; it is never implied by a plan, a licence tier or general acceptance of the terms. See [Data Atlas Holds (Details)](/privacy/data-collection#atlas-rewind).

---

::: info Related
- [Deployment and Trust Architecture](/security/architecture) — the instance boundary and the signed record
- [Your Controls](/privacy/your-controls) — what you can change, revoke and export
:::
