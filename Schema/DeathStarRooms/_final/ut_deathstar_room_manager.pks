create or replace package ut_deathstar_room_manager as
  -- %suite(Room-Manager)
  -- %suitepath(ut_deathstar.rooms)

  -- %beforeall
  procedure setup_section;

  -- %test(Add room with name and code places it as highest number in that section)
  -- %tags(wip)
  procedure add_room_default;

  -- %test(Add a room without will generate a code)
  procedure add_room_auto_generated_code;

  -- %test(Add a room without will generate a different code the 2nd time)
  -- %tags(wip)
  procedure add_room_auto_generated_code_twice;

end;
/