CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 akt bool := FALSE;
 rec RECORD;
BEGIN

 IF (TG_OP='INSERT') THEN
  IF (NEW.plt_szd_idszablonu IS NOT NULL) THEN
   akt=TRUE;
  END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  IF (COALESCE(NEW.plt_szd_idszablonu,0)<>COALESCE(OLD.plt_szd_idszablonu,0)) THEN
   akt=TRUE;
  END IF;
 END IF;
 
 IF (akt) THEN
  SELECT
  (CASE WHEN szd_typplanowania=0 THEN (1<<1) ELSE (0<<1) END) AS flg,
  szd_opznieniedatazak,
  szd_opznienietermin,
  (CASE WHEN szd_typograniczenia=0 THEN 0 ELSE 1 END) AS sst
  INTO rec FROM ts_szablonzdarzenia
  WHERE 
  NEW.plt_szd_idszablonu=szd_idszablonu;
  
  NEW.plt_flaga=((NEW.plt_flaga&(~(3<<1)))|(rec.flg));
  NEW.plt_opoznienie=rec.szd_opznieniedatazak;
  NEW.plt_czastrwania=rec.szd_opznienietermin;
  NEW.plt_startstoptype=rec.sst;
 END IF;
   
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END
$$;
