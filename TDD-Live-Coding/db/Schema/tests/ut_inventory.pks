create or replace package ut_inventory as
  -- %suite

  -- %test
  procedure import_inventory;

  -- %test
  procedure add_item_inserts_into_inventory;

  -- %test
  procedure create_new_inventory_item;

  -- %test
  procedure update_existing_inventory_item;
end;
/