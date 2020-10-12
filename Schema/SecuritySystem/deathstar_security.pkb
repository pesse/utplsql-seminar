create or replace package body deathstar_security as

  function friend_or_foe( i_person_data t_person_appearance )
    return varchar2
  as
    begin
      if ( i_person_data.weapon_type = 'lightsaber') then
        if ( i_person_data.weapon_color in ('red','orange')) then
          return 'FRIEND';
        else
          return 'FOE';
        end if;
      end if;

      if ( i_person_data.cloth_type = 'hooded_robe' ) then
        if ( i_person_data.cloth_color = 'black') then
          return 'FRIEND';
        elsif ( i_person_data.cloth_color = 'red') then
          return 'UNKNOWN';
        else
          return 'FOE';
        end if;
      end if;

      if ( i_person_data.cloth_type = 'armor' ) then
        if ( i_person_data.cloth_color = 'white') then
          return 'FRIEND';
        elsif ( i_person_data.cloth_color in ('blue/black', 'orange')) then
          return 'FOE';
        else
          return 'UNKNOWN';
        end if;
      end if;

      return 'UNKNOWN';
    end;
end;
/