# public-docs

Customer-facing documentation site for **Atlas by F7** — the F7 Trust Center —
published from this repository via VitePress. Source files live under
[`content/`](content) and release evidence templates under
[`docs/releases/`](docs/releases).

## What this repo is

- A static documentation site source.
- The single public source of truth for: what Atlas is and how it runs, what
  an instance holds and what leaves it, security posture, privacy, compliance
  summaries, and the FAQ.
- A protocol-bound public repository governed by
  [`fseven-docs/docs/PUBLIC-REPO-PROTOCOL.md`](https://github.com/f7-platform/fseven-docs/blob/main/docs/PUBLIC-REPO-PROTOCOL.md).
- Claims-gated: every material claim is registered in
  `content/compliance/claims-registry.json` with its evidence, and
  `scripts/check-public-claims.sh` fails the deploy on a forbidden or
  unregistered claim.

## What this repo is NOT

- It is **not** Atlas's source. That lives in a private repository.
- It is **not** the download. Signed installers, checksums and the update
  manifest are published from
  [`public-atlas-binaries`](https://github.com/f7-platform/public-atlas-binaries).

## Local development

Requires Node 22 and npm. CI is npm-authoritative (`npm ci` against
`package-lock.json`); do not commit a `pnpm-lock.yaml`.

```bash
npm ci
npm run dev            # http://localhost:5173
npm run test:claims    # fixture tests of the claim checker
npm run check:claims   # validate public claims against the registry
npm run build          # static site → .vitepress/dist
```

The audit-run baseline lives in one place, `content/compliance/claims-registry.json`
(`audit_run`); bump it with `npm run bump:audit-run -- <N>`.

## Supported platforms

The published site is platform-agnostic (static HTML/CSS/JS). Local development
is supported on macOS, Linux, and Windows (WSL recommended).

## Security

Do **not** report security vulnerabilities via GitHub issues. See
[`SECURITY.md`](SECURITY.md) for coordinated disclosure instructions.

## Support

- Questions about the published documentation: open an issue on this repository.
- Product support: see the contacts on the published site.

## License

See [`LICENSE`](LICENSE).
