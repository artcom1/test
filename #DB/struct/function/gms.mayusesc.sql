CREATE FUNCTION mayusesc(scid integer) RETURNS boolean
    LANGUAGE sql
    AS $_$
 SELECT COALESCE(vendo.getTParamI('SCIDDISABLED'||($1::text)),0)=0;
$_$;
