call utl_db_object.drop_if_exists('UT_DEATHSTAR_SECURITY_WELCOME', 'PACKAGE');
call utl_db_object.drop_if_exists('UT_DEATHSTAR_FRIEND_OR_FOE', 'PACKAGE');
call utl_db_object.drop_if_exists('DEATHSTAR_SECURITY', 'PACKAGE');
call utl_db_object.drop_if_exists('T_PERSON_APPEARANCE');
call utl_db_object.drop_if_exists('V_DEATHSTAR_PROTOCOLS');
call utl_db_object.drop_if_exists('DEATHSTAR_PROTOCOL_ACTIVE');
call utl_db_object.drop_if_exists('DEATHSTAR_PROTOCOLS');

@deathstar_protocols.Table.sql
@deathstar_protocol_active.Table.sql
@v_deathstar_protocols.View.sql
@t_person_appearance.tps
@deathstar_security.pks
@deathstar_security.pkb

insert into deathstar_protocols ( label, defense_mode, alert_level, power_level ) values ( 'All cool', 'BE_KIND', 'LOW', 20);
insert into deathstar_protocols ( label, defense_mode, alert_level, power_level ) values ( 'Is something wrong?', 'BE_SUSPICIOUS', 'MEDIUM', 65);
insert into deathstar_protocols ( label, defense_mode, alert_level, power_level ) values ( 'We''re under attack', 'SHOOT_FIRST_ASK_LATER', 'HIGH', 100);

insert into deathstar_protocol_active (id) select id from deathstar_protocols where label = 'All cool';

commit;

exit