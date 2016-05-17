CREATE FUNCTION wylicziloscwykonaniamrp(numeric, numeric, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
---funckja wylicza ilosc wykonanych operacji z wykonania mrp, bierze pod uwage czy operacja ma rejestracje procentowa czy nie
---pierwszy argument ilosc wykonania
---drugi argument ilosc operacji do wykonanania z noda KKW
---trzeci argument flaga technoelemu okrasla sposob rejestracji wykonania
DECLARE
 _knw_iloscwyk ALIAS FOR $1;
 _kwe_iloscplanwyk ALIAS FOR $2;
 _the_flaga ALIAS FOR $3;

 wynik NUMERIC;

BEGIN
 wynik=_knw_iloscwyk;
 IF (_the_flaga&8192=8192) THEN
  wynik=round(_knw_iloscwyk*_kwe_iloscplanwyk/100,2);
 END IF;

 RETURN wynik;
END;
$_$;
