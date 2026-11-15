#!/usr/bin/env node
// Dependency-advisory gate for the deploy workflow (PB33, DEP25).
//
// Audits the whole lockfile, dev dependencies included: this site declares no
// runtime dependencies, so an audit scoped with --omit=dev had nothing to look
// at and could not fail. Every advisory at or above THRESHOLD fails the gate
// unless audit-waivers.json carries a dated, reasoned, unexpired exception for
// it. The rules for adding one are in CONTRIBUTING.md, "Dependency advisories".
//
// Advisories are counted by GHSA id, not by npm's one row per affected package,
// so one advisory reported through vue and @vue/server-renderer is one entry.
//
// Usage:
//   node scripts/check-npm-audit.mjs [--report <file>] [--waivers <file>] [--today YYYY-MM-DD]
//
//   --report   read an `npm audit --json` report from a file instead of running
//              npm audit (the fixture tests use this)
//   --waivers  exception file (default: audit-waivers.json at the repo root)
//   --today    the date expiry is judged against (default: today, UTC)
//
// Exit codes:
//   0  every advisory at or above the threshold has a valid exception
//   1  an advisory has no exception, or an exception is expired, stale, or
//      malformed
//   2  npm audit produced no usable report (the registry did not answer, or the
//      output is not an audit report); this is never a pass

import { spawnSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const RANK = { info: 0, low: 1, moderate: 2, high: 3, critical: 4 };
const THRESHOLD = 'moderate';
const MAX_WAIVER_DAYS = 90;
const DAY_MS = 24 * 60 * 60 * 1000;

const EXIT_POLICY = 1;
const EXIT_NO_REPORT = 2;

const repoRoot = join(dirname(fileURLToPath(import.meta.url)), '..');

function parseArgs(argv) {
  const args = { report: null, waivers: join(repoRoot, 'audit-waivers.json'), today: null };
  for (let i = 0; i < argv.length; i += 1) {
    const flag = argv[i];
    const value = argv[i + 1];
    if (!['--report', '--waivers', '--today'].includes(flag) || value === undefined) {
      console.error(`check-npm-audit: unknown or incomplete argument: ${flag}`);
      process.exit(EXIT_POLICY);
    }
    args[flag.slice(2)] = value;
    i += 1;
  }
  return args;
}

function noReport(reason) {
  console.error(`check-npm-audit: NO AUDIT REPORT: ${reason}`);
  console.error('check-npm-audit: the dependency audit did not run, so this is not a pass.');
  process.exit(EXIT_NO_REPORT);
}

function readReport(reportPath) {
  let text;
  if (reportPath) {
    try {
      text = readFileSync(reportPath, 'utf8');
    } catch (err) {
      noReport(`cannot read ${reportPath}: ${err.message}`);
    }
  } else {
    // --include=dev overrides any omit=dev the environment sets: the dev tree
    // is everything this site is built with.
    // On Windows npm is a .cmd shim, which only a shell can start.
    const command = ['npm', 'audit', '--json', '--include=dev'];
    const options = { cwd: repoRoot, encoding: 'utf8', maxBuffer: 64 * 1024 * 1024 };
    const run =
      process.platform === 'win32'
        ? spawnSync(command.join(' '), { ...options, shell: true })
        : spawnSync(command[0], command.slice(1), options);
    if (run.error) noReport(`could not run npm audit: ${run.error.message}`);
    text = run.stdout;
  }

  let report;
  try {
    report = JSON.parse(text);
  } catch {
    noReport('npm audit output is not JSON');
  }
  if (report && report.error) {
    const detail = report.message || report.error.summary || report.error.code || 'no detail';
    noReport(`the registry did not answer the audit: ${detail}`);
  }
  if (
    !report ||
    typeof report.vulnerabilities !== 'object' ||
    report.vulnerabilities === null ||
    typeof report.metadata?.vulnerabilities !== 'object'
  ) {
    noReport('npm audit output is not an audit report (no vulnerabilities or metadata)');
  }
  return report;
}

// One entry per advisory, keyed by GHSA id (npm's numeric source id when an
// advisory has no GHSA URL), with every package npm reports it through.
function collectAdvisories(report) {
  const advisories = new Map();
  for (const [pkg, entry] of Object.entries(report.vulnerabilities)) {
    for (const via of entry.via || []) {
      if (typeof via !== 'object' || via === null) continue;
      const ghsa = /GHSA-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}/i.exec(via.url || '');
      const id = ghsa ? ghsa[0] : `npm-${via.source}`;
      const advisory = advisories.get(id) || {
        id,
        severity: via.severity,
        title: via.title || '',
        packages: new Set(),
      };
      advisory.packages.add(via.name || pkg);
      if ((RANK[via.severity] ?? -1) > (RANK[advisory.severity] ?? -1)) advisory.severity = via.severity;
      advisories.set(id, advisory);
    }
  }
  return [...advisories.values()].sort((a, b) => a.id.localeCompare(b.id));
}

function parseDate(value) {
  if (typeof value !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(value)) return null;
  const ms = Date.parse(`${value}T00:00:00Z`);
  if (Number.isNaN(ms) || new Date(ms).toISOString().slice(0, 10) !== value) return null;
  return ms;
}

function readWaivers(waiversPath, failures) {
  let data;
  try {
    data = JSON.parse(readFileSync(waiversPath, 'utf8'));
  } catch (err) {
    failures.push(`cannot read the exception file ${waiversPath}: ${err.message}`);
    return [];
  }
  if (!Array.isArray(data.waivers)) {
    failures.push(`${waiversPath} has no "waivers" array`);
    return [];
  }

  const seen = new Set();
  const valid = [];
  for (const [index, waiver] of data.waivers.entries()) {
    const label = waiver?.id ? `exception ${waiver.id}` : `exception #${index + 1}`;
    const problems = [];
    if (typeof waiver?.id !== 'string' || !waiver.id) problems.push('no id');
    if (!(waiver?.severity in RANK)) problems.push('no valid severity');
    if (!Array.isArray(waiver?.packages) || waiver.packages.length === 0) problems.push('no packages');
    for (const field of ['reachability', 'fix']) {
      if (typeof waiver?.[field] !== 'string' || !waiver[field].trim()) problems.push(`no ${field}`);
    }
    const reviewed = parseDate(waiver?.reviewed);
    const expires = parseDate(waiver?.expires);
    if (reviewed === null) problems.push('reviewed is not a YYYY-MM-DD date');
    if (expires === null) problems.push('expires is not a YYYY-MM-DD date');
    if (reviewed !== null && expires !== null) {
      const days = (expires - reviewed) / DAY_MS;
      if (days < 0) problems.push('expires is before reviewed');
      if (days > MAX_WAIVER_DAYS) problems.push(`expires is ${days} days after reviewed (at most ${MAX_WAIVER_DAYS})`);
    }
    if (waiver?.id && seen.has(waiver.id)) problems.push('is listed twice');
    if (waiver?.id) seen.add(waiver.id);

    if (problems.length > 0) {
      failures.push(`MALFORMED: ${label}: ${problems.join('; ')}`);
    } else {
      valid.push({ ...waiver, expiresMs: expires });
    }
  }
  return valid;
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  const todayIso = args.today || new Date().toISOString().slice(0, 10);
  const today = parseDate(todayIso);
  if (today === null) {
    console.error(`check-npm-audit: --today is not a YYYY-MM-DD date: ${todayIso}`);
    process.exit(EXIT_POLICY);
  }

  const report = readReport(args.report);
  const advisories = collectAdvisories(report);
  const failures = [];
  const waivers = readWaivers(args.waivers, failures);
  const waiverById = new Map(waivers.map((w) => [w.id, w]));

  const gated = advisories.filter((a) => (RANK[a.severity] ?? RANK.critical) >= RANK[THRESHOLD]);
  const below = advisories.filter((a) => !gated.includes(a));
  const gatedIds = new Set(gated.map((a) => a.id));

  console.log(`check-npm-audit: full lockfile, threshold ${THRESHOLD}, judged on ${todayIso}`);
  for (const advisory of gated) {
    const packages = [...advisory.packages].sort().join(', ');
    const waiver = waiverById.get(advisory.id);
    let status;
    if (!waiver) {
      status = 'NOT EXCEPTED';
      failures.push(`NOT EXCEPTED: ${advisory.id} (${advisory.severity}, ${packages}) has no entry in audit-waivers.json`);
    } else if (today > waiver.expiresMs) {
      status = `EXPIRED on ${waiver.expires}`;
      failures.push(`EXPIRED: the exception for ${advisory.id} expired on ${waiver.expires}; fix the advisory or re-review the exception`);
    } else if (RANK[advisory.severity] > RANK[waiver.severity]) {
      status = `SEVERITY RAISED (excepted as ${waiver.severity})`;
      failures.push(`SEVERITY RAISED: ${advisory.id} is now ${advisory.severity}, but its exception was reviewed as ${waiver.severity}`);
    } else if ([...advisory.packages].some((p) => !waiver.packages.includes(p))) {
      status = 'NEW PACKAGES';
      failures.push(`NEW PACKAGES: ${advisory.id} now reaches ${packages}, but its exception covers ${waiver.packages.join(', ')}`);
    } else {
      status = `excepted until ${waiver.expires}: ${waiver.reachability}`;
    }
    console.log(`  ${advisory.id}  ${advisory.severity.padEnd(8)} ${packages}  ${status}`);
  }
  for (const advisory of below) {
    console.log(`  ${advisory.id}  ${advisory.severity.padEnd(8)} ${[...advisory.packages].sort().join(', ')}  below threshold`);
  }
  for (const waiver of waivers) {
    if (!gatedIds.has(waiver.id)) {
      failures.push(`STALE: the exception for ${waiver.id} matches no reported advisory at or above ${THRESHOLD}; remove it`);
    }
  }

  console.log(
    `check-npm-audit: ${gated.length} advisor${gated.length === 1 ? 'y' : 'ies'} at or above ${THRESHOLD}, ` +
      `${below.length} below, ${waivers.length} exception${waivers.length === 1 ? '' : 's'} on file`,
  );
  if (failures.length > 0) {
    for (const failure of failures) console.error(`check-npm-audit: ${failure}`);
    console.error('check-npm-audit: FAILED. See CONTRIBUTING.md, "Dependency advisories".');
    process.exit(EXIT_POLICY);
  }
  console.log('check-npm-audit: passed');
}

main();
