create or replace package ut_deathstar_room_manager as
  -- %suite

  -- %test
  procedure explore;

  -- %test(ADD_ROOM: If no code is provided, a new one is generated based on 1st word and an increasing number)
  procedure add_room_code_is_generated;

end;
/