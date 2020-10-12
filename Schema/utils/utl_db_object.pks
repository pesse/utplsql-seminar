create or replace package utl_db_object as

  subtype varchar2_nn is varchar2 not null;

  /** Returns the object type of a given object or NULL
   */
  function get_type(
    i_object_name in varchar2_nn
  ) return varchar2;

  /** Drops a given Object if it exists in the database
	  If i_object_type is not set, it's automatically retrieved from data dictionary
   */
  procedure drop_if_exists(
    i_object_name in varchar2_nn,
    i_object_type in varchar2 default null
  );

end;
/