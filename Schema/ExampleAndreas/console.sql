-- Input
declare
  l_result boolean;
  l_cursor pk_ps_cha_verf_ll.t_ps_cha_verf_cv;
begin
  if pk_ps_cha_verf_lq01.open_cv_zu_bsw_nr(
      p_ps_cha_verf_cv => l_cursor,
      p_mdt_nr => p_mdt_nr,
      p_egt_nr => p_egt_nr,
      p_bsw_nr => p_alte_bsw_nr) then
    null;
  end if;
  l_result := pk_ps_cha_verf_md01.aendern_bsw_nr(
    -- Direkter Input
    l_cursor,
    -- Direkter Input
    p_neue_bsw_nr => 'bsw neu',
    p_neue_bsw_bez => 'bsw bez',
    p_trans => 'demo'
  );
end;


select * from ps_cha_verf;


-- Output: 3 Spalten