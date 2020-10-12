create or replace package body ut_sith_persons as

  procedure insert_select_sith_persons as
    l_row sith_persons%rowtype;
  begin
    insert into sith_persons (name, alive)
      values ('Darth Sam', 0);

    -- Assert
    select * into l_row from sith_persons
      where name = 'Darth Sam';
    ut.expect(l_row.id).to_be_greater_than(0);
    ut.expect(l_row.alive).to_equal(0);
  end;

end;
/