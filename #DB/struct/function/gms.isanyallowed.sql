CREATE FUNCTION isanyallowed(integer) RETURNS boolean
    LANGUAGE sql
    AS $_$
 SELECT vendo.getTParamI('GMS_ISANYALLOWED_'||$1,0)>0;
$_$;
