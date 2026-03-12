-- =============================================================================
-- invg_invoice_lines_vw - Invoice lines with invoice header for reporting
-- =============================================================================

create or replace view invg_invoice_lines_vw
as
with w_lines as (
  select l.invg_invoice_line_id
       , l.invg_invoice_id
       , i.invoice_number
       , l.line_number
       , l.description
       , l.amount
    from invg_invoice_lines l
    join invg_invoices i
      on i.invg_invoice_id = l.invg_invoice_id
     and i.active_yn = 'Y'
   where l.active_yn = 'Y'
)
select invg_invoice_line_id
     , invg_invoice_id
     , invoice_number
     , line_number
     , description
     , amount
  from w_lines;
