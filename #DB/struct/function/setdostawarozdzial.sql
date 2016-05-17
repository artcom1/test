CREATE FUNCTION setdostawarozdzial(integer, integer, numeric, boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idpzam ALIAS FOR $1;
 _idfz ALIAS FOR $2;
 _ilosc ALIAS FOR $3;
 _trybadd ALIAS FOR $4;
 r RECORD;
BEGIN

 SELECT dr_idrozdzialu INTO r FROM tg_dostawarozdzial AS dr WHERE tel_idelem_pzam=_idpzam AND tel_idelem_fz=_idfz FOR UPDATE;
 IF NOT FOUND THEN  
  INSERT INTO tg_dostawarozdzial
   (tel_idelem_pzam,tel_idelem_fz,dr_ilosc)
  VALUES
   (_idpzam,_idfz,_ilosc);
  RETURN currval('tg_dostawarozdzial_s');
 ELSE
  IF (_trybadd=FALSE) THEN
   IF (_ilosc<>0) THEN
    UPDATE tg_dostawarozdzial SET dr_ilosc=_ilosc WHERE dr_idrozdzialu=r.dr_idrozdzialu AND dr_ilosc<>_ilosc;
   ELSE
    DELETE FROM tg_dostawarozdzial WHERE dr_idrozdzialu=r.dr_idrozdzialu;
   END IF;
  ELSE
   IF (_ilosc<>0) THEN   
    UPDATE tg_dostawarozdzial SET dr_ilosc=dr_ilosc+_ilosc WHERE dr_idrozdzialu=r.dr_idrozdzialu;
    DELETE FROM tg_dostawarozdzial WHERE dr_idrozdzialu=r.dr_idrozdzialu AND dr_ilosc=0;
   END IF;
  END IF;
  RETURN r.dr_idrozdzialu;
 END IF;

 RETURN NULL;
END;
$_$;
