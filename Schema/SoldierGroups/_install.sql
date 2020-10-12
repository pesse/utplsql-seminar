-- Cleanup
call utl_db_object.drop_if_exists('GROUP_MANAGEMENT', 'PACKAGE');
call utl_db_object.drop_if_exists('GROUP_UTIL', 'PACKAGE');
call utl_db_object.drop_if_exists('SOLDIER_UTIL', 'PACKAGE');
call utl_db_object.drop_if_exists('GROUP_FACTORY', 'PACKAGE');

call utl_db_object.drop_if_exists('V_SOLDIERS');
call utl_db_object.drop_if_exists('V_GROUP_SOLDIERS');
call utl_db_object.drop_if_exists('V_GROUPS');

call utl_db_object.drop_if_exists('GROUP_MEMBERS');
call utl_db_object.drop_if_exists('GROUPS');
call utl_db_object.drop_if_exists('SOLDIERS');
call utl_db_object.drop_if_exists('GROUP_TYPES');
call utl_db_object.drop_if_exists('SOLDIER_RANKS');

call utl_db_object.drop_if_exists('GROUPS_SEQ');
call utl_db_object.drop_if_exists('SOLDIERS_SEQ');

@internal/soldier_ranks.Table.sql
@internal/soldiers.Table.sql
@internal/soldiers_seq.Sequence.sql

/* Insert ranks */
insert into soldier_ranks (id, label, hierarchy_level) values (1, 'General', 19);
insert into soldier_ranks (id, label, hierarchy_level) values (2, 'Colonel', 18);
insert into soldier_ranks (id, label, hierarchy_level) values (3, 'Major', 17);
insert into soldier_ranks (id, label, hierarchy_level) values (4, 'Captain', 16);
insert into soldier_ranks (id, label, hierarchy_level) values (5, 'Lieutenant', 15);
insert into soldier_ranks (id, label, hierarchy_level) values (6, 'Ensign', 14);
insert into soldier_ranks (id, label, hierarchy_level) values (7, 'Sergeant', 13);
insert into soldier_ranks (id, label, hierarchy_level) values (8, 'Corporal', 12);
insert into soldier_ranks (id, label, hierarchy_level) values (9, 'Specialist', 11);
insert into soldier_ranks (id, label, hierarchy_level) values (10, 'Private', 10);

commit;

@internal/group_types.Table.sql

/* Insert Group Types */
insert into group_types (id, label, min_size, max_size, min_lead_rank) values (1, 'Fire team', 2, 3, 12);
insert into group_types (id, label, min_size, max_size, min_lead_rank) values (2, 'Squad', 5, 10, 13);
insert into group_types (id, label, min_size, max_size, min_lead_rank) values (3, 'Platoon', 50, 100, 15);
insert into group_types (id, label, min_size, max_size, min_lead_rank) values (4, 'Company', 100, 300, 16);
insert into group_types (id, label, min_size, max_size, min_lead_rank) values (5, 'Battalion', 700, 1500, 17);
insert into group_types (id, label, min_size, max_size, min_lead_rank) values (6, 'Brigade', 5000, 7500, 18);
insert into group_types (id, label, min_size, max_size, min_lead_rank) values (7, 'Division', 20000, 40000, 19);
insert into group_types (id, label, min_size, max_size, min_lead_rank) values (8, 'Assault Group', 40000, 100000, 20);

commit;

@internal/groups.Table.sql
@internal/groups_seq.Sequence.sql
@internal/groups_set_nr.Trigger.sql


@internal/group_members.Table.sql

-- packages
@public/group_util.pks
@public/group_util.pkb
@public/soldier_util.pks
@public/soldier_util.pkb
@public/group_management.pks
@public/group_management.pkb
@public/group_factory.pks
@public/group_factory.pkb


-- Views
@public/v_group_names.View.sql
@public/v_groups.View.sql
@public/v_groups_save.Trigger.sql
@public/v_group_soldiers.View.sql
@public/v_soldiers.View.sql
@public/v_soldiers_save.Trigger.sql


@install/create_soldiers.sql
@install/create_groups.sql

call group_management.fill_groups(1);

commit;

exit