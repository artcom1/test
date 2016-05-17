CREATE FUNCTION uaktualnieniepraczmrp_tpz(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN uaktualnieniePracZMRP($1,1);
END;
$_$;
