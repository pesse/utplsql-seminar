create or replace package body "PK_PS_CHA_VERF_MD01" is
  -- @AOP(advice=AOP_TRANS)
  -- @AOP(advice=AOP_TRACE)
  -- @AOP(advice=AOP_CLOSE_CURSOR)
  function aendern_bsw_nr(
    p_input_cursor in pk_ps_cha_verf_ll.t_ps_cha_verf_cv,
    p_neue_bsw_nr in varchar2,
    p_neue_bsw_bez in varchar2 default null,
    p_trans in varchar2
  ) return boolean is
    save_func_var_curr varchar2(255);
    save_func_var_prev varchar2(255);
    save_trc_text      varchar2(255);
    pro_exception_94094 exception;
    pragma exception_init (pro_exception_94094, -20000);
    var_v_sql_intern_num_1 number;
    var_v_sql_intern_num_2 number;
    k_stp_name constant varchar2(255) := 'aendern_bsw_nr';
    e_error_return exception;
    v_ps_cha_verf_cv pk_ps_cha_verf_ll.t_ps_cha_verf_cv;
    v_ps_cha_verf    ps_cha_verf%rowtype;
  begin
    -- AOP-ADVICE:AOP_TRACE  ; Added by AOP_PROCESSOR (1.2.0)
    save_func_var_curr := k_pk_name || k_stp_name;
    save_func_var_prev := team_trc.init_func(save_func_var_curr);
    team_trc.trc(1, 'i:MDT_NR       >' || p_mdt_nr || '<');
    team_trc.trc(1, 'i:EGT_NR       >' || p_egt_nr || '<');
    team_trc.trc(1, 'i:ALTE_BSW_NR  >' || p_alte_bsw_nr || '<');
    team_trc.trc(1, 'i:NEUE_BSW_NR  >' || p_neue_bsw_nr || '<');
    team_trc.trc(1, 'i:NEUE_BSW_BEZ >' || p_neue_bsw_bez || '<');
    team_trc.trc(1, 'i:TRANS        >' || p_trans || '<');
    -- END OF AOP-ADVICE

    -- AOP-ADVICE:AOP_TRANS  ; Added by AOP_PROCESSOR (1.2.0)
    if pk_tt_utilities.in_db_trigger = 0
    then
      savepoint sv_aendern_bsw_nr;
    end if;
    -- END OF AOP-ADVICE

    if p_mdt_nr is null or
       p_alte_bsw_nr is null or
       p_neue_bsw_nr is null or
       p_trans is null
    then
      team_trc.trc(9, 'Parameterfehler!');
      team_fehler.push_pro_nr('04700', k_pk_name || k_stp_name);
      raise e_error_return;
    end if;

    if not p_input_cursor%open then
    if not pk_ps_cha_verf_lq01.open_cv_zu_bsw_nr(
      p_ps_cha_verf_cv => v_ps_cha_verf_cv,
      p_mdt_nr => p_mdt_nr,
      p_egt_nr => p_egt_nr,
      p_bsw_nr => p_alte_bsw_nr)
    then
      raise e_error_return;
    end if;

    while pk_ps_cha_verf_ll.loop_cv_ps_cha_verf(
      p_ps_cha_verf_cv => v_ps_cha_verf_cv,
      p_ps_cha_verf => v_ps_cha_verf)
    loop
      v_ps_cha_verf.bsw_nr := p_neue_bsw_nr;
      v_ps_cha_verf.bsw_bez := nvl(p_neue_bsw_bez, v_ps_cha_verf.bsw_bez);
      if not pk_ps_cha_verf_ll.db_upd(
        p_ps_cha_verf => v_ps_cha_verf,
        p_trans => p_trans)
      then
        raise e_error_return;
      end if;
    end loop;

    -- AOP-ADVICE:AOP_CLOSE_CURSOR  ; Added by AOP_PROCESSOR (1.2.0)
    if v_ps_cha_verf_cv%isopen
    then
      close v_ps_cha_verf_cv;
    end if;
    -- END OF AOP-ADVICE

    team_trc.exit_func(save_func_var_curr, save_func_var_prev);
    return true;
  exception
    when e_error_return then

      -- AOP-ADVICE:AOP_TRACE  ; Added by AOP_PROCESSOR (1.2.0)
      team_trc.trc(9, 'Exception e_error_return in ' || k_pk_name || k_stp_name || ' (' || save_trc_text || ')');
      team_trc.trc(9, 'i:MDT_NR       >' || p_mdt_nr || '<');
      team_trc.trc(9, 'i:EGT_NR       >' || p_egt_nr || '<');
      team_trc.trc(9, 'i:ALTE_BSW_NR  >' || p_alte_bsw_nr || '<');
      team_trc.trc(9, 'i:NEUE_BSW_NR  >' || p_neue_bsw_nr || '<');
      team_trc.trc(9, 'i:NEUE_BSW_BEZ >' || p_neue_bsw_bez || '<');
      team_trc.trc(9, 'i:TRANS        >' || p_trans || '<');
      -- END OF AOP-ADVICE

      -- AOP-ADVICE:AOP_CLOSE_CURSOR  ; Added by AOP_PROCESSOR (1.2.0)
      if v_ps_cha_verf_cv%isopen
      then
        close v_ps_cha_verf_cv;
      end if;
      -- END OF AOP-ADVICE

      -- AOP-ADVICE:AOP_TRANS  ; Added by AOP_PROCESSOR (1.2.0)
      if pk_tt_utilities.in_db_trigger = 0
      then
        team_trc.trc(9, '===> ROLLBACK TO SAVEPOINT');
        rollback to savepoint sv_aendern_bsw_nr;
      end if;
      -- END OF AOP-ADVICE

      team_fehler.push_pro_nr('04701', k_pk_name || k_stp_name);
      team_trc.exit_func(save_func_var_curr, save_func_var_prev);
      return false;
    when others then
      -- AOP-ADVICE:AOP_TRACE  ; Added by AOP_PROCESSOR (1.2.0)
      team_trc.trc(9, 'Exception others in ' || k_pk_name || k_stp_name || ' (' || save_trc_text || ')');
      team_trc.trc(9, 'i:MDT_NR       >' || p_mdt_nr || '<');
      team_trc.trc(9, 'i:EGT_NR       >' || p_egt_nr || '<');
      team_trc.trc(9, 'i:ALTE_BSW_NR  >' || p_alte_bsw_nr || '<');
      team_trc.trc(9, 'i:NEUE_BSW_NR  >' || p_neue_bsw_nr || '<');
      team_trc.trc(9, 'i:NEUE_BSW_BEZ >' || p_neue_bsw_bez || '<');
      team_trc.trc(9, 'i:TRANS        >' || p_trans || '<');
      -- END OF AOP-ADVICE

      -- AOP-ADVICE:AOP_CLOSE_CURSOR  ; Added by AOP_PROCESSOR (1.2.0)
      if v_ps_cha_verf_cv%isopen
      then
        close v_ps_cha_verf_cv;
      end if;
      -- END OF AOP-ADVICE

      -- AOP-ADVICE:AOP_TRANS  ; Added by AOP_PROCESSOR (1.2.0)
      if pk_tt_utilities.in_db_trigger = 0
      then
        team_trc.trc(9, '===> ROLLBACK');
        rollback;
      end if;

      -- END OF AOP-ADVICE
      team_fehler.set_fehler(0, sqlcode, sqlerrm);
      team_fehler.push_pro_nr('04702', k_pk_name || k_stp_name);
      team_trc.exit_func(save_func_var_curr, save_func_var_prev);
      raise pro_exception_94094;
  end aendern_bsw_nr;

end pk_ps_cha_verf_md01;