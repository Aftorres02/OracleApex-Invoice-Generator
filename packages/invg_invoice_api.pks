-- =============================================================================
-- invg_invoice_api - Invoice Generator API (spec)
-- =============================================================================
-- get_invoices, get_invoice, delete_invoice, get_next_invoice_number.
-- Insert/update handled by APEX native DML.
-- =============================================================================

create or replace package invg_invoice_api
as

  /**
   * Returns list of invoices for list page.
   *
   * @param p_cursor ref cursor out: invg_invoice_id, invoice_number, recipient_name, issue_date
   */
  procedure get_invoices(
    p_cursor out sys_refcursor
  );

  /**
   * Returns one invoice header by id (joined to recipients, senders, bank_details for display).
   *
   * @param p_invoice_id invg_invoice_id
   * @param p_cursor ref cursor out: invoice + recipient/sender/bank display columns
   */
  procedure get_invoice(
    p_invoice_id   in  invg_invoices.invg_invoice_id%type
  , p_cursor       out sys_refcursor
  );

  /**
   * Returns invoice lines for one invoice.
   *
   * @param p_invoice_id invg_invoice_id
   * @param p_cursor ref cursor out: rows from invg_invoice_lines
   */
  procedure get_invoice_lines(
    p_invoice_id   in  invg_invoices.invg_invoice_id%type
  , p_cursor       out sys_refcursor
  );

  /**
   * Soft-delete invoice and its lines (active_yn = 'N').
   *
   * @param p_invoice_id invg_invoice_id
   */
  procedure delete_invoice(
    p_invoice_id in invg_invoices.invg_invoice_id%type
  );

  /**
   * Returns next suggested invoice number (max + 1 numeric part).
   *
   * @return varchar2 e.g. 2026-004
   */
  function get_next_invoice_number
  return varchar2;

  /**
   * Renders a full invoice as an HTML document fragment ready for display
   * in an APEX region and for printing via window.print().
   *
   * @author Angel Flores (Consultant)
   * @created Wednesday, 11/Mar/2026
   *
   * @param p_invoice_id invg_invoice_id
   * @return clob HTML string (div.invoice-doc with all sections)
   */
  function render_invoice_html(
    p_invoice_id in invg_invoices.invg_invoice_id%type
  )
  return clob;

end invg_invoice_api;
/
