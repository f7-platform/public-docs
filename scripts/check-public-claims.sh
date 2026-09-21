#!/usr/bin/env bash
# check-public-claims.sh — Validate public-docs content against the claims
# registry (content/compliance/claims-registry.json) and a set of forbidden
# patterns. Run as part of CI and before each release.
#
# Exit codes:
#   0 — all checks passed
#   1 — one or more forbidden claims found
#   2 — this shell cannot run the checks (see the version floor below)

# ── minimum shell: GNU bash 3.2 (PB23) ────────────────────────────────────────
# bash 3.2 is macOS's stock /bin/bash, and a contributor runs this before each
# release with whatever bash is first on their PATH, so the script is written
# for 3.2 and must never need 4.x (no mapfile, readarray, declare -A, wait -n,
# ${var,,} or ${var^^}). Below 3.2 it refuses rather than dying half-way.
# Plain [ ] tests, so a non-bash shell gets this message rather than a crash.
MIN_BASH_MAJOR=3
MIN_BASH_MINOR=2
if [ -z "${BASH_VERSION:-}" ] || [ "${BASH_VERSINFO[0]}" -lt "$MIN_BASH_MAJOR" ] ||
  { [ "${BASH_VERSINFO[0]}" -eq "$MIN_BASH_MAJOR" ] && [ "${BASH_VERSINFO[1]}" -lt "$MIN_BASH_MINOR" ]; }; then
  printf 'ERROR: %s needs GNU bash %s.%s or newer; this shell is %s.\n' \
    "${0##*/}" "$MIN_BASH_MAJOR" "$MIN_BASH_MINOR" "${BASH_VERSION:-not bash}" >&2
  printf '       Run it with bash %s.%s or newer: `/bin/bash %s` on macOS, or\n' \
    "$MIN_BASH_MAJOR" "$MIN_BASH_MINOR" "$0" >&2
  printf '       install a current bash and put it first on PATH for `npm run check:claims`.\n' >&2
  exit 2
fi

set -euo pipefail

DEFAULT_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT_DIR="${PUBLIC_DOCS_ROOT:-$DEFAULT_ROOT_DIR}"
PLATFORM_ROOT="${PUBLIC_DOCS_PLATFORM_ROOT:-$(cd "$ROOT_DIR/.." && pwd)}"
CONTENT_DIR="$ROOT_DIR/content"
REGISTRY="$CONTENT_DIR/compliance/claims-registry.json"

# ── audit-run baseline: SINGLE SOURCE OF TRUTH ────────────────────────────────
# The current audit-run baseline is declared in exactly one place:
#
#     content/compliance/claims-registry.json  →  .audit_run
#
# Nothing else in this repo may hardcode it. Every other "Run N" on the live
# public surface is a *derived* mention and is enforced against this value by
# check_audit_run_baseline() below, so the three-places-in-lockstep bump that
# produced a stale public baseline (PB2) cannot recur (PB12).
#
# To bump the baseline: scripts/bump-audit-run.sh <N>  (npm run bump:audit-run)
AUDIT_RUN=""
if command -v jq &>/dev/null && [[ -f "$REGISTRY" ]]; then
  AUDIT_RUN="$(jq -r '.audit_run // empty' "$REGISTRY")"
fi
# Escape hatch for tests/CI only — never a default.
AUDIT_RUN="${PUBLIC_DOCS_EXPECTED_AUDIT_RUN:-$AUDIT_RUN}"

failures=0

# ── helpers ───────────────────────────────────────────────────────────────────

check_absent() {
  local label="$1"
  local pattern="$2"
  # Exclude the registry file itself (it intentionally documents forbidden claims)
  if grep -RInE --exclude="claims-registry.json" -- "$pattern" "$CONTENT_DIR"; then
    printf '\nERROR: forbidden public-docs claim found: %s\n' "$label" >&2
    failures=$((failures + 1))
  fi
}

check_present() {
  local label="$1"
  local file="$2"
  if [[ ! -f "$file" ]]; then
    printf '\nERROR: required public-docs file missing: %s (%s)\n' "$label" "$file" >&2
    failures=$((failures + 1))
  fi
}

trim() {
  sed 's/^[[:space:]]*//;s/[[:space:]]*$//' <<<"$1"
}

record_failure() {
  printf '\nERROR: %s\n' "$1" >&2
  failures=$((failures + 1))
}

validate_repo_relative_path() {
  local claim_id="$1"
  local repo="$2"
  local rel_path="$3"
  local label="$4"
  local target

  rel_path="$(trim "$rel_path")"

  if [[ -z "$rel_path" || "$rel_path" == /* || "$rel_path" == *..* ]]; then
    record_failure "claims registry $label for $claim_id is not a safe repo-relative path: ${repo}:${rel_path}"
    return
  fi

  if [[ "$rel_path" == fseven-*/* || "$rel_path" == public-*/* ]]; then
    record_failure "claims registry $label for $claim_id crosses repo boundary: ${repo}:${rel_path}"
    return
  fi

  if [[ "$repo" == "public-docs" ]]; then
    target="$ROOT_DIR/$rel_path"
  else
    local repo_root="$PLATFORM_ROOT/$repo"
    if [[ ! -d "$repo_root" ]]; then
      # This repo is public and stands alone; its sibling product repos are
      # private and are NOT checked out in its own CI. Asserting their file
      # paths there is unsatisfiable by construction — it made this gate fail
      # 100% of the time in CI (and so blocked every Trust Center deploy),
      # which carries no signal about whether the evidence anchor is correct.
      # The shape checks above (safe relative path, no boundary crossing, known
      # repo) still hard-fail everywhere. Path existence is asserted wherever
      # the sibling repo IS available: the meta-repo workspace and local dev.
      printf 'NOTICE: %s for %s not verified — %s is not checked out here (%s)\n' \
        "$label" "$claim_id" "$repo" "$repo_root"
      return
    fi
    target="$repo_root/$rel_path"
  fi

  if [[ ! -e "$target" ]]; then
    record_failure "claims registry $label for $claim_id points to missing path: ${repo}:${rel_path} ($target)"
  fi
}

# ── audit-run baseline enforcement (PB12) ─────────────────────────────────────
# Every file on the *live* public surface that names a run must name the
# baseline run. This replaces the previous hand-maintained deny-list of
# superseded spellings ("Run 27b|Run 29|Run 30 ..."), which had to be extended
# in lockstep on every bump and only caught runs someone remembered to add.
# The check below catches ANY divergent run, including future ones.
#
# CHANGELOG.md is scanned only inside its live "[Unreleased]" section: released
# sections are a historical record of what was true at the time, and rewriting
# them to satisfy a current-baseline check would falsify that record (the Run 36
# bump had to do exactly that).

audit_run_surface_files() {
  local f
  find "$CONTENT_DIR" -type f -name '*.md' 2>/dev/null || true
  for f in \
    "$ROOT_DIR/CLAUDE.md" \
    "$ROOT_DIR/.github/copilot-instructions.md" \
    "$ROOT_DIR/README.md" \
    "$ROOT_DIR/SECURITY.md" \
    "$ROOT_DIR/CONTRIBUTING.md"; do
    [[ -f "$f" ]] && printf '%s\n' "$f"
  done
  return 0
}

# A run cited on the surface: "Run 38", "Run 27b".
AUDIT_RUN_CITATION='\bRun [0-9]+[a-z]?\b'

audit_run_citations() {
  # emits: <path>:<lineno>:Run <N>, one row per run cited on the live surface.
  #
  # One grep reads every surface file and one reads the [Unreleased] block;
  # grep numbers the lines itself, so nothing runs once per line. The previous
  # shape ran a process substitution per surface line, nested inside another,
  # and bash 3.2 leaks a file descriptor for each one: its process-substitution
  # table overruns the heap at descriptor 256, so on any surface over about 250
  # lines the stock macOS shell crashed or passed without reading it (PB23).
  #
  # grep exits 1 when nothing matches, which is a clean surface, and 2 when it
  # cannot read, which must not pass as one.
  local files=() f
  while IFS= read -r f; do
    files+=("$f")
  done < <(audit_run_surface_files)

  if (( ${#files[@]} > 0 )); then
    grep -HnoE -- "$AUDIT_RUN_CITATION" "${files[@]}" || (( $? == 1 )) || return 2
  fi

  if [[ -f "$ROOT_DIR/CHANGELOG.md" ]]; then
    # Lines outside [Unreleased] are blanked, not dropped, so grep's line
    # numbers are CHANGELOG.md's own.
    awk '
      /^## \[Unreleased\]/ { unreleased = 1; print ""; next }
      /^## / { unreleased = 0 }
      { print (unreleased ? $0 : "") }
    ' "$ROOT_DIR/CHANGELOG.md" |
      { grep -noE -- "$AUDIT_RUN_CITATION" || (( $? == 1 )); } |
      sed 's/^/CHANGELOG.md [Unreleased]:/' || return 2
  fi
}

check_audit_run_baseline() {
  if [[ -z "$AUDIT_RUN" ]]; then
    record_failure "audit-run baseline is missing: ${REGISTRY#"$ROOT_DIR"/} has no .audit_run (it is the single source of truth)"
    return
  fi

  if [[ ! "$AUDIT_RUN" =~ ^[0-9]+[a-z]?$ ]]; then
    record_failure "audit-run baseline is malformed: '$AUDIT_RUN' (expected a run like 36 or 27b)"
    return
  fi

  local citations row label lineno cited drift=0
  local row_re='^(.*):([0-9]+):Run ([0-9]+[a-z]?)$'
  if ! citations="$(audit_run_citations)"; then
    record_failure "audit-run baseline: grep could not read the live public surface"
    return
  fi

  while IFS= read -r row; do
    [[ -z "$row" ]] && continue
    if [[ ! "$row" =~ $row_re ]]; then
      record_failure "audit-run baseline: unreadable citation row: $row"
      continue
    fi
    label="${BASH_REMATCH[1]#"$ROOT_DIR"/}"
    lineno="${BASH_REMATCH[2]}"
    cited="${BASH_REMATCH[3]}"
    [[ "$cited" == "$AUDIT_RUN" ]] && continue
    printf '  %s:%s cites Run %s, but the baseline is Run %s\n' \
      "$label" "$lineno" "$cited" "$AUDIT_RUN" >&2
    drift=$((drift + 1))
  done <<<"$citations"

  if (( drift > 0 )); then
    printf '\nERROR: %d public audit-run reference(s) disagree with the baseline (Run %s) declared in %s\n' \
      "$drift" "$AUDIT_RUN" "${REGISTRY#"$ROOT_DIR"/}" >&2
    printf '       Bump every reference in one step: npm run bump:audit-run -- <N>\n' >&2
    failures=$((failures + 1))
    return
  fi

  printf 'audit-run baseline: OK (Run %s, single-sourced from %s)\n' \
    "$AUDIT_RUN" "${REGISTRY#"$ROOT_DIR"/}"
}

validate_evidence_path() {
  local claim_id="$1"
  local evidence="$2"
  local anchor repo rel_path

  anchor="${evidence%% — *}"
  anchor="$(trim "$anchor")"

  if [[ "$anchor" == NOTE:* ]]; then
    return
  fi

  if [[ "$anchor" == *:* ]]; then
    repo="$(trim "${anchor%%:*}")"
    rel_path="$(trim "${anchor#*:}")"
  elif [[ "$anchor" == fseven-*/* || "$anchor" == public-*/* ]]; then
    repo="${anchor%%/*}"
    rel_path="${anchor#*/}"
  else
    repo="public-docs"
    rel_path="$anchor"
  fi

  case "$repo" in
    fseven-agent|fseven-controller|fseven-schemas|fseven-docs|fseven-atlas|fseven-atlas-mvp|public-agent-binaries|public-docs) ;;
    *)
      record_failure "claims registry evidence for $claim_id uses unknown repo boundary: $repo"
      return
      ;;
  esac

  validate_repo_relative_path "$claim_id" "$repo" "$rel_path" "evidence path"
}

# ── forbidden claims ──────────────────────────────────────────────────────────

check_absent \
  "unimplemented compensation ingestion or masking" \
  'compensation data|compensation masking|salary fields|salary data|stock value|benefits value|can_view_compensation|sync_compensation'

check_absent \
  "specific HRIS connector names" \
  '\b(Workday|BambooHR|SAP SuccessFactors|Rippling|HiBob)\b'

# Wordings of the unshipped personal dashboard are CLM-009's forbidden_phrases
# in the claims registry (public-docs#53), not a pattern here.
check_absent \
  "internal personal-data endpoint reference" \
  'personal-data endpoints'

# Endpoint paths that are not yet public API — never document internal routes
check_absent \
  "internal API endpoint paths" \
  '/api/v[0-9]+/internal/|/admin/api/|/_internal/'

# SOC 2 certified — must not assert certified status until audit report is in hand.
# FAQ headings that are questions ("Is F7 SOC 2 certified?") are allowed; positive
# declarative claims ("F7 is SOC 2 certified", "F7 has obtained SOC 2") are not.
check_absent \
  "premature SOC 2 certified declarative claim" \
  'F7 is SOC 2 (Type II )?certified|F7 has obtained SOC 2|F7 received SOC 2|completed a SOC 2 audit|F7 completed SOC 2'

# License overclaims — must not claim open-source where proprietary
check_absent \
  "open-source license overclaim" \
  'fully open.source|100% open.source|open source forever'

# Stale audit-run references (any superseded run cited as the current baseline,
# anywhere on the live public surface) are caught by check_audit_run_baseline().
check_audit_run_baseline

# Blanket URL-path not-captured wording — the AI-provider path IS captured for
# classification; any document that says "URL path" is in the "Not captured" list
# contradicts this and must be removed.
check_absent \
  "blanket URL-path not-captured (contradicts AI-provider path capture)" \
  'URL path, query parameters, request body|Never the full URL, path|Only the active domain is captured — never full URLs, paths|Destination domain only; never URL paths'

check_absent \
  "unimplemented third-party app API integration examples" \
  'OpenAI / ChatGPT|Anthropic / Claude|Google Gemini|Microsoft 365 / SharePoint|Grammarly, Notion, Confluence|GitHub Copilot, GitLab Duo|third-party applications via their APIs'

check_absent \
  "absolute Mode 3 no-disk/immediate-discard claim" \
  'never persisted to disk|persisted to disk|discarded immediately|immediately discarded'

check_absent \
  "overbroad dependency-audit cadence claim" \
  'automated dependency auditing on every code change|Automated in CI on every commit|`npm audit` on every build|dependency auditing.*every commit|dependency auditing.*every code change'

# ── required files (structural checks) ───────────────────────────────────────

check_present "claims registry" "$REGISTRY"
check_present "SOC 2 compliance page" "$CONTENT_DIR/compliance/soc2.md"
check_present "privacy data collection page" "$CONTENT_DIR/privacy/data-collection.md"
check_present "privacy data retention page" "$CONTENT_DIR/privacy/data-retention.md"
check_present "legal privacy policy" "$CONTENT_DIR/legal/privacy-policy.md"
check_present "legal terms of service" "$CONTENT_DIR/legal/terms-of-service.md"

# Root protocol files — all public repos must carry these; they must not be absent.
check_present "root README" "$ROOT_DIR/README.md"
check_present "root LICENSE" "$ROOT_DIR/LICENSE"
check_present "root CONTRIBUTING" "$ROOT_DIR/CONTRIBUTING.md"
check_present "root SECURITY" "$ROOT_DIR/SECURITY.md"

# ── claims registry validation ────────────────────────────────────────────────
# Verify registry freshness, required material claim registrations, and every
# "not-available" claim in the registry. jq is required so CI cannot silently
# skip deep claim validation.
if command -v jq &>/dev/null; then
  registry_audit_run=$(jq -r '.audit_run // empty' "$REGISTRY")
  if [[ -z "$registry_audit_run" ]]; then
    record_failure "claims registry is missing .audit_run — it is the single source of truth for the public audit baseline"
  elif [[ "$registry_audit_run" != "$AUDIT_RUN" ]]; then
    # Only reachable when PUBLIC_DOCS_EXPECTED_AUDIT_RUN overrides the registry.
    record_failure "claims registry audit_run ($registry_audit_run) disagrees with the enforced baseline ($AUDIT_RUN)"
  fi

  require_claim_registration() {
    local claim_id="$1"
    local audit_ref="$2"
    local source_file="$3"
    if ! jq -e --arg id "$claim_id" --arg ref "$audit_ref" --arg src "$source_file" '
      .claims[]
      | select(.id == $id)
      | select(.release_status == "active")
      | select((.audit_refs // []) | index($ref))
      | select((.source_files // []) | index($src))
      | select((.evidence // []) | length > 0)
    ' "$REGISTRY" >/dev/null; then
      printf '\nERROR: claims registry missing active evidence registration: %s (%s, %s)\n' "$claim_id" "$audit_ref" "$source_file" >&2
      failures=$((failures + 1))
    fi
  }

  require_claim_registration "CLM-010" "PUBDOC-1" "content/privacy/data-collection.md"
  require_claim_registration "CLM-011" "PUBDOC-2" "content/privacy/index.md"
  require_claim_registration "CLM-011" "AGT-LOCAL-2" "content/legal/privacy-policy.md"
  require_claim_registration "CLM-012" "PUBDOC-3" "content/compliance/soc2.md"
  require_claim_registration "CLM-012" "PDC5" "content/security/index.md"

  while IFS=$'\t' read -r claim_id source_file; do
    validate_repo_relative_path "$claim_id" "public-docs" "$source_file" "source_file"
  done < <(jq -r '.claims[] | .id as $id | (.source_files // [])[] | [$id, .] | @tsv' "$REGISTRY")

  while IFS=$'\t' read -r claim_id release_status evidence_count audit_ref_count; do
    if [[ "$release_status" == "active" || "$release_status" == "in-progress" ]]; then
      if (( evidence_count == 0 )); then
        record_failure "active public claim $claim_id has no registry evidence"
      fi
      if (( audit_ref_count == 0 )); then
        record_failure "active public claim $claim_id has no audit_refs traceability"
      fi
    fi
  done < <(jq -r '.claims[] | [.id, (.release_status // ""), ((.evidence // []) | length), ((.audit_refs // []) | length)] | @tsv' "$REGISTRY")

  while IFS=$'\t' read -r claim_id evidence; do
    validate_evidence_path "$claim_id" "$evidence"
  done < <(jq -r '.claims[] | .id as $id | (.evidence // [])[] | [$id, .] | @tsv' "$REGISTRY")

  # A "not-available" claim names a feature that is not shipped, so the summary
  # the registry registers for it must not appear on any published page. The
  # match is that whole summary as a fixed string, case-insensitively — the
  # phrase, which is what the registry registers and all it registers. The
  # registry JSON is excluded because it carries every summary by definition.
  # Other wordings of the same unshipped feature are the claim's own
  # forbidden_phrases, enforced below; a page that names the feature in passing
  # ("a personal dashboard is planned") matches neither and is not refused.
  while IFS= read -r claim_id; do
    summary=$(jq -r --arg id "$claim_id" \
      '.claims[] | select(.id == $id) | .summary' "$REGISTRY")
    [[ -n "$summary" ]] || continue
    while IFS= read -r hit; do
      [[ -n "$hit" ]] || continue
      hit="${hit#"$ROOT_DIR"/}"
      record_failure "not-available claim $claim_id appears on the public surface at $hit: \"$summary\" — a not-available claim's registered summary is forbidden under content/"
    done < <(grep -RIn -iF --exclude="claims-registry.json" -- "$summary" "$CONTENT_DIR" | cut -d: -f1,2 || true)
  done < <(jq -r '.claims[] | select(.release_status == "not-available") | .id' "$REGISTRY")

  # A claim may carry forbidden_phrases: other wordings of it that must never be
  # published, kept next to the claim they belong to rather than in a check_absent
  # deny-list here (public-docs#53). Each is matched as the summary is above — a
  # fixed string, case-insensitively, under content/ with the registry JSON
  # excluded — and on every claim that carries the field, whatever its status.
  # A blank entry would match every line, so it is refused rather than skipped.
  while IFS= read -r claim_id; do
    record_failure "claims registry forbidden_phrases for $claim_id must be an array of non-blank strings"
  done < <(jq -r '
    .claims[]
    | select(has("forbidden_phrases"))
    | select((.forbidden_phrases | type) != "array"
        or any(.forbidden_phrases[]; type != "string" or test("^\\s*$")))
    | .id
  ' "$REGISTRY")

  while IFS=$'\t' read -r claim_id phrase; do
    while IFS= read -r hit; do
      [[ -n "$hit" ]] || continue
      hit="${hit#"$ROOT_DIR"/}"
      record_failure "claim $claim_id forbidden phrase appears on the public surface at $hit: \"$phrase\" — a claim's forbidden_phrases are forbidden under content/"
    done < <(grep -RIn -iF --exclude="claims-registry.json" -- "$phrase" "$CONTENT_DIR" | cut -d: -f1,2 || true)
  done < <(jq -r '
    .claims[]
    | .id as $id
    | select((.forbidden_phrases | type) == "array")
    | .forbidden_phrases[]
    | select(type == "string" and (test("^\\s*$") | not))
    | [$id, .] | @tsv
  ' "$REGISTRY")
  printf 'claims registry validation: OK (%s)\n' "$REGISTRY"
else
  printf '\nERROR: jq is required for claims registry validation\n' >&2
  failures=$((failures + 1))
fi

# ── result ────────────────────────────────────────────────────────────────────

if (( failures > 0 )); then
  printf '\npublic-docs claim check failed with %d issue group(s)\n' "$failures" >&2
  exit 1
fi

printf 'public-docs claim checks passed\n'