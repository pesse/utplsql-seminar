create or replace package team_fehler as
  procedure push_pro_nr(a varchar2, b varchar2 );
  procedure set_fehler(a integer, b integer, c varchar2);
end;
/