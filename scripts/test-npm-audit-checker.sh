#!/usr/bin/env bash
# Fixture tests for scripts/check-npm-audit.mjs: each case feeds the checker a
# canned `npm audit --json` report and exception file and asserts the exit code
# and the line that explains it.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHECKER="$REPO_ROOT/scripts/check-npm-audit.mjs"
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

TODAY="2026-11-01"
passed=0

# advisory <ghsa> <severity> <package> — one `via` object as npm audit writes it.
advisory() {
  printf '{"source":1,"name":"%s","dependency":"%s","title":"fixture advisory","url":"https://github.com/advisories/%s","severity":"%s","range":"<9.9.9"}' \
    "$3" "$3" "$1" "$2"
}

# write_report <file> <vulnerabilities-object-json>
write_report() {
  printf '{"auditReportVersion":2,"vulnerabilities":%s,"metadata":{"vulnerabilities":{"info":0,"low":0,"moderate":0,"high":0,"critical":0,"total":0},"dependencies":{"prod":1,"dev":10,"optional":0,"peer":0,"peerOptional":0,"total":10}}}\n' \
    "$2" >"$1"
}

# write_waivers <file> [entry-json...]
write_waivers() {
  local file="$1"
  shift
  local IFS=,
  printf '{"waivers":[%s]}\n' "$*" >"$file"
}

# waiver <ghsa> <severity> <packages-json-array> <reviewed> <expires>
waiver() {
  printf '{"id":"%s","severity":"%s","packages":%s,"reachability":"fixture: not reachable","fix":"fixture: none yet","reviewed":"%s","expires":"%s"}' \
    "$1" "$2" "$3" "$4" "$5"
}

# expect <name> <exit-code> <text-the-output-must-contain> <report> <waivers>
expect() {
  local name="$1" want="$2" text="$3" report="$4" waivers="$5" got=0 output
  output="$(node "$CHECKER" --report "$report" --waivers "$waivers" --today "$TODAY" 2>&1)" || got=$?
  if [[ "$got" != "$want" ]]; then
    printf 'FAIL: %s: exit %s, expected %s\n%s\n' "$name" "$got" "$want" "$output" >&2
    exit 1
  fi
  if [[ "$output" != *"$text"* ]]; then
    printf 'FAIL: %s: output does not contain "%s"\n%s\n' "$name" "$text" "$output" >&2
    exit 1
  fi
  printf 'ok: %s\n' "$name"
  passed=$((passed + 1))
}

report="$TEMP_DIR/report.json"
waivers="$TEMP_DIR/waivers.json"

# ── the five cases the gate is built on ──────────────────────────────────────
write_report "$report" '{}'
write_waivers "$waivers"
expect "clean report passes" 0 "check-npm-audit: passed" "$report" "$waivers"

write_report "$report" "{\"pkg-a\":{\"name\":\"pkg-a\",\"severity\":\"moderate\",\"via\":[$(advisory GHSA-aaaa-bbbb-cccc moderate pkg-a)]}}"
write_waivers "$waivers"
expect "moderate advisory with no exception fails and names it" 1 "NOT EXCEPTED: GHSA-aaaa-bbbb-cccc" "$report" "$waivers"

write_waivers "$waivers" "$(waiver GHSA-aaaa-bbbb-cccc moderate '["pkg-a"]' 2026-08-05 2026-10-31)"
expect "expired exception fails" 1 "EXPIRED: the exception for GHSA-aaaa-bbbb-cccc" "$report" "$waivers"

write_report "$report" '{}'
write_waivers "$waivers" "$(waiver GHSA-aaaa-bbbb-cccc moderate '["pkg-a"]' 2026-10-15 2027-01-10)"
expect "exception matching no advisory fails as stale" 1 "STALE: the exception for GHSA-aaaa-bbbb-cccc" "$report" "$waivers"

printf '{"message":"request to https://registry.npmjs.org/-/npm/v1/security/advisories/bulk failed, reason: getaddrinfo ENOTFOUND registry.npmjs.org","error":{"summary":"","detail":""}}\n' >"$report"
write_waivers "$waivers"
expect "registry error is not a pass" 2 "NO AUDIT REPORT: the registry did not answer" "$report" "$waivers"

# ── the rules around them ────────────────────────────────────────────────────
printf 'npm error audit endpoint returned an error\n' >"$report"
expect "output that is not JSON is not a pass" 2 "NO AUDIT REPORT: npm audit output is not JSON" "$report" "$waivers"

printf '{"auditReportVersion":2}\n' >"$report"
expect "JSON that is not an audit report is not a pass" 2 "NO AUDIT REPORT: npm audit output is not an audit report" "$report" "$waivers"

write_report "$report" "{\"pkg-a\":{\"name\":\"pkg-a\",\"severity\":\"high\",\"via\":[$(advisory GHSA-aaaa-bbbb-cccc high pkg-a)]}}"
write_waivers "$waivers" "$(waiver GHSA-aaaa-bbbb-cccc high '["pkg-a"]' 2026-10-15 2027-01-10)"
expect "unexpired, matching exception passes" 0 "excepted until 2027-01-10" "$report" "$waivers"

write_waivers "$waivers" "$(waiver GHSA-aaaa-bbbb-cccc high '["pkg-a"]' 2026-10-15 2026-11-01)"
expect "exception is valid through its expiry date" 0 "check-npm-audit: passed" "$report" "$waivers"

write_waivers "$waivers" "$(waiver GHSA-aaaa-bbbb-cccc moderate '["pkg-a"]' 2026-10-15 2027-01-10)"
expect "advisory rescored above its exception fails" 1 "SEVERITY RAISED: GHSA-aaaa-bbbb-cccc" "$report" "$waivers"

write_report "$report" "{\"pkg-a\":{\"name\":\"pkg-a\",\"severity\":\"high\",\"via\":[$(advisory GHSA-aaaa-bbbb-cccc high pkg-a)]},\"pkg-b\":{\"name\":\"pkg-b\",\"severity\":\"high\",\"via\":[$(advisory GHSA-aaaa-bbbb-cccc high pkg-b)]}}"
write_waivers "$waivers" "$(waiver GHSA-aaaa-bbbb-cccc high '["pkg-a","pkg-b"]' 2026-10-15 2027-01-10)"
expect "one advisory through two packages counts once" 0 "1 advisory at or above moderate" "$report" "$waivers"

write_waivers "$waivers" "$(waiver GHSA-aaaa-bbbb-cccc high '["pkg-a"]' 2026-10-15 2027-01-10)"
expect "advisory reaching a package its exception does not cover fails" 1 "NEW PACKAGES: GHSA-aaaa-bbbb-cccc" "$report" "$waivers"

write_waivers "$waivers" "$(waiver GHSA-aaaa-bbbb-cccc high '["pkg-a","pkg-b"]' 2026-10-15 2027-01-14)"
expect "exception longer than 90 days fails" 1 "MALFORMED: exception GHSA-aaaa-bbbb-cccc" "$report" "$waivers"

write_waivers "$waivers" '{"id":"GHSA-aaaa-bbbb-cccc","severity":"high","packages":["pkg-a","pkg-b"],"reviewed":"2026-10-15","expires":"2027-01-10"}'
expect "exception without its reasons fails" 1 "no reachability; no fix" "$report" "$waivers"

write_report "$report" "{\"pkg-a\":{\"name\":\"pkg-a\",\"severity\":\"low\",\"via\":[$(advisory GHSA-aaaa-bbbb-cccc low pkg-a)]}}"
write_waivers "$waivers"
expect "advisory below moderate passes without an exception" 0 "below threshold" "$report" "$waivers"

write_waivers "$waivers" "$(waiver GHSA-aaaa-bbbb-cccc low '["pkg-a"]' 2026-10-15 2027-01-10)"
expect "exception for an advisory below moderate is stale" 1 "STALE: the exception for GHSA-aaaa-bbbb-cccc" "$report" "$waivers"

printf 'npm audit checker fixture tests passed (%d cases)\n' "$passed"
