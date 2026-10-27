-- senders (freelancers / individuals)
insert into invg_senders (name, address, email, phone)
values ('Sarah Chen', '123 Creative Lane, Apt 4B, Oakland, CA 94612', 'sarah@sarahchen.me', '(510) 555-0147');

insert into invg_senders (name, address, email, phone)
values ('Marcus Rivera', '55 Elm Street, Unit 12, Austin, TX 73301', 'marcus.rivera@gmail.com', '(512) 555-0188');

insert into invg_senders (name, address, email, phone)
values ('Emily Tremblay', '900 Rue Saint-Denis, Apt 7, Montreal, QC H2X 3K4', 'emily.tremblay@outlook.com', '(514) 555-0333');

-- recipients (companies)
insert into invg_recipients (name, address, email, phone)
values ('Bright Ideas Marketing Agency', '456 Market Street, Suite 200, San Francisco, CA 94102', 'accounts@brightideas.com', '415.555.0192');

insert into invg_recipients (name, address, email, phone)
values ('Summit Peak Holdings Inc.', '789 Alpine Drive, Floor 15, Denver, CO 80202', 'ap@summitpeak.com', '720.555.0134');

insert into invg_recipients (name, address, email, phone)
values ('Riverstone Logistics Co.', '220 Harbor Blvd, Building C, Long Beach, CA 90802', 'invoices@riverstone.com', '562.555.0271');

-- bank details (personal accounts matching senders)
insert into invg_bank_details (receiver_name, bank_name, routing_number, bank_account_number, account_type, bank_address)
values ('Sarah Chen', 'Pacific National Bank', '121000248', '4455667788', 'Checking', '350 California St, San Francisco, CA 94104');

insert into invg_bank_details (receiver_name, bank_name, routing_number, bank_account_number, account_type, bank_address)
values ('Marcus Rivera', 'Lone Star Credit Union', '113024274', '9900112233', 'Checking', '100 Congress Ave, Austin, TX 73301');

insert into invg_bank_details (receiver_name, bank_name, routing_number, bank_account_number, account_type, bank_address)
values ('Emily Tremblay', 'Royal Commerce Bank', '021000089', '7711883344', 'Checking', '200 Bay Street, Toronto, ON M5J 2J5');

-- invoices
insert into invg_invoices (invoice_number, issue_date, include_due_date_yn, due_date, payment_terms, tax_rate, other_amount, notes, invg_recipient_id, invg_sender_id, invg_bank_detail_id)
values ('1', date '2026-01-15', 'Y', date '2026-01-30', 'NET 15', 0, 0, 'Thank you for your business.',
  (select min(invg_recipient_id) from invg_recipients where name = 'Bright Ideas Marketing Agency'),
  (select min(invg_sender_id) from invg_senders where name = 'Sarah Chen'),
  (select min(invg_bank_detail_id) from invg_bank_details where receiver_name = 'Sarah Chen'));

insert into invg_invoices (invoice_number, issue_date, include_due_date_yn, due_date, payment_terms, tax_rate, other_amount, notes, invg_recipient_id, invg_sender_id, invg_bank_detail_id)
values ('2', date '2026-02-01', 'Y', date '2026-03-03', 'NET 30', 8.25, 0, null,
  (select min(invg_recipient_id) from invg_recipients where name = 'Summit Peak Holdings Inc.'),
  (select min(invg_sender_id) from invg_senders where name = 'Marcus Rivera'),
  (select min(invg_bank_detail_id) from invg_bank_details where receiver_name = 'Marcus Rivera'));

insert into invg_invoices (invoice_number, issue_date, include_due_date_yn, due_date, payment_terms, tax_rate, other_amount, notes, invg_recipient_id, invg_sender_id, invg_bank_detail_id)
values ('3', date '2026-03-10', 'N', null, 'Due on receipt', 0, 150, 'Includes travel expenses.',
  (select min(invg_recipient_id) from invg_recipients where name = 'Riverstone Logistics Co.'),
  (select min(invg_sender_id) from invg_senders where name = 'Emily Tremblay'),
  (select min(invg_bank_detail_id) from invg_bank_details where receiver_name = 'Emily Tremblay'));

-- invoice lines — invoice 1 (3 lines)
insert into invg_invoice_lines (invg_invoice_id, line_number, description, amount)
values ((select min(invg_invoice_id) from invg_invoices where invoice_number = '1'), 1, 'Brand identity redesign', 3200.00);

insert into invg_invoice_lines (invg_invoice_id, line_number, description, amount)
values ((select min(invg_invoice_id) from invg_invoices where invoice_number = '1'), 2, 'Website mockups (5 pages)', 2000.00);

insert into invg_invoice_lines (invg_invoice_id, line_number, description, amount)
values ((select min(invg_invoice_id) from invg_invoices where invoice_number = '1'), 3, 'Social media asset pack', 750.00);

-- invoice lines — invoice 2 (5 lines)
insert into invg_invoice_lines (invg_invoice_id, line_number, description, amount)
values ((select min(invg_invoice_id) from invg_invoices where invoice_number = '2'), 1, 'Full-stack feature development — Sprint 4', 5500.00);

insert into invg_invoice_lines (invg_invoice_id, line_number, description, amount)
values ((select min(invg_invoice_id) from invg_invoices where invoice_number = '2'), 2, 'Database performance tuning', 1200.00);

insert into invg_invoice_lines (invg_invoice_id, line_number, description, amount)
values ((select min(invg_invoice_id) from invg_invoices where invoice_number = '2'), 3, 'QA testing and bug fixes', 1800.00);

insert into invg_invoice_lines (invg_invoice_id, line_number, description, amount)
values ((select min(invg_invoice_id) from invg_invoices where invoice_number = '2'), 4, 'Production deployment support', 800.00);

insert into invg_invoice_lines (invg_invoice_id, line_number, description, amount)
values ((select min(invg_invoice_id) from invg_invoices where invoice_number = '2'), 5, 'Revision rounds (2x)', 400.00);

-- invoice lines — invoice 3 (2 lines)
insert into invg_invoice_lines (invg_invoice_id, line_number, description, amount)
values ((select min(invg_invoice_id) from invg_invoices where invoice_number = '3'), 1, 'Strategic operations consulting — Q1', 6000.00);

insert into invg_invoice_lines (invg_invoice_id, line_number, description, amount)
values ((select min(invg_invoice_id) from invg_invoices where invoice_number = '3'), 2, 'Supply chain process audit', 2400.00);

commit;
