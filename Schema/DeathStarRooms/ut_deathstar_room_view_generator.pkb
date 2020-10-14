create or replace package body ut_deathstar_room_view_generator as
  procedure create_view as
    l_id_vader_room integer;
    l_id_vader_room_2 integer;
    l_count integer;
    c_actual sys_refcursor;
  begin
    select id into l_id_vader_room from deathstar_rooms where section_id = -1 and code = 'VADERS3';
    select id into l_id_vader_room_2 from deathstar_rooms where section_id = -1 and code = 'VADERS4';

    deathstar_room_view_generator.create_view('V_ROOM_VADER_TEST', sys.odcinumberlist(l_id_vader_room, l_id_vader_room_2));

    open c_actual for
      'select * from v_room_vader_test';

    ut.expect(c_actual).to_have_count(2);
  end;

  procedure cleanup_rooms as
  begin
    delete from deathstar_rooms where section_id = -1;
    delete from deathstar_sections where id = -1;
    commit;
    execute immediate 'drop view v_room_vader_test';
  end;
end;
/