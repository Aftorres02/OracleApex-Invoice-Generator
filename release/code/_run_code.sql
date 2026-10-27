-- Release specific references to files in this folder
-- This file is automatically executed from the /release/_release.sql file

-- Drop old and current objects so creates are re-runnable
prompt @drop_objects.sql
@code/drop_objects.sql

-- Tables (order: lookups first, then invoices, then lines)
prompt @../tables/invg_recipients.sql
@../tables/invg_recipients.sql
prompt @../tables/invg_senders.sql
@../tables/invg_senders.sql
prompt @../tables/invg_bank_details.sql
@../tables/invg_bank_details.sql
prompt @../tables/invg_invoices.sql
@../tables/invg_invoices.sql
prompt @../tables/invg_invoice_lines.sql
@../tables/invg_invoice_lines.sql
