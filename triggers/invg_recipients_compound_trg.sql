-- -----------------------------------------------------------------------------
-- Compound trigger: invg_recipients audit columns
-- -----------------------------------------------------------------------------
create or replace trigger invg_recipients_compound_trg
for insert or update on invg_recipients
compound trigger

  before each row is
  begin
    if updating then
      :new.last_updated_on := localtimestamp;
      :new.last_updated_by := coalesce(
                                sys_context('APEX$SESSION','app_user')
                              , regexp_substr(sys_context('userenv','client_identifier'),'^[^:]*')
                              , sys_context('userenv','session_user')
                              );
    end if;
  end before each row;

end invg_recipients_compound_trg;
/
