-- This file must be manually modified as order matters when creating data records
-- Data files are re-runnable data scripts
-- ex: @../data/data_my_table.sql

prompt @../data/invg_delete_all_data.sql
@../data/invg_delete_all_data.sql
prompt @../data/invg_dummy_data.sql
@../data/invg_dummy_data.sql
