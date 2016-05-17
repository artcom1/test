CREATE FUNCTION markanymark(integer, integer) RETURNS boolean
    LANGUAGE sql
    AS $_$
 SELECT vendo.deltatparami('GMS_HASANYMARK'||$1::text,$2)>0;
$_$;
