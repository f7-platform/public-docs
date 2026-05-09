# public-docs

Customer-facing documentation site for **fseven**, published from this
repository via VitePress. Source files live under [`content/`](content) and
release notes under [`docs/releases/`](docs/releases).

## What this repo is

- A static documentation site source.
- The single public source of truth for: overview, install/use docs, privacy,
  security posture, compliance summaries, FAQ, and release notes.
- A protocol-bound public repository governed by
  [`fseven-docs/docs/PUBLIC-REPO-PROTOCOL.md`](https://github.com/f7-platform/fseven-docs/blob/main/docs/PUBLIC-REPO-PROTOCOL.md).

## What this repo is NOT

- It is **not** the controller, agent, or platform source. Those live in
  private repositories.
- It is **not** an installer. For self-host install, see
  [`public-agent-binaries`](https://github.com/f7-platform/public-agent-binaries).

## Local development

Requires Node 20+ and pnpm.

```bash
pnpm install
pnpm dev          # http://localhost:5173
pnpm build        # static site → .vitepress/dist
pnpm check:claims # validate public claims script
```

## Supported platforms

The published site is platform-agnostic (static HTML/CSS/JS). Local development
is supported on macOS, Linux, and Windows (WSL recommended).

## Security

Do **not** report security vulnerabilities via GitHub issues. See
[`SECURITY.md`](SECURITY.md) for coordinated disclosure instructions.

## Support

- General questions: open an issue on this repository.
- Customer support: see the support section on the published site.

## License

See [`LICENSE`](LICENSE).
