# Privacy Principles

Atlas holds the record of how your business runs. These are the principles that govern what happens to it, each stated with what is built behind it.

## 1. One instance, your data

Every Atlas deployment is one instance with one database and one signed ledger, for one customer. On the download, no one at F7 can read, export or delete anything in it. On an instance F7 operates, F7 staff can access the systems holding your data for support, maintenance and security, and F7 commits to accessing it only for those purposes.

## 2. Nothing leaves without a published reason

Atlas contacts outside services only for the purposes listed in [How Atlas Runs](/overview/how-it-works#what-leaves-the-instance): the AI provider you configure, optional voice, sources you ask it to fetch, connected repositories, email, licensing and updates. That list is complete. Several of those services are inactive until you configure them.

## 3. No analytics, no tracking, no background reporting

Atlas contains no analytics, no tracking, and no automatic crash or error reporting. When something goes wrong, the report is built and stored in your browser and is sent to F7 only if you choose to send it.

## 4. The AI provider is your choice

The model provider is a configuration value. On plans where you supply your own key, requests go to your own account with that provider under your agreement with them, not F7's. Atlas uses your key to make the requests you ask for and for nothing else.

## 5. Voice is off until you turn it on

Voice input is off unless configured, and enabling it requires your explicit consent at the point you turn it on. When it is on, a recording of your speech is uploaded to a third-party speech provider to be transcribed.

## 6. The one screen recorder is consent-gated, and absent today

Atlas contains a feedback recorder called Rewind. It captures pictures of a reviewer's own screen, only after that reviewer turns it on, and records no audio. It is not present on any customer deployment today, and before it is offered on a deployment F7 hosts, that deployment has to be granted it, which happens only where consent has been asked for and given. Sending a capture to F7 is planned and not built. The full description, including what is and is not built, is in [Data Atlas Holds (Details)](/privacy/data-collection#atlas-rewind).

## 7. Everything is exportable, and one thing cannot be selectively deleted

You can export everything at any time: a single archive with the signed ledger, your relational data, and the public keys needed to verify the signatures independently. Ordinary records can be corrected or deleted. The ledger is append-only by design: it can be destroyed in its entirety, never edited entry by entry. [Data Retention and Deletion](/privacy/data-retention) states the limit in full.

## 8. No sale, no advertising, disclosure only when compelled

F7 does not sell your data and does not share it for advertising. F7 discloses data to others only where legally compelled, and will tell you unless prohibited from doing so.

## 9. Atlas does not limit what you type

Everything you author or upload is held by the instance, and that content contains whatever you put in it, including personal information about other people if you enter it. Atlas treats it as yours; the responsibility for having the right to put it there is yours too.

---

::: info Related pages
- [Data Atlas Holds (Details)](/privacy/data-collection) — the field-level inventory, and Rewind in full
- [Your Controls](/privacy/your-controls) — export, delete, keys, voice and consent
- [Data Retention and Deletion](/privacy/data-retention) — how long each thing is kept
:::
