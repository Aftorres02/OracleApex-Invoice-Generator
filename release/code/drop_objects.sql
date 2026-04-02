-- =============================================================================
-- drop_objects.sql - Drop old (renamed) and new objects for re-runnability
-- =============================================================================
-- Safe drops: each statement is wrapped so it silently skips if the object
-- does not exist (-942 table, -4080 trigger, -2443 constraint, -1418 index).
-- Order: children first, then parents, then lookups.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Helper procedure (session-only) to drop an object if it exists
-- -----------------------------------------------------------------------------
create or replace procedure invg_drop_object(
  p_statement in varchar2
)
is
  e_table_not_exists     exception; pragma exception_init(e_table_not_exists,     -942);
  e_trigger_not_exists   exception; pragma exception_init(e_trigger_not_exists,   -4080);
  e_constraint_not_found exception; pragma exception_init(e_constraint_not_found, -2443);
  e_index_not_exists     exception; pragma exception_init(e_index_not_exists,     -1418);
  e_object_not_exists    exception; pragma exception_init(e_object_not_exists,    -4043);
begin
  execute immediate p_statement;
  dbms_output.put_line('OK   : ' || p_statement);
exception
  when e_table_not_exists
    or e_trigger_not_exists
    or e_constraint_not_found
    or e_index_not_exists
    or e_object_not_exists
  then
    dbms_output.put_line('SKIP : ' || p_statement);
end;
/

prompt
prompt === Dropping old (renamed) and current objects ===
prompt

-- =============================================================================
-- 1. Child tables
-- =============================================================================
begin invg_drop_object('drop table invg_invoice_lines cascade constraints purge'); end;
/

-- =============================================================================
-- 2. Invoice header (references lookups via FK)
-- =============================================================================
begin invg_drop_object('drop table invg_invoices cascade constraints purge'); end;
/

-- =============================================================================
-- 3. Old lookup tables (pre-rename: clients / businesses)
-- =============================================================================
begin invg_drop_object('drop table invg_clients cascade constraints purge'); end;
/
begin invg_drop_object('drop table invg_businesses cascade constraints purge'); end;
/

-- =============================================================================
-- 4. New lookup tables (post-rename: recipients / senders)
-- =============================================================================
begin invg_drop_object('drop table invg_recipients cascade constraints purge'); end;
/
begin invg_drop_object('drop table invg_senders cascade constraints purge'); end;
/
begin invg_drop_object('drop table invg_bank_details cascade constraints purge'); end;
/

-- =============================================================================
-- 5. Cleanup helper procedure
-- =============================================================================
drop procedure invg_drop_object;

prompt
prompt === Drop phase complete ===
prompt
