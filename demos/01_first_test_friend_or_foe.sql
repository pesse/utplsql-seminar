-- TYPE to have all the arguments needed in one place
-- (and make it easier to add to this in the future)
create or replace type t_person_appearance force is object (
  weapon_type varchar2(50),
  weapon_color varchar2(50)
);
/

-- Friend/Foe Functionality
create or replace package deathstar_security as

  /* Decides whether a person is friend or foe,
     based on their appearance
   */
  function friend_or_foe( i_person_data t_person_appearance )
    return varchar2;
end;
/

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

      return 'UNKNOWN';
    end;
end;
/

-- Simple Test via SQL
select
    deathstar_security.friend_or_foe(t_person_appearance(
        'lightsaber', 'red' ))
from dual;


-- Simple Test via utPLSQL
begin
    ut.expect(
        deathstar_security.friend_or_foe(t_person_appearance(
            'lightsaber', 'red' ))
    ).to_equal('FRIEND');
end;
/

-- Test Case via utPLSQL
create or replace package ut_deathstar_friend_or_foe as
  -- %suite(Friend or Foe detection)
	-- %suitepath(ut_deathstar.defense)

  -- %test(Red lightsaber means friend)
  procedure lightsaber_red_means_friend;

  -- %test(Blue lightsaber means foe)
  procedure lightsaber_blue_means_foe;
end;
/

create or replace package body ut_deathstar_friend_or_foe as
  procedure lightsaber_red_means_friend as
  begin
    ut.expect(deathstar_security.friend_or_foe(t_person_appearance('lightsaber', 'red')))
      .to_equal('FRIEND');
  end;

  procedure lightsaber_blue_means_foe as
  begin
    ut.expect(deathstar_security.friend_or_foe(t_person_appearance('lightsaber', 'blue')))
      .to_equal('FOE');
  end;
end;
/

begin ut.run('ut_deathstar_friend_or_foe'); end;
/

select * from ut.run('ut_deathstar_friend_or_foe');