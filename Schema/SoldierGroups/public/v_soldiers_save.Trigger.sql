create or replace trigger v_soldiers_save instead of update or insert or delete on v_soldiers
for each row
  declare
  begin
    if (:new.name is not null and (:old.name is null or :new.name <> :old.name)) then
      update soldiers set name = :new.name where id = :new.id;
    end if;
  end;
/