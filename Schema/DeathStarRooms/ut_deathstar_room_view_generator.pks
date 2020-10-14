create or replace package ut_deathstar_room_view_generator as
  -- %suite
  -- %rollback(manual)

  -- %test
  -- %beforetest(ut_deathstar_room_manager.setup_room_data)
  -- %aftertest(cleanup_rooms)
  procedure create_view;

  procedure cleanup_rooms;
end;
/