CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _pz_idplanu ALIAS FOR $1;
 _new_lp INT:=$2;
 pl1 RECORD;
 max_lp INT;
 _pz_idrewizja INT;
BEGIN
  SELECT pz_idplanu, pz_lp, zl_idzlecenia, pz_flaga, pz_idrewizja INTO pl1 FROM tg_planzlecenia WHERE pz_idplanu=_pz_idplanu;

  IF (COALESCE(pl1.pz_idrewizja,0)=0) THEN
   _pz_idrewizja=pl1.pz_idplanu;
  ELSE
   _pz_idrewizja=pl1.pz_idrewizja;
  END IF;
  
  max_lp:=(SELECT pz_lp FROM tg_planzlecenia WHERE zl_idzlecenia=pl1.zl_idzlecenia AND pz_flaga&(2048+16384)=pl1.pz_flaga&(2048+16384) order by pz_lp desc limit 1);

  IF (_new_lp <= 0) THEN
    _new_lp := 1;
  END IF;
  
  IF (_new_lp > max_lp) THEN
    _new_lp := max_lp;
  END IF;

  IF (_new_lp < pl1.pz_lp) THEN
    UPDATE tg_planzlecenia SET pz_lp=pz_lp+1 WHERE zl_idzlecenia=pl1.zl_idzlecenia AND pz_lp>=_new_lp AND pz_lp<pl1.pz_lp AND pz_flaga&(2048+16384)=pl1.pz_flaga&(2048+16384);
  ELSE
    UPDATE tg_planzlecenia SET pz_lp=pz_lp-1 WHERE zl_idzlecenia=pl1.zl_idzlecenia AND pz_lp<=_new_lp AND pz_lp>pl1.pz_lp AND pz_flaga&(2048+16384)=pl1.pz_flaga&(2048+16384);
  END IF;
  
  UPDATE tg_planzlecenia SET pz_lp=_new_lp WHERE pz_idplanu=_pz_idrewizja OR pz_idrewizja=_pz_idrewizja;

  RETURN _pz_idrewizja;
END;
$_$;
