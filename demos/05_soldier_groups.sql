-- This demo requires Schema/SoldierGroups/_install.sql to be run (which will take a while)

-- Let's look at the data we have
select * from v_groups;

-- Update a Group-Name: There is some logic
update v_groups set group_name = 'Rhevan''s Ghosts' where id = 1224;

select * from v_groups where id = 1224;

update v_groups set group_name = null where id = 1224;

select * from v_groups where id = 1224;

-- What can we do to extract functionality?
select * from groups where id = 1224;

select * from group_types;


-- Define example-based inputs/outputs + test cases
create or replace package ut_group_util as
  -- %suite(Group-Util)
  -- %suitepath(army.groups)

  -- %test(get_group_name returns name of group type and number)
  procedure get_group_name_normal;

  -- %test(get_group_name returns honor name if one is available)
  procedure get_group_name_honor;
end;
/

create or replace package body ut_group_util as

  procedure get_group_name_normal
  as
    begin
      ut.expect( group_util.get_group_name(1, 'Platoon')).to_equal('1st Platoon');
      ut.expect( group_util.get_group_name(2, 'Batallion')).to_equal('2nd Batallion');
      ut.expect( group_util.get_group_name(22, 'combat unit')).to_equal('22nd combat unit');
      ut.expect( group_util.get_group_name(53, 'ewok')).to_equal('53rd ewok');
      ut.expect( group_util.get_group_name(2556375, 'ewok')).to_equal('2556375th ewok');
    end;

  procedure get_group_name_honor
  as
    begin
      ut.expect( group_util.get_group_name(1, 'Platoon', 'Rhevan''s Ghosts')).to_equal('Rhevan''s Ghosts');
      ut.expect( group_util.get_group_name(5416, 'test', 'we just ignore the number')).to_equal('we just ignore the number');
    end;
end;
/

call ut.run('ut_group_util');

-- And Implement the behaviour
create or replace package group_util as

  subtype nn_varchar2 is varchar2 not null;

  function get_group_name( i_nr_in_group in positiven, i_type_label in nn_varchar2, i_honor_name in varchar2 default null )
    return varchar2 deterministic;
end;
/

create or replace package body group_util as

    function get_number_name( i_number in positiven ) return varchar2
    as
        l_mod int := mod(i_number,10);
    begin
        -- special handling for 11th and 12th
        if mod(i_number, 100) in (11, 12) then
            return to_char(i_number) || 'th';
        end if;

        return to_char(i_number) || case l_mod when 1 then 'st' when 2 then 'nd' when 3 then 'rd' else 'th' end;
    end;

    function get_group_name( i_nr_in_group in positiven, i_type_label in nn_varchar2, i_honor_name in varchar2 default null )
        return varchar2 deterministic
    as
    begin

        if ( i_honor_name is not null ) then
            return i_honor_name;
        else
            return get_number_name(i_nr_in_group) || ' ' || i_type_label;
        end if;

    end;
end;
/


call ut.run('ut_group_util');


-- More edge cases?