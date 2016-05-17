CREATE FUNCTION zmienlpplanu(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _pz_idplanu ALIAS FOR $1;
 typ ALIAS FOR $2;
 pl RECORD;
 pl2 RECORD;
 _pz_idrewizja INT;
 _pz_idrewizja2 INT;
BEGIN
  SELECT pz_idplanu, pz_lp, zl_idzlecenia, pz_flaga, pz_idrewizja INTO pl FROM tg_planzlecenia WHERE pz_idplanu=_pz_idplanu;

  IF (COALESCE(pl.pz_idrewizja,0)=0) THEN
   _pz_idrewizja=pl.pz_idplanu;
  ELSE
   _pz_idrewizja=pl.pz_idrewizja;
  END IF;
  
  IF (typ) THEN
   SELECT pz_idplanu, pz_lp, pz_idrewizja INTO pl2 FROM tg_planzlecenia WHERE zl_idzlecenia=pl.zl_idzlecenia AND pz_lp<pl.pz_lp AND pz_lp>0 AND pz_flaga&(2048+16384)=pl.pz_flaga&(2048+16384) ORDER BY pz_lp DESC LIMIT 1 OFFSET 0;
  ELSE
   SELECT pz_idplanu, pz_lp, pz_idrewizja INTO pl2 FROM tg_planzlecenia WHERE zl_idzlecenia=pl.zl_idzlecenia AND pz_lp>pl.pz_lp AND pz_lp>0 AND pz_flaga&(2048+16384)=pl.pz_flaga&(2048+16384) ORDER BY pz_lp ASC LIMIT 1 OFFSET 0;
  END IF;
  
  IF (COALESCE(pl2.pz_idrewizja,0)=0) THEN
   _pz_idrewizja2=pl2.pz_idplanu;
  ELSE
   _pz_idrewizja2=pl2.pz_idrewizja;
  END IF;

  IF (_pz_idrewizja2>0) THEN
  ---znalazlem zlecenie do wymiany prorytetami, robie zamiane
    
   UPDATE tg_planzlecenia SET pz_lp=pl2.pz_lp WHERE pz_idplanu=_pz_idrewizja OR pz_idrewizja=_pz_idrewizja;
   UPDATE tg_planzlecenia SET pz_lp=pl.pz_lp WHERE pz_idplanu=_pz_idrewizja2 OR pz_idrewizja=_pz_idrewizja2;

   return _pz_idrewizja2;
  END IF;
  RETURN 0;
END;
$_$;
