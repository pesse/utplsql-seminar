create or replace package body utl_db_object as

  function is_known_object_type( i_object_type varchar2 )
    return boolean
  as
  begin
    return i_object_type in ('SEQUENCE','TABLE','VIEW','MATERIALIZED VIEW','PACKAGE','PROCEDURE','FUNCTION','TRIGGER','TYPE');
  end;

  function get_type(
    i_object_name in varchar2_nn
  ) return varchar2
  as
    l_result varchar2(128);
  begin
    select object_type into l_result
      from user_objects
      where object_name = i_object_name;
    return l_result;
  exception
    when no_data_found then
      return null;
  end;

  procedure drop_if_exists(
    i_object_name in varchar2_nn,
    i_object_type in varchar2 default null
  )
  as
    l_exists integer;
    l_object_type varchar2(128) := coalesce(i_object_type, get_type(i_object_name));
  begin
    if not is_known_object_type(l_object_type) then
      raise_application_error(-20000, 'Unknown object-type you want to delete: '||l_object_type);
    end if;

    if l_object_type is null then
      return;
    end if;

    select count(*) into l_exists
      from user_objects
      where object_name = i_object_name
        and object_type = l_object_type;

    if l_exists > 0 then
      execute immediate 'drop ' || l_object_type || ' "' || dbms_assert.simple_sql_name(i_object_name) || '"';
    end if;
  end;

end;
/