CREATE FUNCTION onbiudwmsmm() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 
 IF (TG_OP='INSERT') THEN
  IF (NEW.wmm_lp IS NULL) THEN
   NEW.wmm_lp=nullZero((SELECT max(wmm_lp) FROM tg_wmsmm WHERE tr_idtrans=NEW.tr_idtrans))+1;
  END IF;
  IF (NEW.ttw_idtowaru IS NULL) THEN
   NEW.ttw_idtowaru=(SELECT ttw_idtowaru FROM tg_towmag WHERE ttm_idtowmag=NEW.ttm_idtowmag);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  ---Sprawdzenie podstawowych warunkow
  IF (
      (NEW.wmm_iloscfsrcw>NEW.wmm_iloscfsrc) OR
      (NEW.wmm_iloscfdstw>NEW.wmm_iloscfdst) OR
      (NEW.wmm_iloscfdstw>NEW.wmm_iloscfsrcw)
     )
  THEN
   RAISE EXCEPTION '36|%:%:%:%:%|Blad ilosci WMSMM!',NEW.wmm_idelem,NEW.wmm_iloscfsrc,NEW.wmm_iloscfsrcw,NEW.wmm_iloscfdst,NEW.wmm_iloscfdstw;
  END IF;
  RETURN NEW;
 END IF;
END;$$;
