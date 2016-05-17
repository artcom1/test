CREATE FUNCTION onbiudtpruchy() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaoldm NUMERIC:=0;
 deltaoldp NUMERIC:=0;
 deltaoldpa NUMERIC:=0;

 deltanewm NUMERIC:=0;
 deltanewp NUMERIC:=0;
 deltanewpa NUMERIC:=0;

 deltawm NUMERIC:=0;

 kwh_id INT;
 _tel_newflaga INT;
BEGIN

 IF (TG_OP<>'INSERT') THEN
  
  kwh_id=(SELECT kwh_idheadu FROM tp_kkwelem WHERE kwe_idelemu=OLD.kwr_etapsrc);

  deltaoldm=deltaoldm-OLD.kwr_ilosc;
  IF ((OLD.kwr_flaga&4)=0) THEN
   deltaoldp=deltaoldp-OLD.kwr_ilosc;
  ELSE
   deltaoldpa=deltaoldpa-OLD.kwr_ilosc;
  END IF;
  IF ((OLD.kwr_flaga&1)=0) THEN
   deltaoldm=0;
  END IF;
  IF ((OLD.kwr_flaga&2)=0) THEN
   deltaoldp=0;
   deltaoldpa=0;
  END IF;
  IF (OLD.kwr_etapsrc IS NOT NULL) AND (OLD.tel_idelemdst IS NOT NULL) THEN
   deltawm=deltawm-OLD.kwr_ilosc;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN

  kwh_id=(SELECT kwh_idheadu FROM tp_kkwelem WHERE kwe_idelemu=NEW.kwr_etapsrc);

  deltanewm=deltanewm+NEW.kwr_ilosc;
  IF ((NEW.kwr_flaga&4)=0) THEN
   deltanewp=deltanewp+NEW.kwr_ilosc;
  ELSE
   deltanewpa=deltanewpa+NEW.kwr_ilosc;
  END IF;
  IF ((NEW.kwr_flaga&1)=0) THEN
   deltanewm=0;
  END IF;
  IF ((NEW.kwr_flaga&2)=0) THEN
   deltanewp=0;
   deltanewpa=0;
  END IF;
  IF (NEW.kwr_etapsrc IS NOT NULL) AND (NEW.tel_idelemdst IS NOT NULL) THEN
   deltawm=deltawm+NEW.kwr_ilosc;
  END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  IF (
      (NEW.kwr_flaga&(7+16)=OLD.kwr_flaga&(7+16)) AND
      (nullZero(NEW.kwr_etapsrc)=nullZero(OLD.kwr_etapsrc)) AND
      (nullZero(NEW.kwr_etapdst)=nullZero(OLD.kwr_etapdst)) AND
      (nullZero(NEW.tel_idelemsrc)=nullZero(OLD.tel_idelemsrc)) AND
      (nullZero(NEW.tel_idelemdst)=nullZero(OLD.tel_idelemdst))
     )
  THEN
   deltanewm=deltanewm+deltaoldm;
   deltaoldm=0;
   deltanewp=deltanewp+deltaoldp;
   deltaoldp=0;
   deltanewpa=deltanewpa+deltaoldpa;
   deltaoldpa=0;
  END IF;

 END IF;

 --OLDSRC
 IF (deltaoldm<>0) THEN
  IF (OLD.kwr_etapsrc IS NOT NULL) THEN
   UPDATE tp_kkwelem SET kwe_tonext=kwe_tonext+deltaoldm WHERE kwe_idelemu=OLD.kwr_etapsrc;
   deltaoldm=0;
  END IF;
  IF (OLD.tel_idelemsrc IS NOT NULL) THEN
   UPDATE tg_transelem SET tel_ilosc=tel_ilosc+1000*deltaoldm/tel_przelnilosci WHERE tel_idelem=OLD.tel_idelemsrc;
   DELETE FROM tg_transelem WHERE tel_newflaga&(64+128)<>0 AND tel_ilosc=0 AND tel_idelem=OLD.tel_idelemsrc;
   deltaoldm=0;
  END IF;
 END IF;

 --NEWSRC
 IF (deltanewm<>0) THEN
  IF (NEW.kwr_etapsrc IS NOT NULL) THEN
   UPDATE tp_kkwelem SET kwe_tonext=kwe_tonext+deltanewm WHERE kwe_idelemu=NEW.kwr_etapsrc;
   deltanewm=0;
  END IF;
  IF (NEW.tel_idelemsrc IS NOT NULL) THEN
   IF ((NEW.kwr_flaga&16)<>0) THEN
    _tel_newflaga=128;
   ELSE
    _tel_newflaga=64;
   END IF;
   UPDATE tg_transelem SET tel_ilosc=tel_ilosc+1000*deltanewm/tel_przelnilosci,tel_newflaga=tel_newflaga|_tel_newflaga WHERE tel_idelem=NEW.tel_idelemsrc;
   DELETE FROM tg_transelem WHERE tel_newflaga&(64+128)<>0 AND tel_ilosc=0 AND tel_idelem=NEW.tel_idelemsrc;
   deltanewm=0;
  END IF;
 END IF;

 --OLDDST
 IF (deltaoldp<>0) OR (deltaoldpa<>0) THEN
  IF (OLD.kwr_etapdst IS NOT NULL) THEN
   UPDATE tp_kkwelem SET kwe_fromother=kwe_fromother+deltaoldp,kwe_added=kwe_added+deltaoldpa WHERE kwe_idelemu=OLD.kwr_etapdst;
   deltaoldp=0;
  END IF;
  IF (OLD.tel_idelemdst IS NOT NULL) THEN
   UPDATE tg_transelem SET tel_ilosc=tel_ilosc+1000*(deltaoldp+deltaoldpa)/tel_przelnilosci WHERE tel_idelem=OLD.tel_idelemdst;
   deltaoldp=0;
   deltaoldpa=0;
  END IF;
 END IF;

 --NEWST
 IF (deltanewp<>0) OR (deltanewpa<>0) THEN
  IF (NEW.kwr_etapdst IS NOT NULL) THEN
   UPDATE tp_kkwelem SET kwe_fromother=kwe_fromother+deltanewp,kwe_added=kwe_added+deltanewpa WHERE kwe_idelemu=NEW.kwr_etapdst;
   deltanewp=0;
  END IF;
   IF (NEW.tel_idelemdst IS NOT NULL) THEN
     IF ((NEW.kwr_flaga&16)<>0) THEN
    _tel_newflaga=128;
   ELSE
    _tel_newflaga=64;
   END IF;
   UPDATE tg_transelem SET tel_ilosc=tel_ilosc+1000*(deltanewp+deltanewpa)/tel_przelnilosci,tel_newflaga=tel_newflaga|_tel_newflaga WHERE tel_idelem=NEW.tel_idelemdst;
   deltanewp=0;
   deltanewpa=0;
  END IF;
 END IF;

 ---KWH - NEW
 IF (deltawm<>0) THEN
  UPDATE tp_kkwhead SET kwh_iloscwmag=kwh_iloscwmag+deltawm WHERE kwh_idheadu=kwh_id;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF ((NEW.kwr_flaga&16)<>0) THEN
   IF (NEW.tel_idelemdst IS NOT NULL) THEN
    UPDATE tg_transelem SET tel_newflaga=tel_newflaga|128 WHERE tel_idelem=NEW.tel_idelemdst;
   END IF;
   IF (NEW.tel_idelemsrc IS NOT NULL) THEN
    UPDATE tg_transelem SET tel_newflaga=tel_newflaga|128 WHERE tel_idelem=NEW.tel_idelemsrc;
   END IF;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
