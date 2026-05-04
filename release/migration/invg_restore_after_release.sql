-- =============================================================================
-- invg_restore_after_release.sql
-- =============================================================================
-- Run AFTER @release/code/_run_code.sql has recreated tables (or full
-- @release/_release.sql through the DDL phase). Reloads data from invg_rel_bak_*
-- created by invg_backup_before_release.sql.
--
-- Maps legacy columns:
--   invg_clients       -> invg_recipients   (invg_client_id -> invg_recipient_id)
--   invg_businesses    -> invg_senders      (invg_business_id -> invg_sender_id)
--   invg_invoices      -> invg_invoices     (client/business FKs -> recipient/sender)
--
-- Identity PKs are inserted explicitly so FKs stay valid; script then adjusts
-- identity START WITH LIMIT VALUE on each table.
--
-- If @release/all_data.sql ran dummy seed data, rows are cleared below before
-- reload. Skip this script if you already loaded production data another way.
-- =============================================================================

set serveroutput on size unlimited
set verify off
whenever sqlerror exit sql.sqlcode

prompt
prompt =============================================================================
prompt Restore INVG data from invg_rel_bak_* backup tables
prompt =============================================================================

-- -----------------------------------------------------------------------------
-- Sanity: backup tables must exist (before any delete)
-- -----------------------------------------------------------------------------
declare
  l_cnt number;
begin
  select count(*) into l_cnt
    from user_tables
   where table_name = 'INVG_REL_BAK_CLIENTS';
  if l_cnt = 0 then
    raise_application_error(-20001, 'Missing invg_rel_bak_clients. Run invg_backup_before_release.sql first.');
  end if;
end;
/

-- -----------------------------------------------------------------------------
-- Replace current rows (FK-safe order; removes dummy seed if release ran all_data)
-- Some AI DB builds run DELETE in parallel and hit ORA-12860 (PX sibling deadlock).
-- OCI free tier allows ALTER SESSION on your own connection; if it fails (rare),
-- the NO_PARALLEL hints below still force serial deletes.
-- -----------------------------------------------------------------------------
begin
  execute immediate 'alter session disable parallel dml';
  execute immediate 'alter session disable parallel query';
exception
  when others then
    dbms_output.put_line('Note: alter session disable parallel skipped: ' || sqlerrm);
end;
/

prompt Delete existing INVG rows before reload ...

delete /*+ no_parallel */ from invg_invoice_lines;
delete /*+ no_parallel */ from invg_invoices;
delete /*+ no_parallel */ from invg_recipients;
delete /*+ no_parallel */ from invg_senders;
delete /*+ no_parallel */ from invg_bank_details;

-- -----------------------------------------------------------------------------
-- 1. Lookups: recipients, senders, bank details (preserve PK values)
-- -----------------------------------------------------------------------------
prompt Insert invg_recipients from invg_rel_bak_clients ...

insert into invg_recipients (
  invg_recipient_id
, name
, address
, email
, phone
, created_by
, created_on
, last_updated_by
, last_updated_on
, active_yn
)
select invg_client_id
     , name
     , address
     , email
     , phone
     , created_by
     , created_on
     , last_updated_by
     , last_updated_on
     , active_yn
  from invg_rel_bak_clients;

prompt Insert invg_senders from invg_rel_bak_businesses ...

insert into invg_senders (
  invg_sender_id
, name
, address
, email
, phone
, created_by
, created_on
, last_updated_by
, last_updated_on
, active_yn
)
select invg_business_id
     , name
     , address
     , email
     , phone
     , created_by
     , created_on
     , last_updated_by
     , last_updated_on
     , active_yn
  from invg_rel_bak_businesses;

prompt Insert invg_bank_details from invg_rel_bak_bank_details ...

insert into invg_bank_details (
  invg_bank_detail_id
, receiver_name
, bank_name
, routing_number
, bank_account_number
, account_type
, bank_address
, created_by
, created_on
, last_updated_by
, last_updated_on
, active_yn
)
select invg_bank_detail_id
     , receiver_name
     , bank_name
     , routing_number
     , bank_account_number
     , account_type
     , bank_address
     , created_by
     , created_on
     , last_updated_by
     , last_updated_on
     , active_yn
  from invg_rel_bak_bank_details;

-- -----------------------------------------------------------------------------
-- 2. Invoice header (map client/business columns to recipient/sender)
-- -----------------------------------------------------------------------------
prompt Insert invg_invoices from invg_rel_bak_invoices ...

insert into invg_invoices (
  invg_invoice_id
, invoice_number
, issue_date
, include_due_date_yn
, due_date
, payment_terms
, tax_rate
, other_amount
, notes
, invg_recipient_id
, invg_sender_id
, invg_bank_detail_id
, created_by
, created_on
, last_updated_by
, last_updated_on
, active_yn
)
select invg_invoice_id
     , invoice_number
     , issue_date
     , include_due_date_yn
     , due_date
     , payment_terms
     , tax_rate
     , other_amount
     , notes
     , invg_client_id
     , invg_business_id
     , invg_bank_detail_id
     , created_by
     , created_on
     , last_updated_by
     , last_updated_on
     , active_yn
  from invg_rel_bak_invoices;

-- -----------------------------------------------------------------------------
-- 3. Invoice lines
-- -----------------------------------------------------------------------------
prompt Insert invg_invoice_lines from invg_rel_bak_invoice_lines ...

insert into invg_invoice_lines (
  invg_invoice_line_id
, invg_invoice_id
, line_number
, description
, amount
, created_by
, created_on
, last_updated_by
, last_updated_on
, active_yn
)
select invg_invoice_line_id
     , invg_invoice_id
     , line_number
     , description
     , amount
     , created_by
     , created_on
     , last_updated_by
     , last_updated_on
     , active_yn
  from invg_rel_bak_invoice_lines;

-- -----------------------------------------------------------------------------
-- 4. Resync identity columns so the next insert gets max(id)+1
--    (Oracle 12.2+)
-- -----------------------------------------------------------------------------
prompt Adjust identity columns (START WITH LIMIT VALUE) ...

begin
  execute immediate q'[alter table invg_recipients modify invg_recipient_id generated by default on null as identity ( start with limit value )]';
  execute immediate q'[alter table invg_senders modify invg_sender_id generated by default on null as identity ( start with limit value )]';
  execute immediate q'[alter table invg_bank_details modify invg_bank_detail_id generated by default on null as identity ( start with limit value )]';
  execute immediate q'[alter table invg_invoices modify invg_invoice_id generated by default on null as identity ( start with limit value )]';
  execute immediate q'[alter table invg_invoice_lines modify invg_invoice_line_id generated by default on null as identity ( start with limit value )]';
exception
  when others then
    dbms_output.put_line('Note: identity LIMIT VALUE adjust failed: ' || sqlerrm);
    dbms_output.put_line('If your Oracle version is older than 12.2, set identity restart manually.');
    raise;
end;
/

commit;

prompt
prompt Restore complete.
prompt Row counts (live tables):
select 'invg_recipients' as tbl, count(*) as c from invg_recipients
union all select 'invg_senders', count(*) from invg_senders
union all select 'invg_bank_details', count(*) from invg_bank_details
union all select 'invg_invoices', count(*) from invg_invoices
union all select 'invg_invoice_lines', count(*) from invg_invoice_lines
;

prompt =============================================================================
