CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 roznica INTERVAL;
 rbh     NUMERIC:=0;
 deltarbh  NUMERIC:=0;
 deltacw   NUMERIC:=0;
 idelemu INT;
BEGIN

 IF (TG_OP='INSERT') THEN
  deltarbh=NEW.kwd_rbh;
  deltacw=NEW.kwd_czaswolny;
  idelemu=NEW.kwe_idelemu;
 END IF;

 IF (TG_OP='UPDATE') THEN
  deltarbh=NEW.kwd_rbh-OLD.kwd_rbh;
  deltacw=NEW.kwd_czaswolny-OLD.kwd_czaswolny;
  idelemu=NEW.kwe_idelemu;
 END IF;

 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN ---uaktualniamy prace  
  PERFORM uaktualnieniePracZMRP(NEW.knw_idelemu,(NEW.kwd_flaga&(1<<2)));  
 END IF;

 IF (TG_OP='DELETE') THEN
  ---kasujemy prace
  DELETE FROM tg_praceall WHERE pra_typeref=156 AND pra_idref=OLD.kwd_idelemu;
  deltarbh=-OLD.kwd_rbh;
  deltacw=-OLD.kwd_czaswolny;
  idelemu=OLD.kwe_idelemu;
 END IF;

 IF (deltarbh<>0 OR deltacw<>0) THEN
  UPDATE tr_kkwnod SET kwe_wykonanepracrbh=kwe_wykonanepracrbh+deltarbh, kwe_czaswolnypracrbh=kwe_czaswolnypracrbh+deltacw WHERE kwe_idelemu=idelemu;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
