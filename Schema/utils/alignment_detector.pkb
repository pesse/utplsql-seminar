create or replace package body alignment_detector as

  function detect_from_name( i_name varchar2 )
    return varchar2
  as
  begin
    if i_name like 'Darth%' or sith_archive.contains_name(i_name) then
      return 'dark';
    else
      return 'light';
    end if;
  end;

end;
/