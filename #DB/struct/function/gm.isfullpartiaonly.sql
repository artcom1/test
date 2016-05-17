CREATE FUNCTION isfullpartiaonly(whereparams integer, idruchu integer) RETURNS boolean
    LANGUAGE sql
    AS $_$
 SELECT (($1&(1<<21))<>0) AND (vendo.getTParamI('GM.ALLOWPARTIALPARTIA'||$2::text,0)=0) AND (vendo.getTParamI('GM.ALLOWPARTIALPARTIA',0)=0);
$_$;
