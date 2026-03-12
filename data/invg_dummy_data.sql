-- clients
insert into invg_clients (name, address, email, phone)
values ('Bright Ideas Marketing Agency', '456 Market Street, Suite 200, San Francisco, CA 94102', 'accounts@brightideas.com', '415.555.0192');

insert into invg_clients (name, address, email, phone)
values ('Summit Peak Holdings', '789 Alpine Drive, Denver, CO 80202', 'ap@summitpeak.com', '720.555.0134');

insert into invg_clients (name, address, email, phone)
values ('Riverstone Logistics Co.', '220 Harbor Blvd, Long Beach, CA 90802', 'invoices@riverstone.com', '562.555.0271');

-- businesses
insert into invg_businesses (name, address, email, phone)
values ('Sarah Chen Design Studio', '123 Creative Lane, Oakland, CA 94612', 'sarah@sarahchendesign.com', '(510) 555-0147');

insert into invg_businesses (name, address, email, phone)
values ('Northwind Dev Solutions', '55 Innovation Blvd, Austin, TX 73301', 'hello@northwinddev.com', '(512) 555-0188');

insert into invg_businesses (name, address, email, phone)
values ('Maple & Co Consulting', '900 King Street West, Toronto, ON M5V 1P3', 'billing@mapleco.ca', '(416) 555-0333');

-- bank details
insert into invg_bank_details (receiver_name, bank_name, routing_number, bank_account_number, account_type, bank_address)
values ('Sarah Chen', 'Pacific National Bank', '121000248', '4455667788', 'Checking', '350 California St, San Francisco, CA 94104');

insert into invg_bank_details (receiver_name, bank_name, routing_number, bank_account_number, account_type, bank_address)
values ('Northwind Dev Solutions LLC', 'Lone Star Credit Union', '113024274', '9900112233', 'Business Checking', '100 Congress Ave, Austin, TX 73301');

insert into invg_bank_details (receiver_name, bank_name, routing_number, bank_account_number, account_type, bank_address)
values ('Maple & Co Consulting Inc.', 'Royal Commerce Bank', '021000089', '7711883344', 'Business Checking', '200 Bay Street, Toronto, ON M5J 2J5');

-- invoices
insert into invg_invoices (invoice_number, issue_date, include_due_date_yn, due_date, payment_terms, tax_rate, other_amount, notes, invg_client_id, invg_business_id, invg_bank_detail_id)
values ('1', date '2026-01-15', 'Y', date '2026-01-30', 'NET 15', 0, 0, 'Thank you for your business.',
  (select min(invg_client_id) from invg_clients where name = 'Bright Ideas Marketing Agency'),
  (select min(invg_business_id) from invg_businesses where name = 'Sarah Chen Design Studio'),
  (select min(invg_bank_detail_id) from invg_bank_details where receiver_name = 'Sarah Chen'));

insert into invg_invoices (invoice_number, issue_date, include_due_date_yn, due_date, payment_terms, tax_rate, other_amount, notes, invg_client_id, invg_business_id, invg_bank_detail_id)
values ('2', date '2026-02-01', 'Y', date '2026-03-03', 'NET 30', 8.25, 0, null,
  (select min(invg_client_id) from invg_clients where name = 'Summit Peak Holdings'),
  (select min(invg_business_id) from invg_businesses where name = 'Northwind Dev Solutions'),
  (select min(invg_bank_detail_id) from invg_bank_details where receiver_name = 'Northwind Dev Solutions LLC'));

insert into invg_invoices (invoice_number, issue_date, include_due_date_yn, due_date, payment_terms, tax_rate, other_amount, notes, invg_client_id, invg_business_id, invg_bank_detail_id)
values ('3', date '2026-03-10', 'N', null, 'Due on receipt', 0, 150, 'Includes travel expenses.',
  (select min(invg_client_id) from invg_clients where name = 'Riverstone Logistics Co.'),
  (select min(invg_business_id) from invg_businesses where name = 'Maple & Co Consulting'),
  (select min(invg_bank_detail_id) from invg_bank_details where receiver_name = 'Maple & Co Consulting Inc.'));

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
values ((select min(invg_invoice_id) from invg_invoices where invoice_number = '2'), 5, 'Client revision rounds (2x)', 400.00);

-- invoice lines — invoice 3 (2 lines)
insert into invg_invoice_lines (invg_invoice_id, line_number, description, amount)
values ((select min(invg_invoice_id) from invg_invoices where invoice_number = '3'), 1, 'Strategic operations consulting — Q1', 6000.00);

insert into invg_invoice_lines (invg_invoice_id, line_number, description, amount)
values ((select min(invg_invoice_id) from invg_invoices where invoice_number = '3'), 2, 'Supply chain process audit', 2400.00);

commit;
