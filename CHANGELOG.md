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
- Public audit references now use Run 27b as the latest security audit baseline.

### Added
- Public-claim checks for unimplemented third-party API integration examples and absolute Mode 3 no-disk/immediate-discard wording.

### Added
- This CHANGELOG file to track documentation changes
