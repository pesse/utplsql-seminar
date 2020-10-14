create or replace package body pk_ps_cha_verf_ll as

  function loop_cv_ps_cha_verf(
    p_ps_cha_verf_cv t_ps_cha_verf_cv,
    p_ps_cha_verf ps_cha_verf%rowtype
  ) return boolean as
  begin
    return false;
  end;

  function db_upd(
    p_ps_cha_verf ps_cha_verf%rowtype,
    p_trans varchar2
  ) return boolean as
  begin
    return true;
  end;
end;