-- Release specific references to files in this folder
-- This file is automatically executed from the /release/_release.sql file
-- Tables (order: lookups first, then invoices, then lines)
prompt @../tables/invg_clients.sql
@../tables/invg_clients.sql
prompt @../tables/invg_businesses.sql
@../tables/invg_businesses.sql
prompt @../tables/invg_bank_details.sql
@../tables/invg_bank_details.sql
prompt @../tables/invg_invoices.sql
@../tables/invg_invoices.sql
prompt @../tables/invg_invoice_lines.sql
@../tables/invg_invoice_lines.sql
