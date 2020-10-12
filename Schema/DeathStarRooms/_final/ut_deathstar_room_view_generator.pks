create or replace package ut_deathstar_room_view_generator as
  -- %suite(Room-View Generator)
  -- %rollback(manual)

  -- %test(Creating a new view)
  -- %aftertest(cleanup_test_view)
  procedure create_view;

  procedure cleanup_test_view;

end;
/