CREATE FUNCTION realizacjaplanuzlecenia(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _pz_idplanu ALIAS FOR $1;
 _tel_idelem ALIAS FOR $2;
 ilosc NUMERIC:=0;
BEGIN
 
 ilosc=(SELECT tel_iloscf FROM tg_transelem WHERE tel_idelem=_tel_idelem);

 INSERT INTO tg_realizacjaplanuprod (pz_idplanu, tel_idelem,rpp_ilosc,rpp_flaga,nz_idnaprawy)
 VALUES(_pz_idplanu,_tel_idelem,ilosc,0,NULL);
 RETURN 1;

END;
$_$;


--
--

CREATE FUNCTION realizacjaplanuzlecenia(integer, integer, numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _pz_idplanu ALIAS FOR $1;
 _tel_idelem ALIAS FOR $2;
 _ilosc ALIAS FOR $3;
BEGIN
 
 INSERT INTO tg_realizacjaplanuprod (pz_idplanu, tel_idelem,rpp_ilosc,rpp_flaga,nz_idnaprawy)
 VALUES(_pz_idplanu,_tel_idelem,_ilosc,0,NULL);
 RETURN 1;

END;
$_$;
