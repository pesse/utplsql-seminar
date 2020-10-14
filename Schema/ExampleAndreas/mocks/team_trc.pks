create or replace package team_trc as
  procedure trc( a integer, b varchar2 );
  function init_func( a varchar2) return varchar2;
  procedure exit_func( a varchar2, b varchar2);
end;
/