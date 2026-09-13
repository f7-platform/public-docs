# What Atlas Holds

This page is the short version of the data inventory. [Data Atlas Holds (Details)](/privacy/data-collection) lists every field, and [How Atlas Runs](/overview/how-it-works#what-leaves-the-instance) has the complete list of what leaves the instance.

## What the instance holds about you

| Category | What it is |
|---|---|
| **Account and sign-in** | Your email address, an optional display name, a hash of your password (Atlas does not store the password), your role, whether your email is verified, whether you have enrolled a second factor, hashes of your unused recovery codes, and any passkeys you register. Sign-in attempts are recorded. |
| **Acceptances and permissions** | A record that you accepted a given version of the terms, with a timestamp; your membership and role on each project; invitations issued to you. |
| **What you create** | Everything you author or upload: interviews and their transcripts, process maps, decisions, narrative text, schemas, and any source documents you add or ask Atlas to fetch. Atlas does not limit what you type, so this content contains whatever you put in it. |
| **The signed ledger** | Significant events are written to an append-only, hash-chained ledger: who authorised, reviewed, approved or voted on something, and the content being recorded when that content is the point of the entry. See [the ledger limit](/privacy/data-retention#the-ledger-limit). |
| **Usage metering** | Per-request model, token counts, cost and outcome, kept for 90 days. These records identify the feature, not the person. |

## What Atlas does not collect

Atlas contains no analytics, no tracking, and no automatic crash or error reporting. When something goes wrong, the report is built and stored in your browser and is sent to F7 only if you choose to send it. Nothing is transmitted in the background.

## What leaves the instance

Only the requests you make to the AI provider your instance is configured with, the optional services you turn on (voice, connected repositories), the sources you ask Atlas to fetch, email, and the licence and update checks that keep the download running. The full table, with what each one receives and when, is in [How Atlas Runs](/overview/how-it-works#what-leaves-the-instance).

## Who can see your data

**Within your instance,** other users see what your project permissions allow. An owner or administrator of the instance can see the instance's data, including audit records. On the download, that administrator is your organisation, not F7.

**On an instance F7 operates,** F7 staff can access the systems holding your data for support, maintenance and security, and F7 commits to accessing it only for those purposes.

**Your AI provider key.** Where you supply your own key, Atlas uses it to make the requests you ask for and for nothing else. Be clear about what that is on a hosted instance: a **commitment**, not something the architecture makes impossible. Your key is encrypted at rest under that instance's master key, which F7 holds in order to run the instance at all, so F7 is technically able to decrypt it and is telling you it does not. If you would rather not rely on a promise, issue Atlas a key that is scoped and spend-limited on your provider account, which bounds what any access could do regardless of F7.

F7 does not sell your data, does not share it for advertising, and discloses it to others only where legally compelled — and will tell you unless prohibited from doing so.

---

::: info Rewind
Atlas contains a feedback recorder called Rewind, which captures pictures of a reviewer's own screen when that reviewer turns it on. It is described in full, including what is and is not built, in [Data Atlas Holds (Details)](/privacy/data-collection#atlas-rewind).
:::
