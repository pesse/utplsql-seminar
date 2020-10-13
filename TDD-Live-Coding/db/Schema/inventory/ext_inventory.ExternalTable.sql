create table ext_inventory (
  room varchar2(20),
  item varchar2(4000),
  item_count varchar2(20)
)
organization external(
  default directory deathstar_home
  access parameters (
    records delimited by newline  skip 1
    fields terminated by ','
    optionally enclosed by '"'
  )
  location('inventory.csv')
)
reject limit unlimited
;