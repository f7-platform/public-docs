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

### Added
- Public-claim checks for unimplemented third-party API integration examples and absolute Mode 3 no-disk/immediate-discard wording.
- Public-claim checks for stale audit-run references and missing evidence registrations for material public claims.

### Added
- This CHANGELOG file to track documentation changes
