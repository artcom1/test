CREATE FUNCTION onbiudwmsmmruch() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltasrc NUMERIC:=0;
 deltasrcw NUMERIC:=0;
 deltadst NUMERIC:=0;
 deltadstw NUMERIC:=0;
 idelem INT;
BEGIN
  
 IF (TG_OP='INSERT') THEN
  NEW.tr_idtrans=(SELECT tr_idtrans FROM tg_wmsmm WHERE wmm_idelem=NEW.wmm_idelem);
  NEW.ttm_idtowmag=(SELECT ttm_idtowmag FROM tg_wmsmm WHERE wmm_idelem=NEW.wmm_idelem);
  NEW.ttw_idtowaru=(SELECT ttw_idtowaru FROM tg_wmsmm WHERE wmm_idelem=NEW.wmm_idelem);
  idelem=NEW.wmm_idelem;
 ELSE
  idelem=OLD.wmm_idelem;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.wmr_kierunek<>OLD.wmr_kierunek) THEN
   RAISE EXCEPTION 'Nie mozna zmieniac kierunku!';
  END IF;
  IF (
      (NEW.wmr_iloscfw>NEW.wmr_iloscf) OR
      (NEW.wmr_iloscfwonempty>NEW.wmr_iloscfw)
     ) 
  THEN
   RAISE EXCEPTION '37|%:%:%:%|Blad ilosci WMSMMRuch!',NEW.wmr_idelem,NEW.wmr_iloscf,NEW.wmr_iloscfw,NEW.wmr_iloscfwonempty;
  END IF;
  IF (
      (NEW.wmr_iloscfwonempty<>0) AND
      (COALESCE(NEW.mm_idmiejsca,0)<>COALESCE(OLD.mm_idmiejsca,0))
     )
  THEN
   RAISE EXCEPTION '38|%:%:%:%|Blad zmiany miejsca magazynowego WMSMMRuch!',NEW.wmr_idelem,NEW.wmr_iloscfwonempty,NEW.mm_idmiejsca,OLD.mm_idmiejsca;
  END IF;
 END IF;

 IF (TG_OP<>'INSERT') THEN
  IF (OLD.wmr_kierunek<0) THEN
   deltasrc=deltasrc-OLD.wmr_iloscf;
   deltasrcw=deltasrcw-OLD.wmr_iloscfw;
  ELSE
   deltadst=deltadst-OLD.wmr_iloscf;
   deltadstw=deltadstw-OLD.wmr_iloscfw;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (NEW.wmr_kierunek<0) THEN
   deltasrc=deltasrc+NEW.wmr_iloscf;
   deltasrcw=deltasrcw+NEW.wmr_iloscfw;
  ELSE
   deltadst=deltadst+NEW.wmr_iloscf;
   deltadstw=deltadstw+NEW.wmr_iloscfw;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (
      (OLD.wmr_iloscfw>0) OR
      (OLD.wmr_iloscfwonempty>0)
     ) 
  THEN
   RAISE EXCEPTION '37|%:%:%:%|Blad ilosci WMSMMRuch!',OLD.wmr_idelem,OLD.wmr_iloscf,OLD.wmr_iloscfw,OLD.wmr_iloscfwonempty;
  END IF;
 END IF;


 IF ((deltasrc<>0) OR (deltasrcw<>0) OR (deltadst<>0) OR (deltadstw<>0)) THEN
  UPDATE tg_wmsmm SET wmm_iloscfsrc=wmm_iloscfsrc+deltasrc,wmm_iloscfsrcw=wmm_iloscfsrcw+deltasrcw,
                      wmm_iloscfdst=wmm_iloscfdst+deltadst,wmm_iloscfdstw=wmm_iloscfdstw+deltadstw
		  WHERE wmm_idelem=idelem;
 END IF;
  
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 RETURN NEW;
END; $$;
