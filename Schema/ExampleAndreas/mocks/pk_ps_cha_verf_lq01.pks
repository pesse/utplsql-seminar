create or replace package pk_ps_cha_verf_lq01 as
  function open_cv_zu_bsw_nr(
      p_ps_cha_verf_cv pk_ps_cha_verf_ll.t_ps_cha_verf_cv,
      p_mdt_nr varchar2,
      p_egt_nr varchar2,
      p_bsw_nr varchar2) return boolean;
end;
/