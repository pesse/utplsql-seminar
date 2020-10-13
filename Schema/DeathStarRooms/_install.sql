call utl_db_object.drop_if_exists('UT_DEATHSTAR_ROOM_MANAGER', 'PACKAGE');
call utl_db_object.drop_if_exists('UT_DEATHSTAR_ROOM_VIEW_GENERATOR', 'PACKAGE');
call utl_db_object.drop_if_exists('DEATHSTAR_ROOM_MANAGER', 'PACKAGE');
call utl_db_object.drop_if_exists('DEATHSTAR_ROOM_VIEW_GENERATOR', 'PACKAGE');
call utl_db_object.drop_if_exists('DEATHSTAR_ROOMS', 'TABLE');
call utl_db_object.drop_if_exists('DEATHSTAR_SECTIONS', 'TABLE');

@deathstar_sections.Table.sql
@deathstar_rooms.Table.sql

@deathstar_room_manager.pks
@deathstar_room_manager.pkb

@deathstar_room_view_generator.pks
@deathstar_room_view_generator.pkb

commit;

exit