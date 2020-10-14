create or replace package inventory_manager as

  procedure import;

  procedure add_item( i_name varchar2 );

  procedure import_from_gtt;
end;
/