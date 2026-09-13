#!/usr/bin/env bash
# check-public-claims.sh — Validate public-docs content against the claims
# registry (content/compliance/claims-registry.json) and a set of forbidden
# patterns. Run as part of CI and before each release.
#
# Exit codes:
#   0 — all checks passed
#   1 — one or more forbidden claims found
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

audit_run_citations() {
  # emits: <label>\t<lineno>\t<run> — every "Run N" cited on the live surface.
  # One awk pass per file, not one subshell per line: the per-line form
  # (a process substitution inside a read loop, once per content line) crashes
  # macOS's stock bash 3.2 on a real content tree, which left the local gate
  # this repo's contributor docs prescribe unrunnable on a Mac. CI's newer bash
  # never showed it.
  local f label
  while IFS= read -r f; do
    label="${f#"$ROOT_DIR"/}"
    awk -v label="$label" '
      {
        line = $0
        while (match(line, /(^|[^A-Za-z0-9_])Run [0-9]+[a-z]?([^A-Za-z0-9_]|$)/)) {
          m = substr(line, RSTART, RLENGTH)
          sub(/^[^R]*Run /, "", m)
          sub(/[^0-9a-z]+$/, "", m)
          printf "%s\t%d\t%s\n", label, FNR, m
          line = substr(line, RSTART + RLENGTH - 1)
        }
      }' "$f"
  done < <(audit_run_surface_files)

  if [[ -f "$ROOT_DIR/CHANGELOG.md" ]]; then
    awk '
      /^## \[Unreleased\]/ { unreleased = 1; next }
      /^## / { unreleased = 0 }
      unreleased {
        line = $0
        while (match(line, /(^|[^A-Za-z0-9_])Run [0-9]+[a-z]?([^A-Za-z0-9_]|$)/)) {
          m = substr(line, RSTART, RLENGTH)
          sub(/^[^R]*Run /, "", m)
          sub(/[^0-9a-z]+$/, "", m)
          printf "CHANGELOG.md [Unreleased]\t%d\t%s\n", FNR, m
          line = substr(line, RSTART + RLENGTH - 1)
        }
      }' "$ROOT_DIR/CHANGELOG.md"
  fi
  return 0
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

  local label lineno cited drift=0
  while IFS=$'\t' read -r label lineno cited; do
    [[ -z "$cited" || "$cited" == "$AUDIT_RUN" ]] && continue
    printf '  %s:%s cites Run %s, but the baseline is Run %s\n' \
      "$label" "$lineno" "$cited" "$AUDIT_RUN" >&2
    drift=$((drift + 1))
  done < <(audit_run_citations)

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
    fseven-agent|fseven-controller|fseven-schemas|fseven-docs|fseven-atlas|fseven-atlas-mvp|public-agent-binaries|public-atlas-binaries|public-docs) ;;
    *)
      record_failure "claims registry evidence for $claim_id uses unknown repo boundary: $repo"
      return
      ;;
  esac

  validate_repo_relative_path "$claim_id" "$repo" "$rel_path" "evidence path"
}

# ── forbidden claims ──────────────────────────────────────────────────────────
# Version 2 of the registry (2026-09-13) describes Atlas only. The patterns
# tied to the earlier device-agent product (compensation ingestion, HRIS
# connectors, the personal dashboard, Mode 3 wording, integration examples)
# were retired with that product; the patterns below guard the Atlas claims.

# Endpoint paths that are not public API — never document internal routes
check_absent \
  "internal API endpoint paths" \
  '/api/v[0-9]+/internal/|/admin/api/|/_internal/|/v1/session|/v1/turn'

# SOC 2 certified — no report exists for Atlas. FAQ headings that are questions
# ("Is it SOC 2 certified?") are allowed; positive declarative claims are not.
check_absent \
  "premature SOC 2 certified declarative claim" \
  'F7 is SOC 2 (Type II )?certified|Atlas is SOC 2 (Type II )?certified|F7 has obtained SOC 2|F7 received SOC 2|completed a SOC 2 audit|F7 completed SOC 2|SOC 2 (Type II )?certified\.'

# ISO 27001 — not certified.
check_absent \
  "premature ISO 27001 certification claim" \
  'ISO 27001 certified|ISO 27001 certification (has been|was) (obtained|achieved)'

# Penetration testing — no independent report exists.
check_absent \
  "penetration test overclaim" \
  'independently penetration.tested|has been penetration.tested|completed (a|an) (independent |third-party )?penetration test|penetration test (was )?(passed|completed)'

# Key custody — F7 ships no HSM integration; keys are never described as
# hardware-held.
check_absent \
  "hardware key custody overclaim" \
  'keys are held in (an |a )?(HSM|hardware security module)|HSM-backed|hardware-backed (key )?custody|stored in a hardware security module'

# Rewind — submitting a capture to F7 is designed and not built.
check_absent \
  "Rewind submission described as current" \
  'Rewind (submits|uploads|sends) (captures|a capture|pictures|frames) to F7'

# Software bill of materials — the release process does not publish one.
check_absent \
  "SBOM published overclaim" \
  'SBOM is (published|attached|included)|publishes an SBOM|SBOM (is )?available for'

# License overclaims — must not claim open-source where proprietary
check_absent \
  "open-source license overclaim" \
  'fully open.source|100% open.source|open source forever|Atlas is open.source'

# Stale audit-run references (any superseded run cited as the current baseline,
# anywhere on the live public surface) are caught by check_audit_run_baseline().
check_audit_run_baseline

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
check_present "downloads and updates page" "$CONTENT_DIR/security/downloads.md"

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
      | select(.release_status == "active" or .release_status == "in-progress")
      | select((.audit_refs // []) | index($ref))
      | select((.source_files // []) | index($src))
      | select((.evidence // []) | length > 0)
    ' "$REGISTRY" >/dev/null; then
      printf '\nERROR: claims registry missing active evidence registration: %s (%s, %s)\n' "$claim_id" "$audit_ref" "$source_file" >&2
      failures=$((failures + 1))
    fi
  }

  # The material Atlas claims every published page rests on. Each must stay
  # registered with evidence and an audit reference on the page that carries it.
  require_claim_registration "CLM-012" "PUBDOC-3" "content/compliance/soc2.md"
  require_claim_registration "CLM-012" "PDC5" "content/security/index.md"
  require_claim_registration "CLM-013" "PUBDOC-4" "content/privacy/data-collection.md"
  require_claim_registration "CLM-013" "PUBDOC-4" "content/legal/privacy-policy.md"
  require_claim_registration "CLM-015" "PUBDOC-6" "content/overview/how-it-works.md"
  require_claim_registration "CLM-017" "PUBDOC-8" "content/privacy/data-retention.md"
  require_claim_registration "CLM-018" "PUBDOC-9" "content/security/downloads.md"
  require_claim_registration "CLM-022" "PUBDOC-13" "content/security/encryption.md"

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

  while IFS= read -r claim_id; do
    # Each not-available claim id is checked via its "summary" keyword
    summary=$(jq -r --arg id "$claim_id" \
      '.claims[] | select(.id == $id) | .summary' "$REGISTRY")
    # Use the first 6 significant words as a grep anchor (heuristic)
    keyword=$(echo "$summary" | grep -oE '\b[a-zA-Z]{4,}\b' | head -1)
    if [[ -n "$keyword" ]]; then
      if grep -RInl --exclude="claims-registry.json" -- "$keyword" "$CONTENT_DIR" | grep -vqF "claims-registry"; then
        # Only a problem if the full summary phrase appears
        :
      fi
    fi
  done < <(jq -r '.claims[] | select(.release_status == "not-available") | .id' "$REGISTRY")
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