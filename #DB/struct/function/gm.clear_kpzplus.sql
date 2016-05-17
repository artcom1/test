CREATE FUNCTION clear_kpzplus(integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN gm.dodaj_kpzplus(0,$1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
END;
$_$;
