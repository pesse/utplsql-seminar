create or replace package ut_deathstar_room_manager as
  -- %suite
  -- %suitepath(deathstar.interior)

  procedure setup_room_data;

  -- %test(ADD_ROOM: If no code is provided, a new one is generated based on 1st word and an increasing number)
  procedure add_room_code_is_generated;

  -- %context(Default RoomData Setup)
    -- %name(room_data)

    -- %beforeall(setup_room_data)

    -- %test
    procedure explore;

    -- %test
    procedure compare_rooms_with_reference;

    -- %test
    procedure compare_rooms_with_plsql_table;
  -- %endcontext


  type t_room is record (
    name varchar2(200),
    code varchar2(200),
    section_id integer,
    nr_in_section integer
  );

  type t_rooms is table of t_room;

end;
/

select * from table(ut.run(':deathstar.interior.ut_deathstar_room_manager.room_data'));
select * from table(ut.run(':deathstar.interior'));