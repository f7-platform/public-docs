# Data Retention and Deletion

How long each kind of data is kept, what deletes automatically, and the one limit this page states plainly rather than buries.

## Retention by data type

| Data | Kept |
|---|---|
| Account details, project content, memberships | Until you correct or delete them, or close the account |
| Conversation history on each item | With the project it belongs to |
| The signed ledger | For the life of the instance. Append-only: entries are never edited or removed individually |
| Usage metering (per-request model, tokens, cost, outcome) | 90 days, then deleted automatically |
| Password-reset and verification links | Until they expire |
| Sessions | Until they expire or are revoked |
| Sign-in and administrative event records | With the instance |
| A Rewind capture the reviewer has not submitted | On the instance, until it is deleted there |
| A submitted Rewind capture | Not yet set. Submission is not built; the retention period was left to legal review rather than fixed internally, and it will be stated here before submission is offered |

On the download, all of this is on a machine you control, and you decide what happens to it. On an instance F7 operates, retention after closure is governed by your agreement, and you can export everything before deletion.

## The ledger limit

The ledger is append-only and cannot be selectively edited. This is the mechanism that makes Atlas's records provable: each entry is chained by hash to the one before it, so removing or rewriting an entry breaks the chain and destroys the proof for every entry after it. The instance's own database permissions match that design: the ledger tables allow reading and appending and nothing else.

Some personal data is written into the ledger deliberately. A record of who authored, reviewed, approved or voted on something is the substance of the proof, so a ledger entry can contain a pseudonymous identifier for the person who acted, derived from their account and resolvable to a name only by an authorised reader of that instance, together with the fingerprint of the signing key they used. It does not contain a name or an email address. It can also contain content you authored where that content is the thing being recorded.

Where that has happened, the surrounding account and content can be deleted, and the ledger can be destroyed in its entirety, but one entry cannot be excised while the rest stays verifiable.

## Export before you delete

Atlas produces a single archive containing the signed ledger, your relational data, and the public keys needed to verify the signatures independently. It excludes the instance's credentials and secrets. Export is available at any time and is the recommended first step before closing an account or retiring an instance.

---

::: info Related
- [Your Controls](/privacy/your-controls) — everything you can export, change and revoke
- [Data Atlas Holds (Details)](/privacy/data-collection) — the field-level inventory
:::
