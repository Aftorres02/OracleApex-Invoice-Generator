-- =============================================================================
-- invg_backup_before_release.sql
-- =============================================================================
-- Crea tablas de respaldo invg_rel_bak_* (copia de filas) para poder usar
-- invg_restore_after_release.sql tras un release.
--
-- Origen de datos (automático):
--   - Antes del release: invg_clients + invg_businesses + invg_invoices (FKs
--     antiguas) e invg_bank_details, invg_invoice_lines.
--   - Después del release (o BD ya migrada): invg_recipients, invg_senders y
--     facturas con invg_recipient_id / invg_sender_id; el script renombra en
--     el backup a invg_client_id / invg_business_id para que el restore siga
--     igual.
--
-- Si no existe ni clients ni recipients, el script falla con mensaje claro.
-- =============================================================================

set serveroutput on size unlimited
set verify off
whenever sqlerror exit sql.sqlcode

prompt
prompt =============================================================================
prompt Backup INVG tables (snapshot para restore tras release)
prompt =============================================================================

-- -----------------------------------------------------------------------------
-- Drop prior backup tables if they exist (re-runnable backup)
-- -----------------------------------------------------------------------------
begin
  for r in (
    select table_name
      from user_tables
     where table_name in (
             'INVG_REL_BAK_CLIENTS'
           , 'INVG_REL_BAK_BUSINESSES'
           , 'INVG_REL_BAK_BANK_DETAILS'
           , 'INVG_REL_BAK_INVOICES'
           , 'INVG_REL_BAK_INVOICE_LINES'
           )
  ) loop
    execute immediate 'drop table ' || r.table_name || ' purge';
    dbms_output.put_line('Dropped prior backup: ' || r.table_name);
  end loop;
end;
/

-- -----------------------------------------------------------------------------
-- Build backup: legacy (invg_*) o ya renombrado (invg_recipients / invg_senders)
-- -----------------------------------------------------------------------------
declare
  l_has_clients    pls_integer;
  l_has_recipients pls_integer;
begin
  select count(*) into l_has_clients
    from user_tables
   where table_name = 'INVG_CLIENTS';

  select count(*) into l_has_recipients
    from user_tables
   where table_name = 'INVG_RECIPIENTS';

  if l_has_clients > 0 then
    dbms_output.put_line('Mode: legacy tables (invg_clients / invg_businesses).');
    execute immediate 'create table invg_rel_bak_clients as select * from invg_clients';
    execute immediate 'create table invg_rel_bak_businesses as select * from invg_businesses';
    execute immediate 'create table invg_rel_bak_invoices as select * from invg_invoices';
  elsif l_has_recipients > 0 then
    dbms_output.put_line('Mode: new tables (invg_recipients / invg_senders) — columnas mapeadas al backup legacy.');
    execute immediate q'[create table invg_rel_bak_clients as
      select invg_recipient_id as invg_client_id
           , name
           , address
           , email
           , phone
           , created_by
           , created_on
           , last_updated_by
           , last_updated_on
           , active_yn
        from invg_recipients]';
    execute immediate q'[create table invg_rel_bak_businesses as
      select invg_sender_id as invg_business_id
           , name
           , address
           , email
           , phone
           , created_by
           , created_on
           , last_updated_by
           , last_updated_on
           , active_yn
        from invg_senders]';
    execute immediate q'[create table invg_rel_bak_invoices as
      select invg_invoice_id
           , invoice_number
           , issue_date
           , include_due_date_yn
           , due_date
           , payment_terms
           , tax_rate
           , other_amount
           , notes
           , invg_recipient_id as invg_client_id
           , invg_sender_id as invg_business_id
           , invg_bank_detail_id
           , created_by
           , created_on
           , last_updated_by
           , last_updated_on
           , active_yn
        from invg_invoices]';
  else
    raise_application_error(
      -20001
    , 'No se encontró invg_clients (legacy) ni invg_recipients (nuevo). ' ||
      'Comprueba el esquema o que _release.sql haya creado las tablas.'
    );
  end if;

  execute immediate 'create table invg_rel_bak_bank_details as select * from invg_bank_details';
  execute immediate 'create table invg_rel_bak_invoice_lines as select * from invg_invoice_lines';
end;
/

prompt
prompt Row counts (respaldo):
select 'invg_rel_bak_clients' as backup_table, count(*) as row_count from invg_rel_bak_clients
union all
select 'invg_rel_bak_businesses', count(*) from invg_rel_bak_businesses
union all
select 'invg_rel_bak_bank_details', count(*) from invg_rel_bak_bank_details
union all
select 'invg_rel_bak_invoices', count(*) from invg_rel_bak_invoices
union all
select 'invg_rel_bak_invoice_lines', count(*) from invg_rel_bak_invoice_lines
;

prompt
prompt Backup listo. Puedes ejecutar @release/_release.sql o @migration/invg_restore_after_release.sql.
prompt =============================================================================

commit;
