-- Let's define the tests we need first
create or replace package ut_deathstar_security_welcome as
  -- %suite(Deathstar-Security: Welcome message)
  -- %suitepath(ut_deathstar.defense)

  -- %beforeall
  procedure setup_protocol;

  -- %test(We expect to receive the controlled protocol)
  procedure we_get_the_expected_protocol;

  -- %context(When protocol in Defense-Mode: BE_KIND)
		-- %name(be_kind)

		-- %beforeall
		procedure setup_protocol_be_kind;

		-- %test(Friend is welcomed)
		procedure be_kind_friend_is_welcomed;

		-- %test(Foe is shouted at)
		procedure be_kind_foe_is_shouted_at;

		-- %test(Unknown is welcomed)
		procedure be_kind_unknown_is_welcomed;
	-- %endcontext

  -- %context(When protocol in Defense-Mode: BE_SUSPICIOUS)
		-- %name(be_suspicious)

		-- %beforeall
		procedure setup_protocol_be_suspicious;

		-- %test(Friend is welcomed)
		procedure be_suspicious_friend_is_welcomed;

		-- %test(Foe is shouted at)
		procedure be_suspicious_foe_is_shouted_at;

		-- %test(Unknown is asked whether they are a jedi)
		procedure be_suspicious_unknown_is_asked;
	-- %endcontext

  -- %context(When protocol in Defense-Mode: SHOOT_FIRST_ASK_LATER)
		-- %name(be_aggressive)

		-- %beforeall
		procedure setup_protocol_be_aggressive;

		-- %test(Friend is welcomed)
		procedure be_aggressive_friend_is_welcomed;

		-- %test(Foe is shouted at)
		procedure be_aggressive_foe_is_shouted_at;

		-- %test(Unknown is shouted at)
		procedure be_aggressive_unknown_is_shouted_at;
	-- %endcontext

end;
/



create or replace package body ut_deathstar_security_welcome as

  g_friend_appearance t_person_appearance := new t_person_appearance('lightsaber', 'red', null, null);
  g_foe_appearance t_person_appearance := new t_person_appearance('lightsaber', 'blue', null, null);
  g_unknown_appearance t_person_appearance := new t_person_appearance('blaster', 'red', 'armor', 'green');

  procedure setup_protocol
  as
    begin
      insert into deathstar_protocols (id, label, defense_mode)
        values ( -1, 'Test-Protocol', 'toBeDefined');

      update deathstar_protocol_active set id = -1;
    end;

  procedure we_get_the_expected_protocol
  as
    begin
      -- Set Defense-mode
      update deathstar_protocols set defense_mode = 'BE_KIND' where id = -1;

      ut.expect(protocol_security.active_protocol().defense_mode)
        .to_equal('BE_KIND');

      update deathstar_protocols set defense_mode = 'BE_SUSPICIOUS' where id = -1;

      ut.expect(protocol_security.active_protocol().defense_mode)
        .to_equal('BE_SUSPICIOUS');
    end;

  procedure setup_protocol_be_kind
  as
    begin
      update deathstar_protocols set defense_mode = 'BE_KIND' where id = -1;
    end;

  procedure be_kind_friend_is_welcomed
  as
    begin
      ut.expect(protocol_security.welcome(g_friend_appearance))
        .to_equal('Be welcome!');
    end;

  procedure be_kind_foe_is_shouted_at
  as
    begin
      ut.expect(protocol_security.welcome(g_foe_appearance))
        .to_equal('Die rebel scum!');
    end;

  procedure be_kind_unknown_is_welcomed
  as
    begin
      ut.expect(protocol_security.welcome(g_unknown_appearance))
        .to_equal('Be welcome!');
    end;

  procedure setup_protocol_be_suspicious
  as
    begin
      update deathstar_protocols set defense_mode = 'BE_SUSPICIOUS' where id = -1;
    end;

  procedure be_suspicious_friend_is_welcomed
  as
    begin
      ut.expect(protocol_security.welcome(g_friend_appearance))
        .to_equal('Be welcome!');
    end;

  procedure be_suspicious_foe_is_shouted_at
  as
    begin
      ut.expect(protocol_security.welcome(g_foe_appearance))
        .to_equal('Die rebel scum!');
    end;

  procedure be_suspicious_unknown_is_asked
  as
    begin
      ut.expect(protocol_security.welcome(g_unknown_appearance))
        .to_equal('Are you a jedi?');
    end;

  procedure setup_protocol_be_aggressive
  as
    begin
      update deathstar_protocols set defense_mode = 'SHOOT_FIRST_ASK_LATER' where id = -1;
    end;

  procedure be_aggressive_friend_is_welcomed
  as
    begin
      ut.expect(protocol_security.welcome(g_friend_appearance))
        .to_equal('Be welcome!');
    end;

  procedure be_aggressive_foe_is_shouted_at
  as
    begin
      ut.expect(protocol_security.welcome(g_foe_appearance))
        .to_equal('Die rebel scum!');
    end;

  procedure be_aggressive_unknown_is_shouted_at
  as
    begin
      ut.expect(protocol_security.welcome(g_unknown_appearance))
        .to_equal('Die rebel scum!');
    end;
end;
/


call ut.run('ut_deathstar_security_welcome');

-- Now we can implement the functionality, one piece by another
create or replace package body protocol_security as
    /* Returns the active security protocol of the deathstar
   */
    function active_protocol
        return deathstar_protocols%rowtype
    as
        l_result deathstar_protocols%rowtype;
    begin
        select p.* into l_result
        from deathstar_protocols p
                 inner join deathstar_protocol_active pa
                            on p.id = pa.id;
        return l_result;
    end;

    function welcome( i_person_data t_person_appearance )
        return varchar2
    as
        const_friend constant varchar2(10) := 'FRIEND';
        const_foe constant varchar2(10) := 'FOE';

        l_active_defense_mode deathstar_protocols.defense_mode%type;
        l_friend_or_foe varchar2(100);
    begin
        l_active_defense_mode := active_protocol().defense_mode;
        l_friend_or_foe := deathstar_security.friend_or_foe(i_person_data);

        if ( l_friend_or_foe = const_friend ) then
            return 'Be welcome!';
        elsif ( l_friend_or_foe = const_foe ) then
            return 'Die rebel scum!';
        end if;

        case l_active_defense_mode
            when 'BE_KIND' then
                return 'Be welcome!';
            when 'BE_SUSPICIOUS' then
                return 'Are you a jedi?';
            when 'SHOOT_FIRST_ASK_LATER' then
                return 'Die rebel scum!';
            else
                raise_application_error(-20000, 'Ooops, no welcome');
            end case;
    end;
end;
/


call ut.run('ut_deathstar_security_welcome');