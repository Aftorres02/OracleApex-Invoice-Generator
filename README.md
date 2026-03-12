# Oracle APEX Invoice Generator

An Oracle APEX application (App 600) for generating and managing invoices, including clients, businesses, bank details, and printable invoice output.

## Project Structure

```
├── apex/                   APEX application exports
│   ├── f600.sql            Single-file export (for deployment)
│   └── f600/               YAML split export (for version control)
├── data/                   Re-runnable seed and test data scripts
├── packages/               PL/SQL package specs (.pks) and bodies (.pkb)
├── release/                Release manifest and deployment scripts
├── scripts/                Utility scripts (export, install, disable)
├── tables/                 Table DDL scripts
├── triggers/               Compound triggers (audit columns)
├── views/                  View definitions
└── www/src/                Frontend assets (CSS, JS, images)
```

## Database Objects

| Type | Objects |
|------|---------|
| Tables | `invg_clients`, `invg_businesses`, `invg_bank_details`, `invg_invoices`, `invg_invoice_lines` |
| Views | `invg_invoices_vw`, `invg_invoice_lines_vw` |
| Packages | `invg_invoice_api` |
| Triggers | Compound audit triggers for each table |

## Quick Start

All commands are run in **SQLcl** connected to the target schema.

### Export the APEX App

```sql
@scripts/apex_export.sql
```

Produces `apex/f600.sql` (single file) and `apex/f600/` (YAML split).

### Run a Full Release

```bash
cd release
sqlcl <connection_string> @_release.sql
```

Deploys views, packages, triggers, data, and the APEX application. See [release/README.md](release/README.md) for details.

### Install Only the APEX App

```sql
@scripts/apex_install.sql <SCHEMA> <WORKSPACE>
```
