insert into deathstar_sections (id, label)
      values(1, 'Sektion 7');

begin
    deathstar_room_manager.add_room('Vaders Chamber', 1);
    deathstar_room_manager.add_room('Vaders Chamber 2', 1);
    deathstar_room_manager.add_room('Bridge', 1);
end;
/

commit;
select * from deathstar_sections;
select * from deathstar_rooms;

begin
  deathstar_room_view_generator.CREATE_VIEW('V_ROOM_VADER', sys.odcinumberlist(371));
end;
/

select * from V_ROOM_VADER_TEST;
drop view v_room_vader;


select * from deathstar_rooms;
delete from deathstar_rooms where section_id = -1;
delete from deathstar_sections where id = -1;
commit;

select * from table(ut.run('ut_deathstar_room_view_generator'));