-- This requires Demos SecuritySystem and DeathStarRooms to be installed!

-- Running a test-suite
call ut.run('ut_deathstar_friend_or_foe');

-- Running a suite by path
call ut.run(':ut_deathstar');

-- Running a suite by path - by selection
select * from table(ut.run(':ut_deathstar'));

-- Running only a part of hierarchy
select * from table(ut.run(':ut_deathstar.rooms'));


select * from table(ut.run(':ut_deathstar.defense.ut_deathstar_friend_or_foe'));

select * from table(ut.run(':ut_deathstar.defense.ut_deathstar_security_welcome'));

-- Running only a context inside a suite
select * from table(ut.run(':ut_deathstar.defense.ut_deathstar_security_welcome.be_aggressive'));


-- Adding a Parent-Suite
create or replace package ut_deathstar as
  -- %suite(Tests around the Deathstar)

end;
/

select * from table(ut.run(':ut_deathstar'));

select * from table(ut.run('ut_deathstar'));


-- Use it for some heavy-lifting setup
create or replace package ut_deathstar as
  -- %suite(Tests around the Deathstar)

  -- %beforeall
  procedure setup_deathstar;
end;
/

create or replace package body ut_deathstar as
  procedure setup_deathstar
  as
    l_curtime timestamp := current_timestamp;
    begin
      dbms_output.put_line('Setting up the deathstar');
      while current_timestamp-l_curtime < interval '3' second loop
        null;
      end loop;
    end;
end;
/

-- Calling the whole suite-hierarchy
select * from table(ut.run(':ut_deathstar'));


-- It also works when only running a part of the suite-path
select * from table(ut.run(':ut_deathstar.rooms'));


-- It also works when calling a suite directly
select * from table(ut.run('ut_deathstar_friend_or_foe'));

-- Moar storytelling with Nested contexts
-- Let's get rid of that parent suite so we don't have to deal
-- with the SLEEP
drop package ut_deathstar;

-- Let's have the Friend-or-Foe package organized differently (no content change!)
select * from table(ut.run('ut_deathstar_friend_or_foe'));

-- By Suitepath
select * from table(ut.run(':ut_deathstar.defense.ut_deathstar_friend_or_foe'));

-- Just the lightsaber context
select * from table(ut.run(':ut_deathstar.defense.ut_deathstar_friend_or_foe.lightsaber'));

-- Just the robe context
select * from table(ut.run(':ut_deathstar.defense.ut_deathstar_friend_or_foe.no_lightsaber.robe'));





-- How to deal with long-running tests



create or replace package ut_defeat_rebels as
  -- %suite(Defeating the rebels - can take a while)
  -- %suitepath(imperium)
  -- %tags(long_running)

  -- %test(Defeat them)
  -- %tags(very_long_running)
  procedure defeat_them;

  -- %test(Boast about your victory)
  -- %tags(quick)
  procedure boast;
end;
/


create or replace package body ut_defeat_rebels as
  procedure defeat_them
  as
    l_curtime timestamp := current_timestamp;
    begin
      while current_timestamp-l_curtime < interval '5' second loop
        null;
      end loop;
    end;

  procedure boast
  as
    begin
      dbms_output.put_line('WE ARE SOOOO AWESOME!');
    end;
end;
/

-- Run a specific tag
select * from table(ut.run('', a_tags=>'quick'));


-- Run all with any of the given tags
select * from table(ut.run('', a_tags=>'quick,long_running'));


-- Run all except a tag
select * from table(ut.run('', a_tags=>'-very_long_running'));






---------------------------------
-- Cleanup
----------------------------------
drop package ut_deathstar;
drop package ut_defeat_rebels;