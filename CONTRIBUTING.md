# Contributing

This repository is the **public documentation site** for fseven. The product
source (controller, agent, dashboard) is maintained in private repositories;
contributions to the public docs are welcome here.

## What belongs here

- `content/` — published pages (overview, install, privacy, security,
  compliance, FAQ).
- `docs/releases/` — release notes by version.
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
3. **Edit content** — update files under `content/` or `docs/releases/`. Keep
   claims precise and avoid implying capabilities that are not implemented or
   released. The `Public Repository Protocol` (see
   `fseven-docs/docs/PUBLIC-REPO-PROTOCOL.md` in the platform repo) governs
   what may appear here.
4. **Run local checks**:
   ```bash
   pnpm install
   pnpm build           # site builds without errors
   pnpm check:claims    # public-claims script passes
   ```
5. **Open a pull request** — link the related issue and describe what changed
   on the published site.

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
