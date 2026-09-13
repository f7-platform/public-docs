# Downloads and Updates

Atlas is distributed from a public release repository, [public-atlas-binaries](https://github.com/f7-platform/public-atlas-binaries), which carries signed installers, their checksums and the self-update manifest. There is no source code there; Atlas's source is private.

## What you can download

| Platform | Artifact | Signing |
|---|---|---|
| macOS (Apple Silicon and Intel) | Disk image | Developer ID signed, hardened runtime, notarized by Apple with the ticket stapled |
| Windows (x64) | Per-user installer, or a flat zip for portable installs | Authenticode signed via Azure Trusted Signing, with a timestamp |
| macOS, terminal layout | The same binary in a flat folder | As above |

One download is the whole product: the web application is compiled into the binary and it starts its own private PostgreSQL.

## What proves each control

Every release attaches the artifacts that let you check it yourself, and the release repository's README gives the exact commands.

| Control | The artifact that proves it |
|---|---|
| Asset integrity | `SHA256SUMS` and a per-file `.sha256`, checked with `shasum -a 256 -c` or `Get-FileHash` |
| macOS authenticity | The notarization ticket and Developer ID signature, checked with `spctl` and `codesign --verify --strict` |
| Windows authenticity | The Authenticode signature, checked with `Get-AuthenticodeSignature` |
| Update authenticity | `latest.json` with its detached Ed25519 signature `latest.json.sig` and the public key `atlas-update.pub.pem`; the key's fingerprint is published in the repository README, and the same key bytes are compiled into every download |

Gatekeeper and SmartScreen should accept the artifacts without overrides. If either warns on a file whose checksum matches, treat it as suspicious and report it.

**Not published:** a software bill of materials. The release process does not currently publish one, and each release's notes state what evidence is and is not included.

## How updates work

Only the download updates itself. A server or fleet build refuses to stage or apply a release asset and upgrades by image pin instead.

1. The instance fetches `latest.json` over HTTPS from the release repository. Any redirect that would leave HTTPS is refused.
2. The manifest's bytes are verified against the pinned Ed25519 public key **before they are parsed**. A well-formed manifest without a valid signature never reaches the parser; a signed but malformed one is a parse error.
3. When an update is offered and you accept it, the asset for your platform is downloaded and its SHA-256 is verified against the signed manifest before anything else touches the file.
4. The digest is verified again immediately before the new version runs.
5. Every failure resolves to "no update available", never to a bare version being applied.

A build with no pinned public key has no update checker at all: no task, no request, no cached outcome. That is the state of every build that is not the packaged download, so there is no switch to forget.

## Licence

The binaries are proprietary software distributed under the terms in the release repository's `LICENSE` and presented in the product. Licences pasted into the app verify offline against keys compiled into it, and the download includes a 14-day trial that needs no connection to F7.

## Reporting a problem

Open an issue on the release repository for install or download problems. Report vulnerabilities as described in this Trust Center's security policy, never in a public issue.
