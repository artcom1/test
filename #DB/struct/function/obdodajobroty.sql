CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rok      ALIAS FOR $1;
 _miesiac  ALIAS FOR $2;
 _konto    ALIAS FOR $3;
 _valuewn  ALIAS FOR $4;
 _valuema  ALIAS FOR $5;
 _valuewnb ALIAS FOR $6;
 _valuemab ALIAS FOR $7;
 _counter  ALIAS FOR $8;
 _typ      ALIAS FOR $9;
 id INT;
 ktref INT;
 licznik INT;
BEGIN

 IF (_konto IS NULL) THEN
  RETURN TRUE;
 END IF;

 licznik=_counter;

 id=(SELECT ob_id FROM kh_obroty WHERE ro_idroku=_rok AND kt_idkonta=_konto AND mn_miesiac=_miesiac);
 IF (id IS NULL) THEN
  ktref=(SELECT kt_ref FROM kh_konta WHERE kt_idkonta=_konto AND ro_idroku=_rok);
  id=ObUpewnijKonto(ktref,_rok);
  INSERT INTO kh_obroty(kt_idkonta,mn_miesiac,ro_idroku,ob_ref,kt_ref,ob_counter) VALUES (_konto,_miesiac,_rok,id,ktref,licznik);
  id=currval('kh_obroty_s');
  licznik=0;
 END IF;

 IF (_typ&4=0) THEN
  UPDATE kh_obroty SET ob_wn=ob_wn+_valuewn,
                       ob_ma=ob_ma+_valuema,
 	 	       ob_wnbuf=ob_wnbuf+_valuewnb,
 		       ob_mabuf=ob_mabuf+_valuemab,
		       ob_counter=ob_counter+licznik WHERE ob_id=id;
 END IF;
 IF (_typ&4=4) THEN
  UPDATE kh_obroty SET ob_budzetwn=ob_budzetwn+_valuewn,
                       ob_budzetma=ob_budzetma+_valuema,
 	 	       ob_budzetwnbuf=ob_budzetwnbuf+_valuewnb,
 		       ob_budzetmabuf=ob_budzetmabuf+_valuemab,
		       ob_counter=ob_counter+licznik WHERE ob_id=id;
 END IF;

 RETURN TRUE;
END;
$_$;
