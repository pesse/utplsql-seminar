create or replace package body ut_deathstar_room_view_generator as

  procedure create_view
  as
    l_actual sys_refcursor;
    l_expected sys_refcursor;
    begin
      -- Control the input/state
      insert into deathstar_sections ( id, label )
        values ( -1, 'Test Section');
      insert into deathstar_rooms ( id, name, code, section_id )
        values ( -1, 'Test Room', 'TESTROOM', -1);
      insert into deathstar_rooms ( id, name, code, section_id )
        values ( -2, 'Test Room 2', 'TESTROOM2', -1);

      deathstar_room_view_generator.create_view(
        i_view_name => 'room_test_view',
        i_room_ids => sys.odcinumberlist(-1, -2));

      -- Check if it is THE RIGHT view
      open l_expected for
        select -1 id, 'Test Room' name, 'TESTROOM' code, -1 section_id, 'Test Section' section_label from dual union all
        select -2   , 'Test Room 2'   , 'TESTROOM2'    , -1           , 'Test Section'               from dual;

      open l_actual for
        select * from room_test_view;

      ut.expect(l_actual)
        .to_equal(l_expected)
        .join_by('ID');
    end;

    procedure cleanup_test_view
    as
      begin
        execute immediate 'drop view room_test_view';
        delete from deathstar_rooms where id < 0;
        delete from deathstar_sections where id < 0;
        commit;
      end;

end;
/
