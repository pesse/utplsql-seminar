begin
    utl_db_object.drop_if_exists('UT_GROUP_UTIL', 'PACKAGE');
    utl_db_object.drop_if_exists('GROUP_UTIL', 'PACKAGE');
    utl_db_object.drop_if_exists('UT_DEATHSTAR_SECURITY_WELCOME', 'PACKAGE');
    utl_db_object.drop_if_exists('PROTOCOL_SECURITY', 'PACKAGE');
    utl_db_object.drop_if_exists('UT_DEATHSTAR_FRIEND_OR_FOE', 'PACKAGE');
    utl_db_object.drop_if_exists('DEATHSTAR_SECURITY', 'PACKAGE');
    utl_db_object.drop_if_exists('T_PERSON_APPEARANCE', 'TYPE');
end;
/