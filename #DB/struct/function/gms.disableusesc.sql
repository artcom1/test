CREATE FUNCTION disableusesc(scid integer, delta integer) RETURNS boolean
    LANGUAGE sql
    AS $_$
 SELECT (vendo.settparami('SCIDDISABLED'||($1::text),COALESCE(vendo.getTParamI('SCIDDISABLED'||($1::text)),0)+$2)>0);
$_$;
