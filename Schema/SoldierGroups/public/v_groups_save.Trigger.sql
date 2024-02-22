create or replace trigger v_groups_save instead of update or insert or delete on v_groups
for each row
  declare
  begin
    if (:new.group_name <> :old.group_name or :new.group_name is null or :old.group_name is null) then
      update groups set honor_name = :new.group_name where id = :new.id;
    end if;
  end;
/