CREATE FUNCTION markneedrecalc(integer) RETURNS integer
    LANGUAGE sql
    AS $_$
 SELECT vendo.setTParamI('DRCS_'||$1,vendo.getTParamI('DRCS_'||$1,0)+1);
$_$;
