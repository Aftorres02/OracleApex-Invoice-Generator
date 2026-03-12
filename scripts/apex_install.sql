-- =============================================================================
-- APEX Application Install (App 600)
-- =============================================================================
-- Run in SQLcl:  @scripts/apex_install.sql
--
-- Parameters:
--   1: Schema to install into
--   2: Workspace to install into
-- =============================================================================

set serveroutput on size unlimited;
set timing off;
set define on

declare
begin

  apex_application_install.set_application_id(600);
  apex_application_install.set_schema(upper('&1.'));
  apex_application_install.set_workspace(upper('&2.'));

end;
/

@../apex/f600.sql