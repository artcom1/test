CREATE FUNCTION setanyallowed(integer) RETURNS boolean
    LANGUAGE sql
    AS $_$
 SELECT (vendo.setTParamI('GMS_ISANYALLOWED_'||$1,1)>0);
$_$;
