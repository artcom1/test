CREATE FUNCTION getiloscrozliczonapzwz(integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tel_idelem ALIAS FOR $1;
 ret NUMERIC;
BEGIN

 RETURN nullZero((SELECT sum(rm_iloscf) AS sumilosc FROM tg_realizacjapzam AS rpzam
                                   WHERE rpzam.tel_idelemsrc=_tel_idelem
				   AND rm_powod IN (12,13)));
        
END;$_$;
