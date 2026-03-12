# Release

## Execution Order

The release is driven by `_release.sql`. Run it from the `release/` folder in SQLcl:

```bash
cd release
sqlcl <connection_string> @_release.sql
```

It executes in the following order:

| Step | File | Description |
|------|------|-------------|
| 1 | Header checks | Validates `user = DEV_2`, sets up spool log |
| 2 | `code/_run_code.sql` | Tables DDL in dependency order (currently commented out in `_release.sql`) |
| 3 | `all_views.sql` | Views: `invg_invoices_vw`, `invg_invoice_lines_vw` |
| 4 | `all_packages.sql` | Package spec + body: `invg_invoice_api` |
| 5 | `all_triggers.sql` | Compound triggers for all `invg_` tables |
| 6 | Invalid objects check | Queries `user_objects` for anything invalid |
| 7 | `all_data.sql` | Deletes existing data, loads dummy/seed data |
| 8 | `dbms_utility.compile_schema` | Recompiles invalid objects |
| 9 | `all_apex.sql` | Installs APEX app 600 from `apex/f600.sql` |

The script uses `whenever sqlerror exit sql.sqlcode` -- the first SQL error stops the release.

A log file is automatically spooled with the naming pattern `release_log_<service>_<timestamp>.log`.

## Files

| File | Description |
|------|-------------|
| `_release.sql` | Main release entry point |
| `all_views.sql` | References all view scripts in `views/` |
| `all_packages.sql` | References all `.pks` then `.pkb` in `packages/` |
| `all_triggers.sql` | References all trigger scripts in `triggers/` |
| `all_data.sql` | References data scripts in `data/` (order matters) |
| `all_apex.sql` | Calls `scripts/apex_install.sql` for app 600 |
| `load_env_vars.sql` | Environment variable defines (not currently used by `_release.sql`) |
| `code/_run_code.sql` | Release-specific DDL: creates tables in dependency order |
| `code/backout.sql` | Placeholder for rollback scripts |

## First-Time Setup

For a fresh schema, uncomment the `@code/_run_code.sql` line in `_release.sql` so the tables are created before views, packages, and triggers run.

## Adding New Objects

When adding new database objects, update the corresponding `all_*.sql` file:

- New view -> add to `all_views.sql`
- New package -> add `.pks` and `.pkb` to `all_packages.sql`
- New trigger -> add to `all_triggers.sql`
- New seed data -> add to `all_data.sql` (order matters for FK dependencies)
