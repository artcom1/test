CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _ilosc ALIAS FOR $1;
 _cena ALIAS FOR $2;
 _kurs ALIAS FOR $3;
BEGIN

 RETURN round(round(_ilosc*_cena,2)*_kurs,2);
END
$_$;
