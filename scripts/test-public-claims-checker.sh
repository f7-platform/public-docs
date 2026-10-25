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

# The optional third argument is a line the pass must print on stdout.
expect_pass() {
  local label="$1"
  local platform_root="$2"
  local printed="${3:-}"

  run_checker "$platform_root"
  fail_on_crash "$label"
  if (( checker_status != 0 )); then
    printf 'FAIL: %s should pass, but the checker exited %d\n' "$label" "$checker_status" >&2
    cat "$CHECKER_ERR" >&2
    exit 1
  fi
  if [[ -n "$printed" ]] && ! grep -qF -- "$printed" "$CHECKER_OUT"; then
    printf 'FAIL: %s passed, but did not print: %s\n' "$label" "$printed" >&2
    cat "$CHECKER_OUT" >&2
    exit 1
  fi
}

# Exactly 1 is the checker's refusal. Any other non-zero status — a crash, or
# the version floor's 2 — would otherwise read as a correct refusal (PB23).
# Every argument after the second is a line the refusal must report on stderr.
expect_fail() {
  local label="$1"
  local platform_root="$2"
  local reported
  shift 2

  run_checker "$platform_root"
  fail_on_crash "$label"
  if (( checker_status != 1 )); then
    printf 'FAIL: %s should fail with exit 1, but the checker exited %d\n' \
      "$label" "$checker_status" >&2
    cat "$CHECKER_OUT" "$CHECKER_ERR" >&2
    exit 1
  fi
  for reported in "$@"; do
    if ! grep -qF -- "$reported" "$CHECKER_ERR"; then
      printf 'FAIL: %s failed, but did not report: %s\n' "$label" "$reported" >&2
      cat "$CHECKER_ERR" >&2
      exit 1
    fi
  done
}

# add_page_line <platform root> <line> — appends a line to a fixture page that
# starts empty, so the line lands on line 1 of content/privacy/index.md.
add_page_line() {
  printf '%s\n' "$2" >>"$1/public-docs/content/privacy/index.md"
}

# add_real_claim <platform root> <claim id> — copies a claim from the real
# registry into the fixture's, so a case tests the entry the site publishes.
add_real_claim() {
  node - "$1/public-docs/content/compliance/claims-registry.json" \
    "$REPO_ROOT/content/compliance/claims-registry.json" "$2" <<'NODE'
const fs = require('node:fs');
const [file, real, id] = process.argv.slice(2);
const registry = JSON.parse(fs.readFileSync(file, 'utf8'));
registry.claims.push(JSON.parse(fs.readFileSync(real, 'utf8')).claims.find((c) => c.id === id));
fs.writeFileSync(file, `${JSON.stringify(registry, null, 2)}\n`);
NODE
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

# ── every forbidden-claim pattern fires (public-docs#65) ──────────────────────
# No case made any check_absent pattern fire, so a pattern that could never
# match, or one whose label was lost, passed the suite. Each row below is one
# check_absent label and a sentence its pattern must refuse; the case fails
# unless the checker exits 1 and names that label. The Mode 3 label has two
# rows, one per verb form PB34 found published.
FIRED_LABELS="$TEMP_DIR/fired-labels.txt"
: >"$FIRED_LABELS"
while IFS='|' read -r label sentence; do
  [[ -n "$label" ]] || continue
  platform_root="$(build_fixture)"
  add_page_line "$platform_root" "$sentence"
  expect_fail "forbidden claim '$label' fires on: $sentence" "$platform_root" \
    "ERROR: forbidden public-docs claim found: $label"
  printf '%s\n' "$label" >>"$FIRED_LABELS"
done <<'CASES'
unimplemented compensation ingestion or masking|The platform ingests salary data from payroll.
specific HRIS connector names|Connect Workday to import your employee directory.
internal personal-data endpoint reference|Employees reach their records through personal-data endpoints.
internal API endpoint paths|Call /api/v1/internal/users to list every account.
premature SOC 2 certified declarative claim|F7 is SOC 2 Type II certified.
SOC 2 report offered before the audit|Contact security@fseven.ai to request the current SOC 2 report.
open-source license overclaim|F7 is fully open-source.
blanket URL-path not-captured (contradicts AI-provider path capture)|Destination domain only; never URL paths.
unimplemented third-party app API integration examples|Connect OpenAI / ChatGPT to import usage counts.
absolute Mode 3 no-disk/immediate-discard claim|The optional vision model processes frames locally and discards them immediately.
absolute Mode 3 no-disk/immediate-discard claim|Mode 3 vision frames are processed locally and discarded after inference.
overbroad dependency-audit cadence claim|Dependency auditing is Automated in CI on every commit.
placeholder postal address|- **Mail:** F7 Platform, Inc., [address to be published]
CASES

# The suite fails when the checker gains a check_absent call without a case
# here, or loses the label a case names: every label the checker passes to
# check_absent must be one a case above fired, and at least as many distinct
# labels must have fired as the checker makes calls.
checker_labels="$(awk '/^check_absent \\$/ { getline; sub(/^[[:space:]]*"/, ""); sub(/"[[:space:]]*\\$/, ""); print }' \
  "$REPO_ROOT/scripts/check-public-claims.sh")"
check_absent_calls="$(grep -cE '^[[:space:]]*check_absent([[:space:]]|$)' "$REPO_ROOT/scripts/check-public-claims.sh" || true)"
fired_cases="$(sort -u "$FIRED_LABELS" | grep -c . || true)"
if (( check_absent_calls == 0 || check_absent_calls != $(printf '%s\n' "$checker_labels" | grep -c .) )); then
  printf 'FAIL: read %d check_absent calls but %d labels from the checker; the label parse is out of step with it\n' \
    "$check_absent_calls" "$(printf '%s\n' "$checker_labels" | grep -c .)" >&2
  exit 1
fi
if (( check_absent_calls > fired_cases )); then
  printf 'FAIL: the checker makes %d check_absent calls but only %d cases fire one\n' \
    "$check_absent_calls" "$fired_cases" >&2
  exit 1
fi
while IFS= read -r label; do
  if ! grep -qxF -- "$label" "$FIRED_LABELS"; then
    printf 'FAIL: no case fires the check_absent label: %s\n' "$label" >&2
    exit 1
  fi
done <<<"$checker_labels"

# ── the wordings those patterns protect still pass ────────────────────────────
# Each pass case is a sentence a published page carries today, for a pattern
# whose own comment names what it must let through.
while IFS='|' read -r pattern sentence; do
  [[ -n "$pattern" ]] || continue
  platform_root="$(build_fixture)"
  add_page_line "$platform_root" "$sentence"
  expect_pass "$pattern still allows: $sentence" "$platform_root"
done <<'CASES'
Mode 3 (CLM-011's stdout wording)|Frames are never uploaded; current macOS builds stream capture bytes through stdout for local inference and scrub stale legacy vision temp files on startup.
Mode 3 (the agent page's wording)|The optional vision model processes screen frames on the device and never uploads them; current macOS builds stream capture bytes through stdout for local inference.
SOC 2 certified (a question heading)|### Is F7 SOC 2 certified?
SOC 2 report (the planned audit)|There is no SOC 2 report yet: the independent SOC 2 Type II audit is planned and has not taken place.
URL path (AI-provider path capture)|The active domain, optional API endpoint path for AI-provider classification, and approximate byte counts only.
CASES

# ── CLM-009's forbidden phrases (PB35) ─────────────────────────────────────────
# The personal dashboard is not shipped, so a page must not say employees can
# already see everything captured about them. The phrase is written in a
# different case from the registry entry; the planned-feature wording passes.
platform_root="$(build_fixture)"
add_real_claim "$platform_root" CLM-009
add_page_line "$platform_root" "Employees have Full Visibility into what's captured about them."
expect_fail "CLM-009 wording on a published page: full visibility into what's captured" "$platform_root" \
  "claim CLM-009 forbidden phrase appears on the public surface at content/privacy/index.md:1: \"full visibility into what's captured\""

platform_root="$(build_fixture)"
add_real_claim "$platform_root" CLM-009
add_page_line "$platform_root" "F7 will include a personal dashboard that gives employees direct visibility into the data captured about their work patterns."
expect_pass "CLM-009's planned-feature wording" "$platform_root"

# ── a page grep cannot read is not a clean page (PB42) ─────────────────────────
# grep exits 2 when it cannot read a file. check_absent ran grep as an if
# condition and the not-available and forbidden-phrase scans ended in || true,
# so a page no scan could read passed every one of them. A file with no read
# permission makes GNU and BSD grep exit 2, except for root, who reads it
# anyway; there GNU grep -R, which follows symbolic links, fails on a link to
# itself. Each method is tried on the grep the checker will run, and only when
# neither makes it exit 2 is the case skipped, with the reason printed.
make_unreadable_page() {
  local dir="$1/public-docs/content/privacy" probe_status
  printf 'Fixture page grep must not be able to read.\n' >"$dir/unreadable.md"
  chmod 000 "$dir/unreadable.md"
  probe_status=0
  grep -RIn -e 'fixture-probe-that-matches-nothing' -- "$dir" >/dev/null 2>&1 || probe_status=$?
  if (( probe_status == 2 )); then
    printf 'a page with no read permission\n'
    return
  fi
  rm -f "$dir/unreadable.md"
  ln -s unreadable.md "$dir/unreadable.md"
  probe_status=0
  grep -RIn -e 'fixture-probe-that-matches-nothing' -- "$dir" >/dev/null 2>&1 || probe_status=$?
  if (( probe_status == 2 )); then
    printf 'a symbolic link to itself\n'
    return
  fi
  rm -f "$dir/unreadable.md"
}

platform_root="$(build_fixture)"
unreadable_method="$(make_unreadable_page "$platform_root")"
if [[ -n "$unreadable_method" ]]; then
  expect_fail "a page grep cannot read ($unreadable_method)" "$platform_root" \
    "grep could not read the public surface (exit 2) while checking forbidden claim: unimplemented compensation ingestion or masking" \
    "grep could not read the public surface (exit 2) while checking not-available claim CLM-013" \
    "grep could not read the public surface (exit 2) while checking claim CLM-013 forbidden phrase \"can already open the withdrawn feature\""
else
  printf 'SKIP: a page grep cannot read: neither a file with no read permission nor a symbolic link to itself makes this grep exit 2 (uid %s, %s)\n' \
    "$(id -u)" "$(grep --version 2>/dev/null | head -n 1)"
fi

# ── evidence repositories (PB41) ───────────────────────────────────────────────
# public-atlas-binaries and fseven-backbone are repositories evidence may name.
# Neither is checked out beside the fixture, so the path is reported unverified,
# not failed; a repository outside the list still fails.
for evidence_repo in public-atlas-binaries fseven-backbone; do
  platform_root="$(build_fixture)"
  node - "$platform_root/public-docs/content/compliance/claims-registry.json" "$evidence_repo" <<'NODE'
const fs = require('node:fs');
const [file, repo] = process.argv.slice(2);
const registry = JSON.parse(fs.readFileSync(file, 'utf8'));
registry.claims[0].evidence.push(`${repo}: README.md — fixture evidence in a repository not checked out here`);
fs.writeFileSync(file, `${JSON.stringify(registry, null, 2)}\n`);
NODE
  expect_pass "evidence naming $evidence_repo" "$platform_root" \
    "NOTICE: evidence path for CLM-010 not verified — $evidence_repo is not checked out here"
done

platform_root="$(build_fixture)"
node - "$platform_root/public-docs/content/compliance/claims-registry.json" <<'NODE'
const fs = require('node:fs');
const file = process.argv[2];
const registry = JSON.parse(fs.readFileSync(file, 'utf8'));
registry.claims[0].evidence.push('fseven-nowhere: README.md — a repository the checker does not know');
fs.writeFileSync(file, `${JSON.stringify(registry, null, 2)}\n`);
NODE
expect_fail "evidence naming an unknown repository" "$platform_root" \
  "claims registry evidence for CLM-010 uses unknown repo boundary: fseven-nowhere"

# ── release statuses ───────────────────────────────────────────────────────────
# A status outside the ones claims-registry.md defines would slip past every
# status-keyed rule, so it is refused.
platform_root="$(build_fixture)"
node - "$platform_root/public-docs/content/compliance/claims-registry.json" <<'NODE'
const fs = require('node:fs');
const file = process.argv[2];
const registry = JSON.parse(fs.readFileSync(file, 'utf8'));
registry.claims[2].release_status = 'actve';
fs.writeFileSync(file, `${JSON.stringify(registry, null, 2)}\n`);
NODE
expect_fail "unknown release status" "$platform_root" \
  'claim CLM-012 has an unknown release_status "actve"'

printf 'public claims checker fixture tests passed\n'