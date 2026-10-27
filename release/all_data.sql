-- This file must be manually modified as order matters when creating data records
-- Data files are re-runnable data scripts
-- ex: @../data/data_my_table.sql
--
-- ---------------------------------------------------------------------------
-- Release con datos reales: deja comentado lo de abajo y, tras _release.sql,
-- ejecuta @migration/invg_restore_after_release.sql (si hiciste backup antes).
-- Entorno de desarrollo con datos de prueba: descomenta delete + dummy.
-- ---------------------------------------------------------------------------

-- prompt @../data/invg_delete_all_data.sql
-- @../data/invg_delete_all_data.sql
-- prompt @../data/invg_dummy_data.sql
-- @../data/invg_dummy_data.sql

prompt all_data.sql: no INVG seed scripts (use migration restore for real data, or uncomment for dev dummy data)
