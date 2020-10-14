create global temporary table tt_inventory_import (
  roomcode varchar2(255),
  item varchar2(255),
  count integer
);
drop table tt_inventory_import;