CREATE FUNCTION clear_kpz(integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
BEGIN

 RETURN gm.dodaj_kpz(0,$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
END;
$_$;
