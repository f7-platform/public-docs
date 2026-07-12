# Changelog

All notable changes to the F7 public documentation will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed
- Corrected public third-party integration claims to the implemented controller event/webhook sources: GitHub, GitLab, Bitbucket, Jira, Linear, Asana, Jenkins, GitHub Actions, GitLab CI, CircleCI, Google Calendar, Microsoft Outlook, LaunchDarkly, Zendesk, and Generic webhooks.
- Clarified Mode 3 privacy wording: screen frames are never uploaded or transmitted off-device, but current macOS capture may use a temporary OS-local PNG that is read and deleted after inference.
- Security architecture: qualified SPKI certificate pinning claims (infrastructure present, operational pins per-deployment)
- Encryption: clarified certificate pinning status
- Agent security: added note on signing key management in update verification pipeline
- Public audit references now use Run 36 as the latest security audit baseline.
- Claims registry updated to Run 36 and now registers material integration provider, Mode 3 capture, and Trust Center dependency-audit claims.
- Remediated the public-docs build-time npm advisory tail by pinning vite to ^6.4.3 (clears the esbuild/vite/vitepress advisory cluster); `npm audit` now reports 0 vulnerabilities.
- Removed the committed `pnpm-lock.yaml` so `package-lock.json` (consumed by CI `npm ci`) is the single authoritative lockfile.

### Fixed
- The claims checker asserted the existence of files inside the private sibling product repos, which are not checked out in this public repo's own CI. The check therefore failed 100% of the time in CI regardless of correctness, which blocked the Trust Center deploy — no publish has succeeded since 2026-05-09, so the live site still served a nine-run-stale audit baseline while the repo said otherwise. Cross-repo evidence paths are now verified wherever the sibling repo is available (meta-repo workspace, local dev) and reported as unverified where it is not; the shape checks (safe relative path, no repo-boundary crossing, known repo) still hard-fail everywhere.

### Added
- Public-claim checks for unimplemented third-party API integration examples and absolute Mode 3 no-disk/immediate-discard wording.
- Public-claim checks for stale audit-run references and missing evidence registrations for material public claims.
- `npm run bump:audit-run -- <N>` bumps the audit baseline in one command: it updates the single source and rewrites every derived public mention.
- The claim gate now also runs on pull requests, so a broken gate is caught before it reaches main.

### Changed
- The audit-run baseline is now single-sourced from `content/compliance/claims-registry.json` (`audit_run`). It was previously hardcoded in the registry, the checker, and the contributor docs, and had to be bumped in lockstep — which is how the public baseline went stale. The checker now derives the baseline and fails if any published page, contributor doc, or the live `CHANGELOG.md [Unreleased]` section cites a different run. This replaces the hand-maintained deny-list of superseded spellings, which only caught runs someone remembered to add; released `CHANGELOG.md` sections stay exempt as historical record.

### Added
- This CHANGELOG file to track documentation changes
