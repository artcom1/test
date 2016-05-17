CREATE FUNCTION hasnotifytable() RETURNS boolean
    LANGUAGE sql
    AS $$
 SELECT (SELECT relname FROM pg_class where relnamespace=pg_my_temp_schema() AND relname='tm_notifies') IS NOT NULL;
$$;
