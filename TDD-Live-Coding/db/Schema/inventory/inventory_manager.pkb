create or replace package body inventory_manager as

  procedure import as
  begin
    insert into tt_inventory_import (roomcode, item, count)
      select room, item, to_number(
        regexp_replace(item_count, '[^0-9]', '')
        )
      from ext_inventory;
  end;

  procedure add_item( i_name varchar2 ) as
  begin
    insert into room_inventory ( name ) values ( i_name );
  end;

  procedure import_from_gtt as
  begin
    merge into room_inventory target
    using (
      select * from tt_inventory_import
    ) source
    on (target.name = source.item)
    when not matched then
      insert (name) values (source.item);
  end;

end;
/