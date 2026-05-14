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
| macOS Apple Silicon | `fseven-agent-aarch64-apple.pkg` | _(paste hash)_ | ✅ Notarized / ⚠️ Unsigned (explain) |
| macOS Intel | `fseven-agent-x86_64-apple.pkg` | _(paste hash)_ | ✅ Notarized / ⚠️ Unsigned |
| Windows x86_64 | `fseven-agent-x86_64-windows.msi` | _(paste hash)_ | ✅ Authenticode / ⚠️ Unsigned |
| Linux x86_64 | `fseven-agent-x86_64-linux.tar.gz` | _(paste hash)_ | N/A |

> **Windows ARM64:** Not natively supported in this release. The x86_64 MSI
> runs under emulation.

## Signing Verification Steps

### macOS — Notarization check
```bash
spctl --assess --type install fseven-agent-aarch64-apple.pkg
# Expected: source=Notarized Developer ID
```

### Windows — Authenticode check
```powershell
Get-AuthenticodeSignature .\fseven-agent-x86_64-windows.msi | Format-List
# Expected: Status = Valid
```

### Checksum verification
```bash
sha256sum -c fseven-agent-aarch64-apple.pkg.sha256
sha256sum -c fseven-agent-x86_64-linux.tar.gz.sha256
```

## Public Distribution Contract Evidence

Complete these checks for the public-agent-binaries release surface and paste
command output or links to CI logs.

| Contract | Required evidence | Result |
|---|---|---|
| Public repo is distribution-only and has no controller Dockerfile/build context | `public-agent-binaries/docker-compose.yml` note plus `test ! -f Dockerfile` | ✅ / ❌ |
| Bash installer does not fall back to `docker compose --profile community build` | `bash tests/bootstrap-handoff-static.sh` and `rg 'docker compose --profile community build' install.sh` returns no matches | ✅ / ❌ |
| Windows ARM64 uses documented x86_64 MSI emulation path | `README.md` platform table and `install.ps1` fallback select `windows_x86_64`/`x86_64` | ✅ / ❌ |
| Manual Enterprise/MDM snippets verify downloads | macOS `.sha256` + `pkgutil`, Windows `.sha256` + Authenticode, Linux `.sha256` checks appear in README | ✅ / ❌ |

## Install Script Tests

| Test | Result |
|---|---|
| macOS: `bash install.sh` smoke test on clean system | ✅ / ❌ |
| Linux: `bash install.sh` smoke test | ✅ / ❌ |
| Windows: `irm ... | iex` smoke test | ✅ / ❌ |

## Release Notes Accuracy Check

- [ ] Platform support table in README matches artifacts above
- [ ] Signing/notarization status in README matches actual status for this release
- [ ] Release notes state any missing signing/notarization evidence by platform
- [ ] Windows ARM64 is documented as x86_64 emulation only unless a native asset is present
- [ ] No local-build fallback is documented for public-agent-binaries
- [ ] CHANGELOG.md updated with release notes
- [ ] No mention of unsupported platforms without caveats

## Evidence Signoff

| Reviewer | Date | Notes |
|---|---|---|
| _(name)_ | YYYY-MM-DD | |
