create or replace package body sith_archive as

  procedure add_sith( i_name varchar2 ) as
  begin
    insert into sith_persons ( name )
      values ( i_name );
  end;

  procedure set_alive( i_name varchar2, i_alive boolean ) as
    l_alive_int integer := case when i_alive then 1 else 0 end;
  begin
    update sith_persons set alive = l_alive_int where name = i_name;
  end;

  function contains_name( i_name varchar2 )
    return boolean
  as
    l_count integer;
  begin
    select count(*) into l_count
      from sith_persons
      where lower(name) = lower(i_name);
    return l_count > 0;
  end;
end;
/