CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 rec RECORD;
 delta_iloscroz  NUMERIC:=0;
 delta_iloscwyk  NUMERIC:=0;
 _pz_idplanu INT;
BEGIN
 IF (TG_OP!='DELETE') THEN
  IF (NEW.ppp_flaga&16384=16384) THEN
   ---nie wywolujemy trigerow wiec zerujemy ten bit i wychodzimy
   NEW.sk_flaga=NEW.sk_flaga&(~16384);
   RETURN NEW;
  END IF;
 END IF;
 
 IF (TG_OP='INSERT') THEN
  delta_iloscroz=NEW.ppp_iloscroz;
  delta_iloscwyk=NEW.ppp_iloscwyk;
  _pz_idplanu=NEW.pz_idplanu;
  IF ((NEW.ppp_flaga&2)=2) THEN 
  ---musze uaktualnic nodrec, rekord powiazania doszedl pozniej programowo
   UPDATE tr_nodrec SET knr_ilosc_plan_rozplan=knr_ilosc_plan_rozplan+NEW.ppp_iloscroz WHERE knr_idelemu=NEW.knr_idelemu;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.pz_idplanu!=NEW.pz_idplanu) THEN
   ----nie obslugujemy zmiane planu
   RAISE EXCEPTION 'Nie dozwolona zmiana planu zlecenia';
  END IF;
  
  delta_iloscroz=NEW.ppp_iloscroz-OLD.ppp_iloscroz;
  delta_iloscwyk=NEW.ppp_iloscwyk-OLD.ppp_iloscwyk;
  _pz_idplanu=NEW.pz_idplanu;
 END IF;

 IF (TG_OP='DELETE') THEN
  delta_iloscroz=-OLD.ppp_iloscroz;
  delta_iloscwyk=-OLD.ppp_iloscwyk;
  _pz_idplanu=OLD.pz_idplanu;
 END IF;

 IF (delta_iloscroz!=0 OR delta_iloscwyk!=0) THEN
  UPDATE tg_planzlecenia SET pz_ilosczreal=pz_ilosczreal+delta_iloscwyk, pz_iloscroz=pz_iloscroz+delta_iloscroz WHERE pz_idplanu=_pz_idplanu;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.ppp_flaga&1=1) THEN
   UPDATE tr_nodrec SET knr_ilosc_plan_rozplan=knr_ilosc_plan_rozplan-OLD.ppp_iloscroz, knr_ilosc_plan_wyk=knr_ilosc_plan_wyk-OLD.ppp_iloscwyk WHERE knr_idelemu=OLD.knr_idelemu;
  END IF;
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
