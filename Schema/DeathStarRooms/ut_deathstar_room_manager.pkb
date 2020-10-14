create or replace package body ut_deathstar_room_manager as

  id_section constant integer := -1;

  procedure explore as
  begin
    insert into deathstar_sections (id, label)
      values( -1, 'Section 1 Test');

    deathstar_room_manager.ADD_ROOM(
      i_name => 'Vaders Chamber',
      i_section_id => -1
      );
    deathstar_room_manager.ADD_ROOM(
      i_name => 'Vaders Chamber 2',
      i_section_id => -1
      );
    deathstar_room_manager.ADD_ROOM(
      i_name => 'Bridge',
      i_section_id => -1
      );

    deathstar_room_manager.add_room('Storage Room', id_section);
    deathstar_room_manager.add_room('Storage Room', id_section);
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

end;
/

select * from table(ut.run('ut_deathstar_room_manager'));

begin
  ut.run('ut_deathstar_room_manager.explore', a_force_manual_rollback=>true);
end;

rollback;

select * from deathstar_rooms;
select * from deathstar_sections;