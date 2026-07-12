#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

build_fixture() {
  local platform_root="$TEMP_DIR/platform"
  local docs_root="$platform_root/public-docs"

  rm -rf "$platform_root"
  mkdir -p \
    "$docs_root/.github/workflows" \
    "$docs_root/content/compliance" \
    "$docs_root/content/privacy" \
    "$docs_root/content/legal" \
    "$docs_root/content/security" \
    "$docs_root/scripts" \
    "$platform_root/fseven-agent/agent-core/src/lifecycle" \
    "$platform_root/fseven-controller/server/src/integrations"

  touch \
    "$docs_root/README.md" \
    "$docs_root/LICENSE" \
    "$docs_root/CONTRIBUTING.md" \
    "$docs_root/SECURITY.md" \
    "$docs_root/content/compliance/soc2.md" \
    "$docs_root/content/privacy/data-collection.md" \
    "$docs_root/content/privacy/data-retention.md" \
    "$docs_root/content/privacy/index.md" \
    "$docs_root/content/legal/privacy-policy.md" \
    "$docs_root/content/legal/terms-of-service.md" \
    "$docs_root/content/security/index.md" \
    "$docs_root/.github/workflows/deploy.yml" \
    "$docs_root/scripts/check-public-claims.sh" \
    "$platform_root/fseven-agent/agent-core/src/lifecycle/vision_capture.rs" \
    "$platform_root/fseven-controller/server/src/integrations/models.rs"

  # The public surface names the baseline run in prose; the registry is the only
  # place it is declared. 41 is deliberately NOT the repo's real baseline — if
  # the checker still hardcoded a run, these fixtures would fail (PB12).
  cat >"$docs_root/CLAUDE.md" <<'MD'
# fixture contributor doc

Current latest security audit is Run 41.
MD

  cat >"$docs_root/content/faq.md" <<'MD'
# FAQ

The platform is tracked through an ongoing security audit program (most recently Run 41).
MD

  cat >"$docs_root/content/compliance/soc2.md" <<'MD'
# SOC 2

- **Run 41 security audit baseline** with documented findings and remediation
MD

  # Released CHANGELOG sections are a historical record: they may cite a
  # superseded run. Only the live [Unreleased] section makes a current claim.
  cat >"$docs_root/CHANGELOG.md" <<'MD'
# Changelog

## [Unreleased]

### Changed
- Public audit references now use Run 41 as the latest security audit baseline.

## [1.0.0] - 2026-01-01

### Changed
- Public audit references now use Run 30 as the latest security audit baseline.
MD

  cat >"$docs_root/content/compliance/claims-registry.json" <<'JSON'
{
  "audit_run": 41,
  "claims": [
    {
      "id": "CLM-010",
      "summary": "Implemented third-party event integration provider scope",
      "source_files": ["content/privacy/data-collection.md"],
      "evidence": [
        "fseven-controller: server/src/integrations/models.rs — implemented event/webhook source enum",
        "public-docs: content/privacy/data-collection.md — public provider list"
      ],
      "audit_refs": ["PUBDOC-1"],
      "release_status": "active"
    },
    {
      "id": "CLM-011",
      "summary": "Mode 3 frames stay local and current macOS capture may use temporary OS-local PNG files",
      "source_files": ["content/privacy/index.md", "content/legal/privacy-policy.md"],
      "evidence": [
        "fseven-agent: agent-core/src/lifecycle/vision_capture.rs — current macOS path uses a temporary PNG before read/remove cleanup",
        "public-docs: content/legal/privacy-policy.md — discloses temporary OS-local PNG behavior"
      ],
      "audit_refs": ["PUBDOC-2", "AGT-LOCAL-2"],
      "release_status": "active"
    },
    {
      "id": "CLM-012",
      "summary": "Trust Center dependency audit runs before GitHub Pages publication",
      "source_files": ["content/compliance/soc2.md", "content/security/index.md"],
      "evidence": [
        "public-docs: .github/workflows/deploy.yml — runs npm audit before claim checks",
        "public-docs: scripts/check-public-claims.sh — rejects overbroad dependency-audit claims"
      ],
      "audit_refs": ["PDC5", "PUBDOC-3"],
      "release_status": "active"
    }
  ]
}
JSON

  printf '%s\n' "$platform_root"
}

run_checker() {
  local platform_root="$1"
  PUBLIC_DOCS_ROOT="$platform_root/public-docs" \
  PUBLIC_DOCS_PLATFORM_ROOT="$platform_root" \
  bash "$REPO_ROOT/scripts/check-public-claims.sh" >/tmp/public-claims-test.out 2>/tmp/public-claims-test.err
}

expect_pass() {
  local label="$1"
  local platform_root="$2"

  if ! run_checker "$platform_root"; then
    printf 'FAIL: %s should pass\n' "$label" >&2
    cat /tmp/public-claims-test.err >&2
    exit 1
  fi
}

expect_fail() {
  local label="$1"
  local platform_root="$2"

  if run_checker "$platform_root"; then
    printf 'FAIL: %s should fail\n' "$label" >&2
    cat /tmp/public-claims-test.out >&2
    exit 1
  fi
}

platform_root="$(build_fixture)"
expect_pass "valid registry evidence paths" "$platform_root"

platform_root="$(build_fixture)"
node - "$platform_root/public-docs/content/compliance/claims-registry.json" <<'NODE'
const fs = require('node:fs');
const file = process.argv[2];
const registry = JSON.parse(fs.readFileSync(file, 'utf8'));
registry.claims[0].evidence[0] = 'public-docs: content/missing.md — stale path';
fs.writeFileSync(file, `${JSON.stringify(registry, null, 2)}\n`);
NODE
expect_fail "missing evidence path" "$platform_root"

platform_root="$(build_fixture)"
node - "$platform_root/public-docs/content/compliance/claims-registry.json" <<'NODE'
const fs = require('node:fs');
const file = process.argv[2];
const registry = JSON.parse(fs.readFileSync(file, 'utf8'));
registry.claims[0].evidence[0] = 'public-docs: fseven-agent/agent-core/src/lifecycle/vision_capture.rs — wrong repo boundary';
fs.writeFileSync(file, `${JSON.stringify(registry, null, 2)}\n`);
NODE
expect_fail "wrong-repo evidence path" "$platform_root"

platform_root="$(build_fixture)"
node - "$platform_root/public-docs/content/compliance/claims-registry.json" <<'NODE'
const fs = require('node:fs');
const file = process.argv[2];
const registry = JSON.parse(fs.readFileSync(file, 'utf8'));
registry.claims[0].evidence = [];
fs.writeFileSync(file, `${JSON.stringify(registry, null, 2)}\n`);
NODE
expect_fail "active claim without registry evidence" "$platform_root"

# ── audit-run baseline: single source of truth (PB12) ─────────────────────────
# The base fixture already proves two things by passing above:
#   1. the baseline is DERIVED from the registry (fixture is Run 41, not the
#      repo's real baseline — a hardcoded run in the checker would fail here);
#   2. a released CHANGELOG section may cite a superseded run (historical record).

set_registry_audit_run() {
  node - "$1" "$2" <<'NODE'
const fs = require('node:fs');
const [file, run] = process.argv.slice(2);
const registry = JSON.parse(fs.readFileSync(file, 'utf8'));
registry.audit_run = /^\d+$/.test(run) ? Number(run) : run;
fs.writeFileSync(file, `${JSON.stringify(registry, null, 2)}\n`);
NODE
}

# Stale run cited on a published page. This is the coverage the previous
# hand-maintained deny-list gave us ("Run 30 ...", "Run 27b ...") — now caught
# generically, for any run, without a list to maintain.
platform_root="$(build_fixture)"
printf -- '- **Run 30 security audit baseline** with documented findings\n' \
  >"$platform_root/public-docs/content/compliance/soc2.md"
expect_fail "stale audit run on a published page (Run 30)" "$platform_root"

platform_root="$(build_fixture)"
printf -- '- **Run 27b security audit baseline** with documented findings\n' \
  >"$platform_root/public-docs/content/compliance/soc2.md"
expect_fail "stale audit run on a published page (Run 27b)" "$platform_root"

# The lockstep failure PB12 describes: one site bumped, another left behind.
platform_root="$(build_fixture)"
set_registry_audit_run "$platform_root/public-docs/content/compliance/claims-registry.json" 42
expect_fail "registry bumped but public pages left behind" "$platform_root"

platform_root="$(build_fixture)"
printf 'Current latest security audit is Run 30.\n' >"$platform_root/public-docs/CLAUDE.md"
expect_fail "contributor doc disagrees with the registry baseline" "$platform_root"

# The live [Unreleased] changelog section IS a current claim.
platform_root="$(build_fixture)"
perl -pi -e 's/use Run 41 as/use Run 30 as/ if $. < 8' "$platform_root/public-docs/CHANGELOG.md"
expect_fail "stale audit run in the live CHANGELOG [Unreleased] section" "$platform_root"

platform_root="$(build_fixture)"
node - "$platform_root/public-docs/content/compliance/claims-registry.json" <<'NODE'
const fs = require('node:fs');
const file = process.argv[2];
const registry = JSON.parse(fs.readFileSync(file, 'utf8'));
delete registry.audit_run;
fs.writeFileSync(file, `${JSON.stringify(registry, null, 2)}\n`);
NODE
expect_fail "registry missing audit_run (no source of truth)" "$platform_root"

# ── cross-repo evidence: verifiable only where the sibling repo exists ─────────
# public-docs is public and stands alone; its sibling product repos are private
# and are not checked out in its own CI. Path existence is asserted wherever the
# repo IS available (meta-repo, local dev) and reported as unverified otherwise.
platform_root="$(build_fixture)"
rm -rf "$platform_root/fseven-agent" "$platform_root/fseven-controller"
expect_pass "sibling repos absent (standalone CI) — evidence paths unverified, not failed" "$platform_root"

platform_root="$(build_fixture)"
node - "$platform_root/public-docs/content/compliance/claims-registry.json" <<'NODE'
const fs = require('node:fs');
const file = process.argv[2];
const registry = JSON.parse(fs.readFileSync(file, 'utf8'));
registry.claims[1].evidence[0] = 'fseven-agent: agent-core/src/gone.rs — stale cross-repo pointer';
fs.writeFileSync(file, `${JSON.stringify(registry, null, 2)}\n`);
NODE
expect_fail "sibling repo present but evidence path missing" "$platform_root"

printf 'public claims checker fixture tests passed\n'