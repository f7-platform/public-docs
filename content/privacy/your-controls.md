# Your Controls

What you can export, change, revoke and refuse in Atlas, and what each control actually does.

| Control | What it does |
|---|---|
| **Export everything** | Atlas produces a single archive containing the signed ledger, your relational data, and the public keys needed to verify the signatures independently. The archive deliberately excludes the instance's credentials and secrets. Available at any time; on the download, entirely under your control. |
| **Correct or delete ordinary records** | Account details, project content and memberships can be corrected or deleted. |
| **The ledger** | Append-only by design. It can be destroyed in its entirety, never edited entry by entry. See [the ledger limit](/privacy/data-retention#the-ledger-limit). |
| **Choose the AI provider** | The provider and model are a configuration choice, including self-hosted and open-source endpoints. On plans where you supply your own key, requests go to your own account with that provider. |
| **Scope your own key** | On an instance F7 operates, your key is encrypted under that instance's master key, which F7 holds to run the instance — so F7's promise not to read it is a commitment, not an impossibility. Issue Atlas a key that is scoped and spend-limited on your provider account and the promise stops mattering. |
| **Voice** | Off unless configured. Turning it on asks for your consent first. While on, a recording of your speech is uploaded to a third-party speech provider to be transcribed. Turn it off and nothing further is sent. |
| **Rewind** | Absent from customer deployments today. Where it is offered, consent is recorded for your deployment and can be withdrawn, which turns the recorder off. It is never implied by a plan, a licence tier or general acceptance of the terms. See [Atlas Rewind](/privacy/data-collection#atlas-rewind). |
| **Web-fetch fallback** | When a page cannot be read directly, Atlas falls back to a third-party rendering service that then sees the address. An operator can disable the fallback. |
| **Connected repositories** | Only connected if you connect them, with credentials you provide. |
| **Sessions and second factors** | Sessions can be revoked. Time-based one-time codes and passkeys can be enrolled and removed, with single-use recovery codes. |
| **Error reports** | Built and stored in your browser; sent to F7 only when you choose to send one. |

## Exercising your rights

Depending on where you live you may have rights to access, correct, delete, export or object to the processing of your data. You already hold the access and export rights technically: they are product features, not requests. For the others, contact **privacy@fseven.ai**. On the download, direct these requests to whoever operates your instance, because F7 has no access to it.

F7 does not sell your personal information.

---

::: info Related
- [Data Retention and Deletion](/privacy/data-retention) — how long each thing is kept, and the ledger limit
- [Accounts and Access](/security/authorization) — sign-in, second factors and the auth event log
:::
