create or replace package "PK_PS_CHA_VERF_MD01" is

  k_pk_name constant varchar2(32) := 'id';

  function aendern_bsw_nr(
    p_input_cursor in pk_ps_cha_verf_ll.t_ps_cha_verf_cv,
    p_neue_bsw_nr in varchar2,
    p_neue_bsw_bez in varchar2 default null,
    p_trans in varchar2
  ) return boolean;

end pk_ps_cha_verf_md01;