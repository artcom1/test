CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 tmp INT;
BEGIN

 IF (TG_OP='INSERT') THEN
  RAISE NOTICE 'Wstawiam lisc';
  IF (NEW.re_ref=NULL) THEN
   tmp=(SELECT max(re_r)+1 FROM kh_raportelem WHERE rp_idraportu=NEW.rp_idraportu);
   NEW.re_prefix='';
   NEW.re_sufix=(SELECT max(re_sufix) FROM kh_raportelem WHERE re_ref=NULL AND rp_idraportu=NEW.rp_idraportu);
  ELSE
   tmp=(SELECT re_r FROM kh_raportelem WHERE re_idelementu=NEW.re_ref);
   NEW.rp_idraportu=(SELECT rp_idraportu FROM kh_raportelem WHERE re_idelementu=NEW.re_ref);
   NEW.re_poziom=(SELECT re_poziom FROM kh_raportelem WHERE re_idelementu=NEW.re_ref)+1;
   NEW.re_prefix=(SELECT numerPoziomu(re_prefix,re_sufix) FROM kh_raportelem WHERE re_idelementu=NEW.re_ref);
   NEW.re_sufix=(SELECT max(re_sufix) FROM kh_raportelem WHERE re_ref=NEW.re_ref);
  END IF;
  NEW.re_sufix=COALESCE(NEW.re_sufix+1,1);
  tmp=COALESCE(tmp,1);
  NEW.re_l=tmp;
  NEW.re_r=tmp+1;
  UPDATE kh_raportelem SET re_r=re_r+2 WHERE re_r>=tmp AND rp_idraportu=NEW.rp_idraportu;
  UPDATE kh_raportelem SET re_l=re_l+2 WHERE re_l>=tmp AND rp_idraportu=NEW.rp_idraportu;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.re_ref<>OLD.re_ref) THEN
   RAISE EXCEPTION 'Funkcja nie zaimplementowana dla drzew Cellko!';
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  --Zrob update prawych stron rodzicow
  UPDATE kh_raportelem SET re_r=re_r-(OLD.re_r-OLD.re_l+1) WHERE re_r>OLD.re_r AND re_l<OLD.re_l AND rp_idraportu=OLD.rp_idraportu;
  --Zrob update wszystkich polozonych w calosci po prawej
  UPDATE kh_raportelem SET re_l=re_l-(OLD.re_r-OLD.re_l+1),re_r=re_r-(OLD.re_r-OLD.re_l+1) WHERE re_l>OLD.re_r AND re_r>OLD.re_r AND rp_idraportu=OLD.rp_idraportu;
  IF (OLD.re_ref IS NOT NULL) THEN
   UPDATE kh_raportelem SET re_sufix=re_sufix-1 WHERE rp_idraportu=OLD.rp_idraportu AND re_ref=OLD.re_ref AND re_sufix>OLD.re_sufix;
  ELSE
   UPDATE kh_raportelem SET re_sufix=re_sufix-1 WHERE rp_idraportu=OLD.rp_idraportu AND re_ref=NULL AND re_sufix>OLD.re_sufix;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;$$;
