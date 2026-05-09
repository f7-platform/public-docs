# Security Policy

## Supported Versions

Documentation in this repository tracks the **current** released version of
fseven. Older release notes remain published for historical reference but
security errata are written for the current release only.

## Reporting a Vulnerability

**Do not open a public GitHub issue for security vulnerabilities** in
documented behavior, in the published site, or in the underlying products
(controller, agent, dashboard).

Email **security@f7-platform.io** with:

- A description of the vulnerability.
- The page URL or repository file affected (if it is a documentation issue).
- For product vulnerabilities: steps to reproduce (proof of concept if
  available), versions/platforms affected, any known mitigations.

You will receive an acknowledgement within 3 business days. We aim to release
a fix or correction within 14 days of confirming the issue; if that timeline
cannot be met we will communicate the adjusted schedule.

We follow a 90-day coordinated disclosure policy. We ask that you give us
that window before disclosing publicly.

## Documentation Security Errata

If a published claim on the docs site is shown to be inaccurate or misleading
in a way that affects security posture, we will:

1. Correct the affected page on the next site deploy.
2. Note the correction in `CHANGELOG.md`.
3. If the misstatement materially affected customer-facing controls, link the
   correction from the next release-notes entry.

## Scope

This policy covers:

- The content published from this repository (`content/`, `docs/releases/`).
- The build/deploy scripts (`scripts/`).

Vulnerabilities in the controller, agent, or dashboard runtime should follow
the same email path; they will be triaged by the appropriate product team.
