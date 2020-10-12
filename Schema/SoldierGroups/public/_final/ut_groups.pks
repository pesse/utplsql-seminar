create or replace package ut_groups as
  -- %suite(Groups View V_GROUPS)

  -- %beforeall
  procedure setup;

  -- %test(Update group-name via view)
  procedure update_group_name;

  -- %test(Group with 2 parents shows generated name and full name)
  procedure select_3rd_level_team;

  -- %test(Group with parents and honor name shows honor name but generated full name)
  procedure select_honor_team;
end;
/