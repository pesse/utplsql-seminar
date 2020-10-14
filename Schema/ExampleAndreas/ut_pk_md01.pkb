create or replace package ut_pk_md01 as

  procedure control_cursor as
    v_ps_cha_verf_cv pk_ps_cha_verf_ll.t_ps_cha_verf_cv;
  begin
    insert into ps_cha_verf
      values ();

    pk_ps_cha_verf_lq01.open_cv_zu_bsw_nr(
      p_ps_cha_verf_cv => v_ps_cha_verf_cv,
      p_mdt_nr => 'mdt',
      p_egt_nr => 'egt',
      p_bsw_nr => 'bsw');
  end;

end;
/