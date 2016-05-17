CREATE FUNCTION doescapezdarzeniatriggers(integer) RETURNS boolean
    LANGUAGE sql
    AS $_$
 SELECT vendo.setTParamI('RETZDARZENIETRIGGERS',vendo.getTParamI('RETZDARZENIETRIGGERS',0)+$1)>0;
$_$;
