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

  cat >"$docs_root/content/compliance/claims-registry.json" <<'JSON'
{
  "audit_run": 30,
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

printf 'public claims checker fixture tests passed\n'