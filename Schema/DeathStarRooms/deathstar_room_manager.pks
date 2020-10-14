create or replace package deathstar_room_manager as

  subtype varchar2_nn is varchar2 not null;

  function get_room_code( i_name varchar2_nn ) return varchar2;

  /** Adds a new room to a section
   */
  procedure add_room(
    i_name varchar2_nn,
    i_section_id simple_integer,
    i_code varchar2 default null );
end;
/