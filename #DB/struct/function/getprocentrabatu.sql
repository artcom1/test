CREATE FUNCTION getprocentrabatu(numeric, numeric, numeric, numeric, numeric, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 wynik NUMERIC;
 cena NUMERIC;
 cena0 NUMERIC;
 _tel_cenawaluta ALIAS FOR $1;
 _tel_brutto ALIAS FOR $2;
 _tel_cena0 ALIAS FOR $3;
 _tel_przelicznik ALIAS FOR $4;
 _tel_cena0przelicznik ALIAS FOR $5;
 _tr_zamknieta ALIAS FOR $6;
BEGIN
 IF (_tr_zamknieta&128=128) THEN
  cena=_tel_brutto*_tel_przelicznik;
 ELSE
  cena=_tel_cenawaluta*_tel_przelicznik;
 END IF;
 cena0=_tel_cena0*_tel_cena0przelicznik;

 IF (cena0=0) THEN
  wynik=1;
 ELSE
  wynik=-((cena-cena0)/cena0);
 END IF;

 RETURN wynik;
END;$_$;
