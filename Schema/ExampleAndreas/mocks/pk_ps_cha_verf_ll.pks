create or replace package pk_ps_cha_verf_ll as

  TYPE t_ps_cha_verf_cv IS REF CURSOR
      RETURN ps_cha_verf%ROWTYPE;

  function loop_cv_ps_cha_verf(
    p_ps_cha_verf_cv t_ps_cha_verf_cv,
    p_ps_cha_verf ps_cha_verf%rowtype
  ) return boolean;

  function db_upd(
    p_ps_cha_verf ps_cha_verf%rowtype,
    p_trans varchar2
  ) return boolean;
end;