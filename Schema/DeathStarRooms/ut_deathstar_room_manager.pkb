create or replace package body ut_deathstar_room_manager as

  id_section constant integer := -1;

  procedure setup_room_data as
  begin
    insert into deathstar_sections (id, label)
      values( -1, 'Section 1 Test');

    deathstar_room_manager.add_room('Vaders Chamber', -1);
    deathstar_room_manager.add_room('Vaders Chamber 2', -1);
    deathstar_room_manager.add_room('Bridge', -1);
    deathstar_room_manager.add_room('Storage Room', id_section);
    deathstar_room_manager.add_room('Storage Room', id_section);
  end;

  procedure explore as
  begin
    null;
  end;

  function row_rooms( i_room_name varchar2 )
    return deathstar_rooms%rowtype
  as
    l_result deathstar_rooms%rowtype;
  begin
    select * into l_result from deathstar_rooms
      where section_id = id_section and name = i_room_name;
    return l_result;
  end;
  function row_rooms_by_code( i_code varchar2 )
    return deathstar_rooms%rowtype
  as
    l_result deathstar_rooms%rowtype;
  begin
    select * into l_result from deathstar_rooms
      where code = i_code;
    return l_result;
  exception when no_data_found then
    ut.fail('No data was found for Code ' || i_code);
    return null;
  end;

  procedure add_room_code_is_generated as
    lc_storage_room_label constant varchar2(200) := 'Storage Room';
    l_count integer;
    l_row deathstar_rooms%rowtype;
  begin
    -- Arrange
    insert into deathstar_sections (id, label)
      values( id_section, 'Section 1 Test');

    -- Act
    deathstar_room_manager.ADD_ROOM(
      i_name => 'Vaders Chamber',
      i_section_id => id_section
      );

    -- Assert
    ut.expect(row_rooms('Vaders Chamber').code).to_equal('VADERS1');


    deathstar_room_manager.ADD_ROOM(
      i_name => lc_storage_room_label,
      i_section_id => id_section
      );
    /*deathstar_room_manager.ADD_ROOM(
      i_name => lc_storage_room_label,
      i_section_id => id_section
      );*/

    ut.expect(row_rooms_by_code('STORAG2').name)
      .to_equal(lc_storage_room_label);

    select count(*) into l_count from deathstar_rooms where code = 'STORAG2';
    ut.expect(l_count, 'check STORAG2 exists')
      .to_equal(1);
  end;

  procedure compare_rooms_with_reference as
    c_actual sys_refcursor;
    c_reference sys_refcursor;
  begin

    open c_actual for
      select * from deathstar_rooms where section_id = id_section;
    open c_reference for
      select * from deathstar_rooms_reference;

    ut.expect(c_actual)
      .to_equal(c_reference)
      .exclude('ID');
  end;

  procedure compare_rooms_with_plsql_table as
    c_actual sys_refcursor;
    c_expect sys_refcursor;

    l_expectPlSqlTable t_rooms := t_rooms();
  begin
    open c_actual for
      select name, code, section_id, nr_in_section
        from deathstar_rooms
        where section_id = id_section
        order by name;

    l_expectplsqltable.extend(4);
    l_expectplsqltable(1).name := 'Vaders Chamber';
    l_expectplsqltable(1).code := 'VADERS1';
    l_expectplsqltable(1).section_id := id_section;
    l_expectplsqltable(1).nr_in_section := 1;
    l_expectplsqltable(2).name := 'Vaders Chamber';
    l_expectplsqltable(2).code := 'VADERS1';
    l_expectplsqltable(2).section_id := id_section;
    l_expectplsqltable(2).nr_in_section := 2;
    l_expectplsqltable(3).name := 'Vaders Chamber';
    l_expectplsqltable(3).code := 'VADERS1';
    l_expectplsqltable(3).section_id := id_section;
    l_expectplsqltable(3).nr_in_section := 3;
    l_expectplsqltable(4).name := 'Vaders Chamber';
    l_expectplsqltable(4).code := 'VADERS1';
    l_expectplsqltable(4).section_id := id_section;
    l_expectplsqltable(4).nr_in_section := 4;
    /*l_expectplsqltable(5).name := 'Vaders Chamber';
    l_expectplsqltable(5).code := 'VADERS1';
    l_expectplsqltable(5).section_id := id_section;
    l_expectplsqltable(5).nr_in_section := 5;*/

    open c_expect for
      select * from table(l_expectplsqltable);

    ut.expect(c_actual).to_equal(c_expect)
      .exclude('NAME')
      .join_by('SECTION_ID,NR_IN_SECTION');
  end;

end;
/

select * from table(ut.run('ut_deathstar_room_manager'));

begin
  ut.run('ut_deathstar_room_manager.explore', a_force_manual_rollback=>true);
end;

rollback;

create table deathstar_rooms_reference as select * from deathstar_rooms where 1=2;

insert into deathstar_rooms_reference select * from deathstar_rooms where section_id = -1;

delete deathstar_rooms where section_id = -1;
delete deathstar_sections where id = -1;

commit;
select * from deathstar_rooms;
select * from deathstar_sections;
select * from deathstar_rooms_reference;