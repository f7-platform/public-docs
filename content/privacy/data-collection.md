# Data Atlas Holds (Details)

The field-level inventory of what an Atlas instance holds, what it does not collect, and the one feature that captures a screen. For what leaves the instance and when, see [How Atlas Runs](/overview/how-it-works#what-leaves-the-instance).

## Account and sign-in

| Field | Notes |
|---|---|
| Email address | How account recovery works; must be kept current |
| Display name | Optional |
| Password hash | Argon2id. The password itself is not stored |
| Role | Your role on the instance |
| Email verification state | Whether the address has been verified |
| Second-factor enrolment | Whether a second factor is enrolled. The one-time-code secret is stored encrypted |
| Recovery codes | Stored as hashes of the unused codes only |
| Passkeys | Any passkeys you register |
| Sign-in attempts | Recorded, with lockouts, second-factor and passkey changes, and administrative account actions |

## Acceptances and permissions

- A record that you accepted a given version of the terms, with a timestamp.
- Your membership and role on each project.
- Invitations issued to you.

## What you create

Everything you author or upload in Atlas: interviews and their transcripts, process maps, decisions, narrative text, schemas, and any source documents you add or ask Atlas to fetch. Each item's conversation thread is kept server-side, so a judgment call is durable rather than scrolling away.

Atlas does not limit what you type, so this content contains whatever you put in it, including personal information about other people if you enter it.

## The signed ledger

Atlas's purpose is to make its record provable, so significant events are written to an append-only, hash-chained ledger: who authorised, reviewed, approved or voted on something, and the content being recorded when that content is the point of the entry.

Some personal data is written into the ledger deliberately. A record of who authored, reviewed, approved or voted on something is the substance of the proof, not incidental metadata attached to it. A ledger entry can therefore contain a pseudonymous identifier for the person who took an action — derived from their account and resolvable to a name only by an authorised reader of that instance — together with the fingerprint of the signing key they used. It does not contain their name or email address. It can also contain content you authored where that content is the thing being recorded. The consequence for deletion is stated in [Data Retention and Deletion](/privacy/data-retention#the-ledger-limit).

## Usage metering

Per-request model, token counts, cost and outcome, retained for 90 days and then deleted automatically. These records are not linked to an individual user: they identify the feature, not the person.

## Error reports

When something goes wrong, the report is built and stored in your browser. It is sent to F7 only if you choose to send it. Nothing is transmitted in the background.

## What Atlas does not collect

- No analytics and no tracking, in the product or in this Trust Center.
- No automatic crash or error reporting.
- No screen capture, except Rewind, below, which a reviewer turns on for their own screen.
- No audio, except a voice recording sent for transcription when voice input is configured and consented to. Rewind records no audio.
- No data from anyone's device other than the machine that runs the instance. Atlas installs no agent and observes no one.

## Atlas Rewind

Atlas contains a feedback recorder called Rewind. A reviewer turns it on, it holds the last few seconds of the screen as it goes, and when something looks wrong the reviewer presses a button *after* it happened to keep the seconds that have just passed. It is off until a reviewer turns it on, and it is not present at all on a deployment that has not been granted it.

**What is captured.** Picture-only snapshots, eight a second, of the browser tab or the screen the reviewer chooses in the browser's own share prompt, together with the words the reviewer writes to describe what they saw and the marks they draw on top of the frames. Whatever is on the screen they share is in those pictures, including personal information about other people if it is on the screen at the time.

**No audio is recorded.** Rewind captures pictures and nothing else. The description field accepts dictation, and dictation behaves as voice input does everywhere in Atlas: if voice is configured and consented to, the recording of that spoken sentence goes to the speech provider to be turned into text. That is the reviewer dictating a description, not Rewind recording the capture's sound.

**A capture stays on the instance until the reviewer submits it, with one exception.** The frames, the marks and the words are held by the instance that recorded them; capturing sends nothing anywhere. The exception is the first read: if the reviewer asks for one, the selected frames and the reviewer's words are sent to the AI provider the instance is configured with so it can describe what the pictures show, and the reviewer is asked for that permission separately for each capture.

**Sending a capture to F7 is planned and is not built.** Today Rewind has no way to send a capture to F7 by itself; a capture that becomes a report becomes one because a person at F7 converted it by hand. When submission is built, a submission will carry the keyframes the reviewer selected with their marks drawn into the image, the reviewer's words, the model's first read where one was asked for, a stamp of where in the product the capture was taken, the capture's own identifier, and the fingerprint of the instance's key — whether or not it carries frames. It will leave behind every frame the reviewer did not select, every other capture, everything from the work you have authored in Atlas, and any identifier for your account beyond the licence binding. This is written down before it exists because it must be agreed before it is offered, and it must not be answered as a current control on a vendor questionnaire.

**Who can read a capture today.** The person who recorded it. Rewind appears only on F7's own development servers and internal reference builds, and a capture becomes readable by anyone else only when a person at F7 converts it by hand into an entry in F7's own issue tracker. Who at F7 may open a submitted capture is settled as part of building the submission path, and this site will say so before submission is offered to any customer.

**How long a capture is kept.** A capture the reviewer has not submitted stays on the instance until it is deleted there. The retention of a submitted capture is deliberately not yet set: it was left to legal review rather than fixed internally, and it will be stated before submission is offered.

**Consent, and when you will see it.** Consent to Rewind is recorded for your deployment and can be withdrawn, which turns the recorder off. Rewind is not shown to a customer today. Before it is offered on a deployment F7 hosts, that deployment has to be granted it, and it is granted only where consent has been asked for and given. It is never offered on an air-gapped deployment.

---

::: info Related
- [What Atlas Holds](/overview/data-we-collect) — the short version
- [Your Controls](/privacy/your-controls) — export, deletion, keys, voice and consent
:::
