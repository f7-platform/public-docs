# Contributing

This repository is the **public documentation site** for fseven. The product
source (controller, agent, dashboard) is maintained in private repositories;
contributions to the public docs are welcome here.

## What belongs here

- `content/` — published pages (overview, privacy, security, compliance,
  legal, FAQ). The site is built from this directory only.
- `scripts/` — site build/check helpers (e.g. `check-public-claims.sh`).
- `package.json` / VitePress configuration.

## What does NOT belong here

- Product source code or installer scripts. Open issues against
  `public-agent-binaries` (installer) or the relevant private repository for
  product changes.
- Private roadmap content, internal audit notes, or customer-specific data.

## How to contribute

1. **Open an issue first** — describe the problem, missing information, or
   proposed addition so it can be triaged before you write a PR.
2. **Fork and branch** — create a feature branch from `main`.
3. **Edit content** — update files under `content/`. Keep
   claims precise and avoid implying capabilities that are not implemented or
   released. The `Public Repository Protocol` (see
   `fseven-docs/docs/PUBLIC-REPO-PROTOCOL.md` in the platform repo) governs
   what may appear here.
4. **Run local checks** (CI is npm-authoritative):
   ```bash
   npm ci
   npm run test:audit     # fixture tests of the dependency-advisory checker pass
   npm run check:audit    # full-lockfile dependency audit passes (see below)
   npm run test:claims    # fixture tests of the claim checker pass
   npm run check:claims   # public-claims script passes
   npm run build          # site builds without errors
   ```
   The claims checker needs bash 3.2 or newer; macOS's stock `/bin/bash` is
   enough, and the checker refuses with exit 2 under anything older.
5. **Open a pull request** — link the related issue and describe what changed
   on the published site.

## Dependency advisories

The `build` job in `.github/workflows/deploy.yml` is the one status check
`main` requires, so whatever fails it blocks both the merge and the publish.
That job runs `npm run check:audit`, which audits every package in
`package-lock.json`, dev dependencies included, because the site is built
entirely from dev dependencies. An advisory at moderate severity or above,
including any High or Critical, fails the job unless `audit-waivers.json`
carries an exception for it that is dated, reasoned and unexpired. The job
also fails when an exception has expired, when an exception matches no
reported advisory (a stale entry would otherwise hide a future one), and when
the npm registry does not answer the audit.

Fix the advisory if you can: a lockfile update inside the declared ranges is
the usual remedy. Add an exception only when no fix can be taken now. An
exception is one entry in the `waivers` array, keyed by the advisory's GHSA
id, with these fields:

- `id`: the GHSA id, for example `GHSA-xxxx-xxxx-xxxx`.
- `severity`: the severity npm reports for it; a later rescoring above this
  fails the job until the exception is reviewed again.
- `packages`: every package npm reports the advisory through.
- `reachability`: why the vulnerable code cannot be reached by how this site
  is built and published.
- `fix`: what will clear the advisory, and the issue that tracks it.
- `reviewed` and `expires`: `YYYY-MM-DD` dates, with `expires` at most 90 days
  after `reviewed`.

Run `npm run check:audit` to see each advisory and its exception, and
`npm run test:audit` after changing the checker.

## Claim accuracy

Public docs must describe **implemented** behavior. Do not introduce wording
that:

- Implies a feature is GA when it is gated, planned, or experimental.
- Promises a security control without naming the workflow or artifact that
  proves it.
- References an audit run, CI workflow, or release that does not exist.

If you find existing wording that violates these rules, opening a PR to fix it
is welcome.

## Code of conduct

Be respectful and constructive. We follow the
[Contributor Covenant v2.1](https://www.contributor-covenant.org/version/2/1/code_of_conduct/).

## Security

Do **not** report security vulnerabilities via a GitHub issue. See
[`SECURITY.md`](SECURITY.md).

## License

By contributing, you agree that your contributions will be licensed under the
same terms as the rest of the repository (see [`LICENSE`](LICENSE)).
