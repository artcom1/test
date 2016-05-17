CREATE FUNCTION marknotfullpartiaonly(idruchu integer, delta integer DEFAULT 0) RETURNS integer
    LANGUAGE sql
    AS $_$
 SELECT vendo.setTParamI('GM.ALLOWPARTIALPARTIA'||COALESCE($1::text,''),vendo.getTParamI('GM.ALLOWPARTIALPARTIA'||COALESCE($1::text,''),0)+$2);
$_$;
