CREATE FUNCTION getwartoscnetto(numeric, numeric, numeric, integer, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ilosc ALIAS FOR $1;
 _cnetto ALIAS FOR $2;
 _cbrutto ALIAS FOR $3;
 _flaga ALIAS FOR $4;
 _stvat ALIAS FOR $5;
BEGIN

 IF (_flaga&(1<<26)!=0) THEN
 ---wartosc zaoklaglenia, zawsze to co jest w netto
  RETURN round(_ilosc*_cnetto,2);
 END IF;

 IF (_flaga&32=32) THEN
 ---Odbrutto
  RETURN round(Brt2Net(round(_ilosc*_cbrutto,2),_stvat),2);
 END IF;


 RETURN round(_ilosc*_cnetto,2);
END 
$_$;
