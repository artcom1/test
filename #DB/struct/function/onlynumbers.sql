CREATE FUNCTION onlynumbers(text) RETURNS text
    LANGUAGE sql IMMUTABLE COST 1000
    AS $_$
 select regexp_replace($1,'[^0-9]','','g');
$_$;
