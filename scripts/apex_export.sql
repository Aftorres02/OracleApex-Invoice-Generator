-- =============================================================================
-- APEX Application Export (App 600)
-- =============================================================================
-- Run in SQLcl:  @scripts/apex_export.sql
--
-- Exports:
--   1. Single-file SQL   -> apex/f600.sql  (for import / deployment)
--   2. YAML split files  -> apex/f600/     (for readable version control)
-- =============================================================================

set termout on
set serveroutput on

begin
  dbms_output.put_line('--------------------------------------------------');
  dbms_output.put_line('Exporting Application 600');
  dbms_output.put_line('--------------------------------------------------');
end;
/

-- -----------------------------------------------------------------------------
-- Single-file export (f600.sql) for deployment / import
-- -----------------------------------------------------------------------------
apex export -applicationid 600 -dir apex

-- -----------------------------------------------------------------------------
-- YAML split export for readable version control
-- -----------------------------------------------------------------------------
apex export -applicationid 600 -dir apex -split -expType READABLE_YAML

set serveroutput on
begin
  dbms_output.put_line('--------------------------------------------------');
  dbms_output.put_line('Export complete.');
  dbms_output.put_line('  apex/f600.sql   -> single-file (import)');
  dbms_output.put_line('  apex/f600/      -> YAML split  (version control)');
  dbms_output.put_line('--------------------------------------------------');
end;
/
