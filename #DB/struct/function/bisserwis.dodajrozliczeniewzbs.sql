CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tel_idelem    ALIAS FOR $1;
 _pz_idplanu    ALIAS FOR $2;
 _tel_idelemk   ALIAS FOR $3;
 _powod         ALIAS FOR $4;
 _ilosc         ALIAS FOR $5;
BEGIN

 IF (_ilosc=0) THEN
  RETURN NULL;
 END IF;
 
 INSERT INTO tg_realizacjapzam
  (tel_idelemsrc,tel_idpzam,pz_idplanu,rm_powod,rm_iloscf,rm_flaga)
 VALUES
  (_tel_idelem,_tel_idelemk,_pz_idplanu,_powod,_ilosc,2|4);
 
 RETURN currval('tg_realizacjapzam_s');
END;$_$;
