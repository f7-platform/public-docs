#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONTENT_DIR="$ROOT_DIR/content"

failures=0

check_absent() {
  local label="$1"
  local pattern="$2"

  if grep -RInE -- "$pattern" "$CONTENT_DIR"; then
    printf '\nERROR: forbidden public-docs claim found: %s\n' "$label" >&2
    failures=$((failures + 1))
  fi
}

check_absent \
  "unimplemented compensation ingestion or masking" \
  'compensation data|compensation masking|salary fields|salary data|stock value|benefits value|can_view_compensation|sync_compensation'

check_absent \
  "specific HRIS connector names" \
  '\b(Workday|BambooHR|SAP SuccessFactors|Rippling|HiBob)\b'

check_absent \
  "current personal-dashboard capability" \
  'Employees see their own data on a personal dashboard|Every employee sees their own behavioral data|gives every employee visibility into their own behavioral data|personal-data endpoints'

if (( failures > 0 )); then
  printf '\npublic-docs claim check failed with %d issue group(s)\n' "$failures" >&2
  exit 1
fi

printf 'public-docs claim checks passed\n'