# Release Evidence Pack — Schema & License Contract Parity
<!--
  Template: fill one copy per fseven-schemas release or schema migration.
  File as: docs/releases/evidence/schema-license-parity-{YYYYMMDD}.md
-->

## Release Metadata

| Field | Value |
|---|---|
| Review date | YYYY-MM-DD |
| fseven-schemas tag | _(git tag or commit SHA)_ |
| fseven-controller tag | _(git tag or commit SHA)_ |
| Reviewer | _(name)_ |

## Schema Parity Checks

### 1. Proto/SQL Alignment

- [ ] All `.proto` message fields in `fseven-schemas/proto/` have a corresponding column in `schema.sql`
- [ ] No orphaned SQL columns (columns with no proto representation where one is expected)
- [ ] Migration scripts in `fseven-controller/migrations/` are up-to-date

### 2. License Metadata

- [ ] `fseven-schemas/LICENSE` is present and up to date
- [ ] SPDX license header in `schema.sql` header comment (if applicable)
- [ ] Any new third-party schemas or reference data have documented licenses in `SCHEMA-REFERENCE.md`

### 3. Contract Files

Review `fseven-schemas/contracts/` to confirm each contract file is consistent with:

| Contract file | Consistent with schema.sql? | Consistent with proto? | Notes |
|---|---|---|---|
| _(list each file)_ | ✅ / ❌ | ✅ / ❌ | |

### 4. ER Relationships

- [ ] `ER-RELATIONSHIPS.md` reflects current schema (no stale tables or foreign keys)

## License Compliance

- [ ] `cargo deny check licenses` passes on `fseven-controller` and `fseven-agent`
- [ ] Any `deny.toml` exceptions are documented and intentional

## Evidence Signoff

| Reviewer | Date | Notes |
|---|---|---|
| _(name)_ | YYYY-MM-DD | |
