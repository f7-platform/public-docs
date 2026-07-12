#!/usr/bin/env bash
# bump-audit-run.sh — Bump the public audit-run baseline.
#
# The baseline is declared in ONE place (content/compliance/claims-registry.json
# → .audit_run). This script updates that source and rewrites every derived
# "Run N" mention on the public surface, then re-runs the claim checks. It
# exists so the baseline can never again drift between the registry, the
# checker, and the docs (PB12 — the root cause of the stale-baseline PB2).
#
# Usage: scripts/bump-audit-run.sh <run>      e.g. scripts/bump-audit-run.sh 37
#        npm run bump:audit-run -- 37
set -euo pipefail

NEW_RUN="${1:-}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REGISTRY="$ROOT_DIR/content/compliance/claims-registry.json"

if [[ -z "$NEW_RUN" || ! "$NEW_RUN" =~ ^[0-9]+[a-z]?$ ]]; then
  printf 'usage: %s <run>   (e.g. 37, or 27b)\n' "${BASH_SOURCE[0]##*/}" >&2
  exit 2
fi

if ! command -v jq &>/dev/null; then
  printf 'ERROR: jq is required\n' >&2
  exit 1
fi

CURRENT_RUN="$(jq -r '.audit_run // empty' "$REGISTRY")"
if [[ -z "$CURRENT_RUN" ]]; then
  printf 'ERROR: %s has no .audit_run to bump\n' "$REGISTRY" >&2
  exit 1
fi

if [[ "$CURRENT_RUN" == "$NEW_RUN" ]]; then
  printf 'audit-run baseline is already Run %s — nothing to do\n' "$NEW_RUN"
  exit 0
fi

# 1. The single source of truth. Edited in place (not re-serialised) so the
#    registry's formatting and review history stay intact.
if [[ "$NEW_RUN" =~ ^[0-9]+$ ]]; then
  JSON_VALUE="$NEW_RUN"
else
  JSON_VALUE="\"$NEW_RUN\""
fi
TODAY="$(date -u +%Y-%m-%d)"
perl -pi -e "s/^(\s*\"audit_run\":\s*).*?(,?)\$/\${1}$JSON_VALUE\${2}/" "$REGISTRY"
perl -pi -e "s/^(\s*\"updated\":\s*\").*?(\",?)\$/\${1}$TODAY\${2}/" "$REGISTRY"

# 2. Every derived public mention. Contributor docs (CLAUDE.md,
#    copilot-instructions.md) intentionally carry no run number — they point at
#    the registry — so only published content needs rewriting.
while IFS= read -r file; do
  perl -pi -e "s/\bRun \Q$CURRENT_RUN\E\b/Run $NEW_RUN/g" "$file"
done < <(find "$ROOT_DIR/content" -type f -name '*.md')

# 3. The live [Unreleased] changelog section describes the pending release, so
#    it must state the new baseline. Released sections are historical record and
#    are left untouched.
if [[ -f "$ROOT_DIR/CHANGELOG.md" ]]; then
  perl -pi -e "
    if (/^## \[Unreleased\]/) { \$unreleased = 1 }
    elsif (/^## /)            { \$unreleased = 0 }
    s/\bRun \Q$CURRENT_RUN\E\b/Run $NEW_RUN/g if \$unreleased;
  " "$ROOT_DIR/CHANGELOG.md"
fi

printf 'audit-run baseline: Run %s → Run %s\n\n' "$CURRENT_RUN" "$NEW_RUN"
git -C "$ROOT_DIR" diff --name-only | sed 's/^/  updated: /'

printf '\nAdd a CHANGELOG.md [Unreleased] entry describing the bump, then commit.\n'
printf 'Verifying...\n\n'
exec "$ROOT_DIR/scripts/check-public-claims.sh"
