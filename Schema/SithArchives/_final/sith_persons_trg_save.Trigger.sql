create or replace trigger sith_persons_trg_save
  instead of insert or update or delete on sith_persons
  begin
    if inserting then
      insert into sith_characters_t (alive, prename, surname)
        values (
          :new.alive,
          trim(substr(:new.name, 1, instr(:new.name, ' '))),
          trim(substr(:new.name, instr(:new.name, ' ')))
        );
    elsif updating then
      update sith_characters_t set
        alive = :new.alive,
        prename = trim(substr(:new.name, 1, instr(:new.name, ' '))),
        surname = trim(substr(:new.name, instr(:new.name, ' ')))
      where id = :new.id;
    end if;
  end;
/