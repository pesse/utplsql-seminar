create or replace package alignment_detector as

  function detect_from_name( i_name varchar2 )
    return varchar2;

end;
/