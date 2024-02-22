-- We have two tables that model our security protocol
create table deathstar_protocols (
    id integer not null primary key,
    label varchar2(256),
    defense_mode varchar2(32) not null
);

create table deathstar_protocol_active (
    id integer not null primary key,
    only_one number(1) default 1 not null,
    constraint deathstar_prot_act_fk
       foreign key ( id )
           references deathstar_protocols ( id )
               on delete cascade,
    constraint deathstar_prot_act_uq
       unique ( only_one ),
    constraint deathstar_prot_act_chk
       check ( only_one = 1 )
);

insert into deathstar_protocols (id, label, defense_mode) values (1, 'Low', 'BE_KIND');
insert into deathstar_protocols (id, label, defense_mode) values (2, 'Medium', 'BE_SUSPICIOUS');
insert into deathstar_protocols (id, label, defense_mode) values (3, 'High', 'SHOOT_FIRST_ASK_LATER');

insert into deathstar_protocol_active (id, only_one)  values (2, 1);

-- We start with defining the public API
create or replace package protocol_security as

    /* Returns the active security protocol of the deathstar
     */
    function active_protocol
        return deathstar_protocols%rowtype;

    /* Returns a welcome message based on the
       active Deathstar protocols DEFENSE_MODE
     */
    function welcome( i_person_data t_person_appearance )
        return varchar2;
end;
/


-- And have an implementation for active_protocol
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
        l_active_defense_mode deathstar_protocols.defense_mode%type;
        l_friend_or_foe varchar2(100);
    begin
        l_active_defense_mode := active_protocol().defense_mode;
        l_friend_or_foe := deathstar_security.friend_or_foe(i_person_data);

        -- TODO: Implement
    end;
end;
/


-- First, we need to control the indirect input
-- We can easily control the result of friend_or_foe, because we already have a input/output table
-- and the function is well-tested
-- So let's focus on active_protocol and start creating a test package
create or replace package ut_deathstar_security_welcome as
  -- %suite(Deathstar-Security: Welcome message)
  -- %suitepath(ut_deathstar.defense)

  -- %beforeall
  procedure setup_protocol;

  -- %test(We expect to receive the controlled protocol)
  procedure we_get_the_expected_protocol;

end;
/

create or replace package body ut_deathstar_security_welcome as

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
end;
/


call ut.run('ut_deathstar_security_welcome');


