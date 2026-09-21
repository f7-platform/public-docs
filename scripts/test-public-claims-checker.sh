#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

# write_surface_doc <file> <lines> — a root doc as long as the real one.
# The checker's audit-run scan once leaked a file descriptor per surface line,
# and bash 3.2 crashed once the surface passed about 250 lines (PB23). The
# fixture's docs were a few lines each, so the suite passed on the same shell
# on which the real gate crashed. The five root docs below match the real
# ones' lengths (247 lines together) and the [Unreleased] block matches the
# real one (32 lines), so the fixture surface is past that point.
write_surface_doc() {
  local file="$1" lines="$2" i=4
  {
    printf '# fixture %s\n\n' "${file##*/}"
    printf 'Current latest security audit is Run 41.\n'
    while (( i <= lines )); do
      printf 'Fixture line %d of %s, sized like the real root doc.\n' "$i" "${file##*/}"
      i=$((i + 1))
    done
  } >"$file"
}

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
    "$docs_root/LICENSE" \
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
  # place it is declared, and the checker derives it from there with jq. The
  # fixture's run (41) is independent of the repo's real baseline — if the
  # checker hardcoded a run instead, these fixtures would fail (PB12).
  write_surface_doc "$docs_root/CLAUDE.md" 57
  write_surface_doc "$docs_root/.github/copilot-instructions.md" 26
  write_surface_doc "$docs_root/README.md" 50
  write_surface_doc "$docs_root/SECURITY.md" 47
  write_surface_doc "$docs_root/CONTRIBUTING.md" 67

  cat >"$docs_root/content/faq.md" <<'MD'
# FAQ

The platform is tracked through an ongoing security audit program (most recently Run 41).

Fixture pages may describe a withdrawn claim in other words, as this line does,
without ever quoting the phrase the registry registers for it.
MD

  cat >"$docs_root/content/compliance/soc2.md" <<'MD'
# SOC 2

- **Run 41 security audit baseline** with documented findings and remediation
MD

  # Released CHANGELOG sections are a historical record: they may cite a
  # superseded run. Only the live [Unreleased] section makes a current claim.
  {
    cat <<'MD'
# Changelog

## [Unreleased]

### Changed
- Public audit references now use Run 41 as the latest security audit baseline.
MD
    local i=7
    while (( i <= 33 )); do
      printf -- '- Fixture [Unreleased] entry on line %d.\n' "$i"
      i=$((i + 1))
    done
    printf -- '- Last [Unreleased] entry, citing Run 41.\n\n'
    cat <<'MD'
## [1.0.0] - 2026-01-01

### Changed
- Public audit references now use Run 30 as the latest security audit baseline.
MD
  } >"$docs_root/CHANGELOG.md"

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
    },
    {
      "id": "CLM-013",
      "summary": "Fixture withdrawn claim phrase that must never appear on a page",
      "source_files": [],
      "evidence": [],
      "audit_refs": ["PDC5"],
      "forbidden_phrases": ["can already open the withdrawn feature"],
      "release_status": "not-available",
      "notes": "Fixture-only withdrawn claim. Its first significant word is shared with every fixture page, so the base fixture passing proves the checker matches the summary phrase and not a keyword from it (PB29)."
    }
  ]
}
JSON

  printf '%s\n' "$platform_root"
}

# The checker runs under the interpreter running this suite ($BASH), so
# `/bin/bash scripts/test-public-claims-checker.sh` tests it under bash 3.2 on
# macOS. PUBLIC_DOCS_EXPECTED_AUDIT_RUN is cleared so the baseline is always
# the one the checker derives from the fixture's registry.
CHECKER_OUT="$TEMP_DIR/checker.out"
CHECKER_ERR="$TEMP_DIR/checker.err"
checker_status=0

run_checker() {
  local platform_root="$1"
  checker_status=0
  env -u PUBLIC_DOCS_EXPECTED_AUDIT_RUN \
    PUBLIC_DOCS_ROOT="$platform_root/public-docs" \
    PUBLIC_DOCS_PLATFORM_ROOT="$platform_root" \
    "$BASH" "$REPO_ROOT/scripts/check-public-claims.sh" >"$CHECKER_OUT" 2>"$CHECKER_ERR" ||
    checker_status=$?
}

# A status above 128 is a signal death, not a verdict: the checker crashed.
fail_on_crash() {
  local label="$1"
  if (( checker_status > 128 )); then
    printf 'FAIL: %s: the checker was killed by SIG%s (exit %d) under bash %s — a crash is not a verdict\n' \
      "$label" "$(kill -l $((checker_status - 128)) 2>/dev/null || echo '?')" \
      "$checker_status" "$BASH_VERSION" >&2
    cat "$CHECKER_ERR" >&2
    exit 1
  fi
}

expect_pass() {
  local label="$1"
  local platform_root="$2"

  run_checker "$platform_root"
  fail_on_crash "$label"
  if (( checker_status != 0 )); then
    printf 'FAIL: %s should pass, but the checker exited %d\n' "$label" "$checker_status" >&2
    cat "$CHECKER_ERR" >&2
    exit 1
  fi
}

# Exactly 1 is the checker's refusal. Any other non-zero status — a crash, or
# the version floor's 2 — would otherwise read as a correct refusal (PB23).
# The optional third argument is a line the refusal must report on stderr.
expect_fail() {
  local label="$1"
  local platform_root="$2"
  local reported="${3:-}"

  run_checker "$platform_root"
  fail_on_crash "$label"
  if (( checker_status != 1 )); then
    printf 'FAIL: %s should fail with exit 1, but the checker exited %d\n' \
      "$label" "$checker_status" >&2
    cat "$CHECKER_OUT" "$CHECKER_ERR" >&2
    exit 1
  fi
  if [[ -n "$reported" ]] && ! grep -qF -- "$reported" "$CHECKER_ERR"; then
    printf 'FAIL: %s failed, but did not report: %s\n' "$label" "$reported" >&2
    cat "$CHECKER_ERR" >&2
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

# ── withdrawn claims must not reach the surface (PB29) ────────────────────────
# A not-available claim names a feature that is not shipped; the checker fails
# when the summary registered for it is published. The pass case is what makes
# the failure case mean anything: the base fixture's withdrawn summary begins
# with "Fixture", the word every fixture page is full of, and faq.md describes
# the same withdrawn claim in other words. Both must pass unremarked, or the
# check is a keyword scan rather than the phrase check the registry page
# promises. The loop this replaced greped that first word and did nothing with
# the hits, so no withdrawn claim could fail the build.

platform_root="$(build_fixture)"
expect_pass "withdrawn claim absent from the surface" "$platform_root"

# content/privacy/index.md is an empty fixture page, so the phrase lands on line
# 1 and the reported location below is exact. The third argument names the claim
# id, the summary and that location: if the loop's record_failure is dropped or
# stops naming the claim, this case fails.
platform_root="$(build_fixture)"
printf '%s\n' 'Fixture withdrawn claim phrase that must never appear on a page.' \
  >>"$platform_root/public-docs/content/privacy/index.md"
expect_fail "withdrawn claim's summary phrase on a published page" "$platform_root" \
  'not-available claim CLM-013 appears on the public surface at content/privacy/index.md:1: "Fixture withdrawn claim phrase that must never appear on a page"'

# ── a claim's forbidden_phrases (public-docs#53) ──────────────────────────────
# The summary is one phrase, so a page asserting the same withdrawn feature in
# other words passed. A claim may carry forbidden_phrases, each matched the way
# the summary is: a fixed string, case-insensitively, anywhere under content/.
# The base fixture's CLM-013 carries one, and faq.md does not contain it, so the
# base pass above also proves an absent phrase is not a failure.

# The paraphrase is written in a different case from the registry entry, so the
# match must be case-insensitive for this case to fail.
platform_root="$(build_fixture)"
printf '%s\n' 'Every fixture reader can already open the Withdrawn Feature today.' \
  >>"$platform_root/public-docs/content/privacy/index.md"
expect_fail "withdrawn claim's forbidden phrase on a published page" "$platform_root" \
  'claim CLM-013 forbidden phrase appears on the public surface at content/privacy/index.md:1: "can already open the withdrawn feature"'

# An empty entry would make grep -F match every line of every page; a checker
# that skipped it instead would hide a registry mistake. Either way it is refused.
platform_root="$(build_fixture)"
node - "$platform_root/public-docs/content/compliance/claims-registry.json" <<'NODE'
const fs = require('node:fs');
const file = process.argv[2];
const registry = JSON.parse(fs.readFileSync(file, 'utf8'));
registry.claims[3].forbidden_phrases.push('  ');
fs.writeFileSync(file, `${JSON.stringify(registry, null, 2)}\n`);
NODE
expect_fail "blank forbidden phrase in the registry" "$platform_root" \
  'claims registry forbidden_phrases for CLM-013 must be an array of non-blank strings'

# The real CLM-009 entry, copied into the fixture, must refuse each of the three
# wordings the hand-written "current personal-dashboard capability" deny-list
# carried, which that deny-list no longer carries. Its summary matches none of
# them, so without forbidden_phrases every one of these would publish.
for wording in \
  'Employees see their own data on a personal dashboard.' \
  'Every employee sees their own behavioral data.' \
  'F7 gives every employee visibility into their own behavioral data.'; do
  platform_root="$(build_fixture)"
  node - "$platform_root/public-docs/content/compliance/claims-registry.json" \
    "$REPO_ROOT/content/compliance/claims-registry.json" <<'NODE'
const fs = require('node:fs');
const [file, real] = process.argv.slice(2);
const registry = JSON.parse(fs.readFileSync(file, 'utf8'));
const clm009 = JSON.parse(fs.readFileSync(real, 'utf8')).claims.find((c) => c.id === 'CLM-009');
registry.claims.push(clm009);
fs.writeFileSync(file, `${JSON.stringify(registry, null, 2)}\n`);
NODE
  printf '%s\n' "$wording" >>"$platform_root/public-docs/content/privacy/index.md"
  expect_fail "CLM-009 wording on a published page: $wording" "$platform_root" \
    'claim CLM-009 forbidden phrase appears on the public surface at content/privacy/index.md:1'
done

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
expect_fail "stale audit run in the live CHANGELOG [Unreleased] section" "$platform_root" \
  "CHANGELOG.md [Unreleased]:6 cites Run 30, but the baseline is Run 41"

# The last line of the surface, well past the ~250 lines at which the per-line
# scan crashed under bash 3.2 (PB23): drift there must still be found.
platform_root="$(build_fixture)"
perl -pi -e 's/entry, citing Run 41/entry, citing Run 39/' "$platform_root/public-docs/CHANGELOG.md"
expect_fail "stale audit run on the last line of the surface" "$platform_root" \
  "CHANGELOG.md [Unreleased]:34 cites Run 39, but the baseline is Run 41"

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