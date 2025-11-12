
create table characters (
  id integer not null primary key,
  name varchar2(100) unique,
  faction varchar2(100)
);

create table favorite_food (
  character_id integer not null references characters( id ),
  food varchar2(4000)
);

insert into characters values (1, 'Chewbacca', 'Rebels');
insert into characters values (2, 'Darth Vader', 'Empire');
insert into characters values (3, 'Jar Jar Binks', 'Rebels');

insert into favorite_food values ( 1, 'Grilled Pork');
insert into favorite_food values ( 1, 'Cooked Pork');
insert into favorite_food values ( 1, 'Raw Pork');
insert into favorite_food values ( 2, 'Cheesecake');

commit;

-- As soon as we hit more than 2 levels of nesting, we need to use subqueries instead
select
xmlserialize(
    document
    xmlelement(
      "Factions",
      xmlagg(
        xmlelement(
          "Faction",
          xmlattributes(c.faction as "name"),
          xmlelement("Characters",
            xmlagg(
              xmlelement("Character",
                xmlforest(
                  c.name as "name"
                ),
                xmlelement("favouriteFoods",
                  (
                    select
                      xmlagg(
                        xmlforest(
                          ff.food as "food"
                        )
                      )
                    from favorite_food ff
                    where c.id = ff.character_id
                  )
                )
              )
            )
          )
        )
      )
    )
    as clob indent size = 2
  )
from characters c
group by faction
;

-- Example: Save XMLSERIALIZE output to an XMLTYPE column
-- Create a table with an XMLTYPE column to store the serialized XML
create table faction_data (
  faction_name varchar2(100) primary key,
  xml_data xmltype
);

-- Insert the XMLSERIALIZE result into the XMLTYPE column
insert into faction_data (faction_name, xml_data)
select
  c.faction,
  xmltype(
    xmlserialize(
      document
      xmlelement(
        "Faction",
        xmlattributes(c.faction as "name"),
        xmlelement("Characters",
          xmlagg(
            xmlelement("Character",
              xmlforest(
                c.name as "name"
              ),
              xmlelement("favouriteFoods",
                (
                  select
                    xmlagg(
                      xmlforest(
                        ff.food as "food"
                      )
                    )
                  from favorite_food ff
                  where c.id = ff.character_id
                )
              )
            )
          )
        )
      )
      as clob indent size = 2
    )
  )
from characters c
group by faction;

commit;

-- Query the stored XML back out
select faction_name, xml_data
from faction_data;

-- Extract specific data from the stored XML using XQuery
select
  faction_name,
  xt.character_name,
  xt.food
from faction_data fd,
  xmltable(
    '/Faction/Characters/Character'
    passing fd.xml_data
    columns
      character_name varchar2(100) path 'name',
      food xmltype path 'favouriteFoods'
  ) xt;

-- Anonymous utPLSQL test: Check if Darth Vader prefers Cheesecake
declare
  l_favorite_foods sys_refcursor;
  l_expected_foods sys_refcursor;
begin
  -- Get Darth Vader's favorite foods from the XML
  open l_favorite_foods for
    select xt.food
    from faction_data fd,
      xmltable(
        '/Faction/Characters/Character[name="Darth Vader"]/favouriteFoods/food'
        passing fd.xml_data
        columns
          food varchar2(4000) path '.'
      ) xt;

  -- Expected result: Cheesecake
  open l_expected_foods for
    select 'Cheesecake' as food from dual;

  -- Test assertion
  ut.expect(l_favorite_foods).to_equal(l_expected_foods);
end;
/

-- Anonymous utPLSQL test: Compare XMLTYPE with whitespace normalization
declare
  l_actual_xml xmltype;
  l_expected_xml xmltype;
  l_actual_str varchar2(32767);
  l_expected_str varchar2(32767);

  -- Helper function to normalize XML whitespace
  function normalize_xml_whitespace(p_xml_str varchar2) return varchar2 is
    l_result varchar2(32767);
  begin
    l_result := p_xml_str;
    -- Remove all whitespace between tags
    l_result := regexp_replace(l_result, '>\s+<', '><');
    -- Remove leading and trailing whitespace (including newlines)
    l_result := regexp_replace(l_result, '(^\s+|\s+$)', '');
    return l_result;
  end normalize_xml_whitespace;

begin
  -- Extract Darth Vader's favouriteFoods XML fragment
  select xt.food
  into l_actual_xml
  from faction_data fd,
    xmltable(
      '/Faction/Characters/Character[name="Darth Vader"]/favouriteFoods'
      passing fd.xml_data
      columns
        food xmltype path '.'
    ) xt;

  -- Expected XML structure
  l_expected_xml := xmltype('<favouriteFoods><food>Cheesecake</food></favouriteFoods>');

  -- Normalize both XML strings
  l_actual_str := normalize_xml_whitespace(l_actual_xml.getclobval());
  l_expected_str := normalize_xml_whitespace(l_expected_xml.getclobval());

  -- Test assertion: Compare normalized XML strings
  ut.expect(l_actual_str).to_equal(l_expected_str);
end;
/


-- Cleanup
drop table faction_data purge;
drop table favorite_food purge;
drop table characters purge;
