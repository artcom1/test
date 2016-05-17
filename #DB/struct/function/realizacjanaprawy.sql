CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _nz_idnaprawy ALIAS FOR $1;
 _tel_idelem ALIAS FOR $2;
 ilosc NUMERIC:=0;
BEGIN
 
 ilosc=(SELECT tel_iloscf FROM tg_transelem WHERE tel_idelem=_tel_idelem);

 INSERT INTO tg_realizacjaplanuprod (pz_idplanu, tel_idelem,rpp_ilosc,rpp_flaga,nz_idnaprawy)
 VALUES(NULL,_tel_idelem,ilosc,1,_nz_idnaprawy);
 RETURN 1;

END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _nz_idnaprawy ALIAS FOR $1;
 _tel_idelem ALIAS FOR $2;
 _ilosc ALIAS FOR $3;
BEGIN
 
 INSERT INTO tg_realizacjaplanuprod (pz_idplanu, tel_idelem,rpp_ilosc,rpp_flaga,nz_idnaprawy)
 VALUES(NULL,_tel_idelem,_ilosc,1,_nz_idnaprawy);
 RETURN 1;

END;
$_$;
