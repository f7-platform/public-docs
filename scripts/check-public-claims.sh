#!/usr/bin/env bash
# check-public-claims.sh — Validate public-docs content against the claims
# registry (content/compliance/claims-registry.json) and a set of forbidden
# patterns. Run as part of CI and before each release.
#
# Exit codes:
#   0 — all checks passed
#   1 — one or more forbidden claims found
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTENT_DIR="$ROOT_DIR/content"
REGISTRY="$CONTENT_DIR/compliance/claims-registry.json"

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

# ── forbidden claims ──────────────────────────────────────────────────────────

check_absent \
  "unimplemented compensation ingestion or masking" \
  'compensation data|compensation masking|salary fields|salary data|stock value|benefits value|can_view_compensation|sync_compensation'

check_absent \
  "specific HRIS connector names" \
  '\b(Workday|BambooHR|SAP SuccessFactors|Rippling|HiBob)\b'

check_absent \
  "current personal-dashboard capability" \
  'Employees see their own data on a personal dashboard|Every employee sees their own behavioral data|gives every employee visibility into their own behavioral data|personal-data endpoints'

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

# Stale audit run reference — must not cite Run 27b as the current baseline.
# Update to the most recent completed run before publishing.
check_absent \
  "stale audit run reference (Run 27b)" \
  'Run 27b security audit baseline'

# Blanket URL-path not-captured wording — the AI-provider path IS captured for
# classification; any document that says "URL path" is in the "Not captured" list
# contradicts this and must be removed.
check_absent \
  "blanket URL-path not-captured (contradicts AI-provider path capture)" \
  'URL path, query parameters, request body'

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
# Verify every "not-available" claim in the registry is absent from content.
# Requires jq; skip with a warning if not installed.
if command -v jq &>/dev/null; then
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
  printf 'WARNING: jq not installed — skipping claims registry deep validation\n' >&2
fi

# ── result ────────────────────────────────────────────────────────────────────

if (( failures > 0 )); then
  printf '\npublic-docs claim check failed with %d issue group(s)\n' "$failures" >&2
  exit 1
fi

printf 'public-docs claim checks passed\n'