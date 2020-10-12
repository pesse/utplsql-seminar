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

  function get_group_name( i_nr_in_group in positiven, i_type_label in nn_varchar2, i_honor_name in varchar2 )
    return varchar2 deterministic
  as
    begin

      if ( i_honor_name is not null ) then
        return i_honor_name;
      else
        return get_number_name(i_nr_in_group) || ' ' || i_type_label;
      end if;

    end;

  function get_group_name ( i_group_id in simple_integer )
    return varchar2 result_cache
  as
    l_nr_in_group int;
    l_type_label varchar2(200);
    l_honor_name varchar2(200);
    begin

      select
        g.nr_in_group,
        gt.label,
        g.honor_name
      into
        l_nr_in_group,
        l_type_label,
        l_honor_name
      from groups g
        inner join group_types gt on g.group_type_fk = gt.id
      where g.id = i_group_id;

      return get_group_name(l_nr_in_group, l_type_label, l_honor_name);

    end;

  function count_group_members( i_group_id in integer )
    return integer
  as
    l_count int;
    begin
      select count(distinct gm.soldier_fk)
      into l_count
      from groups g
        left outer join group_members gm on g.id = gm.group_fk
      connect by prior g.id = g.parent_fk
      start with g.id = i_group_id;

      return l_count;
    end;
end;
/