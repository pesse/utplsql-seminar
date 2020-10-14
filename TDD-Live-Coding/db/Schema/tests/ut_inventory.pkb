create or replace package body ut_inventory as

  gc_inventory_name constant varchar2(200) := 'xxxxxTestItem1xxxxx';

  procedure import_inventory as
    c_actual sys_refcursor;
    c_expect sys_refcursor;
  begin
    inventory_manager.import();

    open c_actual for
      select * from tt_inventory_import;
    open c_expect for
      select 'BRIDGE' roomcode, 'Communicator' item       , 1 count from dual union all
      select 'VADER_CHAMBER'  , 'Lightsaber (red)'        , 3       from dual union all
      select 'VADER_CHAMBER'  , 'Han Solo (carbonated)'   , 1       from dual union all
      select 'VADER_CHAMBER'  , 'Lightsaber (blue) broken', 1       from dual
    ;
    ut.expect(c_actual).to_equal(c_expect)
      .join_by('ITEM');
  end;

  procedure add_item_inserts_into_inventory as
    l_row room_inventory%rowtype;
  begin
    inventory_manager.add_item( gc_inventory_name );

    select * into l_row from room_inventory where name = gc_inventory_name;
  end;

  procedure create_new_inventory_item as
    l_row room_inventory%rowtype;
  begin
    insert into tt_inventory_import (roomcode, item, count)
      values ('', gc_inventory_name, 0);

    inventory_manager.import_from_gtt();

    select * into l_row from room_inventory where name = gc_inventory_name;
  end;

  procedure update_existing_inventory_item as
    l_row room_inventory%rowtype;
  begin
    inventory_manager.add_item(gc_inventory_name);
    insert into tt_inventory_import (roomcode, item, count)
      values ('', gc_inventory_name, 0);

    inventory_manager.import_from_gtt();

    select * into l_row from room_inventory where name = gc_inventory_name;
  end;

end;
/