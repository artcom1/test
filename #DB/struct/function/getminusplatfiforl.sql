CREATE FUNCTION getminusplatfiforl(integer, integer, numeric, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idrl     ALIAS FOR $1;
 _idrr     ALIAS FOR $2;
 _kwota    ALIAS FOR $3;
 _idwaluty ALIAS FOR $4;
BEGIN
 RETURN getMinusPlatFifo(NULL,NULL,_kwota,_idwaluty,NULL,_idrr,_idrl);
END;
$_$;
