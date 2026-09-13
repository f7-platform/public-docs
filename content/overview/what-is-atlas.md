# What Is Atlas?

Atlas, by F7, captures how work actually gets done — through interviews, process maps, decisions, and the standards a business has to satisfy — and records the result so it can be verified later. It signs what it records and keeps an append-only ledger of significant events, so the record of who authored, reviewed, approved or decided something is evidence rather than a note.

## What you get

| | |
|---|---|
| **The download** | One signed installer for macOS or Windows. The web application is compiled into the binary and it starts its own private PostgreSQL, so nothing else has to be installed. It runs on your own machine or server and opens in your browser. |
| **An instance F7 operates** | F7 hosts and administers a deployment for you, and you sign in over the web. |

Either way, Atlas is a **single-tenant instance**: one deployment, one database, one signed ledger, per customer. Your data is not pooled with another customer's, and there is no shared multi-tenant store to pool it in. [How Atlas Runs](/overview/how-it-works) describes both models and exactly what each one sends outside the instance.

## What Atlas does with AI

Atlas uses AI models to draft, summarise, propose, and ask questions. Three limits are structural rather than promises:

1. **The model never signs anything and never changes the record on its own.** Signing is reserved to people. A model's output becomes part of your record only when a person puts it there.
2. **Factual claims are expected to carry a citation.** Where Atlas cannot ground a claim in a source, it is designed to decline rather than assert.
3. **Material Atlas fetches from the web enters as unverified** and stays that way until a person promotes it.

AI output can still be wrong. These limits constrain what the system does with a model's output; they do not make the output correct.

The model provider is a configuration choice, and on plans where you supply your own key, requests go to your own account with that provider. See [Your Controls](/privacy/your-controls).

## What Atlas is not

- **Atlas is not employee monitoring.** It installs nothing on anyone's device but the machine that runs the instance, and it observes no one. The one screen capture in the product, the feedback recorder called Rewind, records only the screen of the reviewer who turns it on, and it is absent from customer deployments today. See [Data Atlas Holds](/privacy/data-collection#atlas-rewind).
- **Atlas is not professional advice.** It can reference regulations, codes, and standards and show how your process relates to them. It does not provide legal, regulatory, financial, or engineering advice, and using it does not make you compliant with anything.
- **Atlas does not generate your production application.** It builds a governed definition, records who ratified what, and hands structured work to the tools you already use. The parts that would emit code are designed and not built.

## The earlier F7 product

F7 previously published documentation on this site for a workforce-analytics product: a device agent, a server, and management dashboards that measured how teams used AI tools. **That product has been shelved and is not offered.** This Trust Center now describes Atlas only. The documents under [Legal](/legal/privacy-policy) were written for the earlier product and carry a notice saying so until Atlas's own terms of use and privacy policy take effect.

---

::: tip Want to go deeper?
See [How Atlas Runs](/overview/how-it-works) for the deployment models and the complete list of what leaves the instance, or [What Atlas Holds](/overview/data-we-collect) for the data inventory.
:::
