# Release Evidence Pack — Public Installer
<!--
  Template: fill one copy per fseven-agent release tag.
  File as: docs/releases/evidence/installer-{VERSION}.md
  Reviewed by: release engineer before public announcement.
-->

## Release Metadata

| Field | Value |
|---|---|
| Release tag | `vX.Y.Z` |
| Release date | YYYY-MM-DD |
| Commit SHA | _(full SHA)_ |
| Release workflow run | _(GitHub Actions URL)_ |

## Platform Artifacts

| Platform | Artifact filename | SHA-256 | Signing/notarization status |
|---|---|---|---|
| macOS Apple Silicon | `fseven-agent-aarch64-apple-vX.Y.Z.pkg` | _(paste hash)_ | ✅ Notarized / ⚠️ Unsigned (explain) |
| macOS Intel | `fseven-agent-x86_64-apple-vX.Y.Z.pkg` | _(paste hash)_ | ✅ Notarized / ⚠️ Unsigned |
| Windows x86_64 | `fseven-agent-x86_64-windows-vX.Y.Z.msi` | _(paste hash)_ | ✅ Authenticode / ⚠️ Unsigned |
| Linux x86_64 | `fseven-agent-x86_64-linux-vX.Y.Z.tar.gz` | _(paste hash)_ | N/A |

> **Windows ARM64:** Not natively supported in this release. The x86_64 MSI
> runs under emulation.

## Signing Verification Steps

### macOS — Notarization check
```bash
spctl --assess --type install fseven-agent-aarch64-apple-vX.Y.Z.pkg
# Expected: source=Notarized Developer ID
```

### Windows — Authenticode check
```powershell
Get-AuthenticodeSignature .\fseven-agent-x86_64-windows-vX.Y.Z.msi | Format-List
# Expected: Status = Valid
```

### Checksum verification
```bash
sha256sum -c fseven-agent-aarch64-apple-vX.Y.Z.pkg.sha256
sha256sum -c fseven-agent-x86_64-linux-vX.Y.Z.tar.gz.sha256
```

## Install Script Tests

| Test | Result |
|---|---|
| macOS: `bash install.sh` smoke test on clean system | ✅ / ❌ |
| Linux: `bash install.sh` smoke test | ✅ / ❌ |
| Windows: `irm ... | iex` smoke test | ✅ / ❌ |

## Release Notes Accuracy Check

- [ ] Platform support table in README matches artifacts above
- [ ] Signing/notarization status in README matches actual status for this release
- [ ] CHANGELOG.md updated with release notes
- [ ] No mention of unsupported platforms without caveats

## Evidence Signoff

| Reviewer | Date | Notes |
|---|---|---|
| _(name)_ | YYYY-MM-DD | |
