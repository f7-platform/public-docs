# How Atlas Runs

Atlas is traditional software that runs inside your boundary. The instance holds your data; a short, published list of outside services is contacted only for the purposes below, and several of them are inactive until you configure them.

## Two ways to run it

### The download

- **One download is the whole product.** The web application is compiled into the binary and it starts its own private PostgreSQL. Nothing else has to be installed.
- **It runs where you put it** — a laptop, a workstation, or a server you manage — and opens in your browser.
- **It does not need to reach F7 to run.** A licence you paste in verifies offline against keys compiled into the app, and the download includes a 14-day trial that needs no connection. The application can therefore run on a machine with no route to F7 at all.
- **Only the download updates itself,** and only through a signed manifest. See [Downloads and Updates](/security/downloads).

### An instance F7 operates

- F7 hosts and administers the deployment and you sign in over the web.
- F7 staff have administrative access to the systems holding your data, for support, maintenance and security. On the download, no one at F7 has access to anything. See [Who can see your data](/overview/data-we-collect#who-can-see-your-data).
- Hosted instances run on Railway infrastructure in the United States.

Both are **single-tenant**: one deployment, one database, one signed ledger per customer.

## What leaves the instance

Atlas contacts outside services only for the purposes below. This is the complete list.

| Purpose | Where it goes | When |
|---|---|---|
| **AI features** | The model provider your instance is configured with. The default provider is Anthropic; the provider and model are configurable, and self-hosted and open-source endpoints are supported. On plans where you supply your own key, the request goes to your own account with that provider under your agreement with them. On plans where F7 supplies AI capacity, the request passes through F7's gateway to the provider and is metered there. | When you use an AI feature. The text needed for that request — your answers, the parts of your project the request draws on, and the instructions Atlas builds around them — is what is sent. |
| **Voice** | A third-party speech provider (ElevenLabs). A recording of your speech is uploaded to be transcribed, and text may be sent to the same provider to be spoken aloud. | Only if voice is configured, and only after you give explicit consent at the point you turn it on. |
| **Sources you ask for** | The address you named, so that site sees the request. Public regulatory sources (eCFR, the Federal Register, GovInfo, municipal code sites) are contacted when Atlas checks a standard for changes. If a page cannot be read directly, Atlas falls back by default to a third-party rendering service (`r.jina.ai`), which then receives the address being fetched. An operator can disable this fallback. | When you add a source by URL or Atlas checks a standard for changes. |
| **Connected code repositories** | Your git host, using credentials you provide. | Only if you connect a repository. |
| **Email** | The mail provider your instance is configured with. | Verification, password reset and invitations. |
| **Licensing and account** | fseven.ai, when you connect your account from inside the app to install a licence. On plans where F7 supplies AI capacity, F7's credit gateway, over a session the instance opens with its own key. A bring-your-own-key instance opens no such session. | On connect; per metered turn on credit plans. |
| **Updates** | The public release repository, for the signed update manifest and the release asset. Server builds never self-update. | Periodically, on the download only. |

Atlas contains no analytics, no tracking, and no automatic crash or error reporting. When something goes wrong, the report is built and stored in your browser and is sent to F7 only if you choose to send it.

## What stays

Everything else stays on the instance: your account, the work you create, the conversation history, the signed ledger, and the usage metering that records what each AI request cost. [What Atlas Holds](/overview/data-we-collect) lists it in detail.

## The AI seam

The model is a pluggable seam, not a hard-wired route. Each feature can name its own provider, credentials never live in the configuration file, and spending passes through one budgeted chokepoint that records the cost of every turn. The guardrails do not vary with the choice of provider: the model never signs, claims are expected to cite a source, and fetched material enters unverified.

## Rewind

Atlas contains a feedback recorder called Rewind. It is off until a reviewer turns it on, it captures pictures of that reviewer's own screen and nothing else, and it is not present at all on a deployment that has not been granted it, which today is every customer deployment. It is described in full in [Data Atlas Holds](/privacy/data-collection#atlas-rewind).

---

::: info Key takeaway
Atlas holds your data in one instance that is yours. The only things that leave are the requests you make to a model provider you chose, the optional services you turned on, and the licence and update checks that keep the download running.
:::
