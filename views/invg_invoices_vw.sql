-- =============================================================================
-- invg_invoices_vw - List view for invoices (id, number, recipient, date, subtotal)
-- =============================================================================

create or replace view invg_invoices_vw
as
with w_line_subtotal as (
  select invg_invoice_id
       , nvl(sum(amount), 0) as line_subtotal
    from invg_invoice_lines
   where active_yn = 'Y'
   group by invg_invoice_id
)
, w_inv as (
  select i.invg_invoice_id
       , i.invoice_number
       , r.name as recipient_name
       , i.issue_date
    from invg_invoices i
    left join invg_recipients r
      on r.invg_recipient_id = i.invg_recipient_id
     and r.active_yn = 'Y'
   where i.active_yn = 'Y'
)
select w.invg_invoice_id
     , w.invoice_number
     , w.recipient_name
     , w.issue_date
     , nvl(l.line_subtotal, 0) as line_subtotal
  from w_inv w
  left join w_line_subtotal l
    on l.invg_invoice_id = w.invg_invoice_id;
