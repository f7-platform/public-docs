# Release Evidence Packs — Overview

This directory contains templates and completed release evidence packs.

## Structure

```
evidence/
├── templates/                          # Reusable evidence pack templates
│   ├── installer-evidence-pack.md      # Public installer artifacts + signing
│   ├── public-docs-claims-evidence-pack.md  # Public docs claims accuracy review
│   └── schema-license-parity-evidence-pack.md  # Schema/license contract parity
└── {type}-{VERSION_OR_DATE}.md         # Completed packs (one per release)
```

## When to Complete a Pack

| Pack template | When to fill |
|---|---|
| `installer-evidence-pack.md` | Each `fseven-agent` binary release |
| `public-docs-claims-evidence-pack.md` | Before each public-docs deploy with new capability claims |
| `schema-license-parity-evidence-pack.md` | Each `fseven-schemas` migration or new contract |

## Completing a Pack

1. Copy the template: `cp templates/installer-evidence-pack.md installer-vX.Y.Z.md`
2. Fill all fields and run the referenced commands.
3. Check all boxes or note exceptions.
4. Commit the completed pack to this directory.
5. Reference the pack filename in the release PR description.

## Naming Convention

- `installer-v{VERSION}.md` — e.g., `installer-v1.2.0.md`
- `public-docs-claims-{YYYYMMDD}.md` — e.g., `public-docs-claims-20260115.md`
- `schema-license-parity-{YYYYMMDD}.md`
