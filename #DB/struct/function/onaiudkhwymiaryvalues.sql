CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 _deltawno NUMERIC:=0;
 _deltamao NUMERIC:=0;
 _deltawn NUMERIC:=0;
 _deltama NUMERIC:=0;
BEGIN

 IF (TG_OP<>'INSERT') THEN
  _deltawno=_deltawno-OLD.wmv_valuewn;
  _deltamao=_deltamao-OLD.wmv_valuema;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  _deltawn=_deltawn+NEW.wmv_valuewn;
  _deltama=_deltama+NEW.wmv_valuema;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (
      (NEW.mc_miesiac=OLD.mc_miesiac) AND
      (NEW.wmv_isbufor=OLD.wmv_isbufor)
     ) THEN
   _deltawn=_deltawn+_deltawno;
   _deltama=_deltama+_deltamao;
   _deltawno=0;
   _deltamao=0;
  END IF;
 END IF;


 IF (_deltawno<>0) OR (_deltamao<>0) THEN
  PERFORM updateWymiaryObroty(OLD.kt_idkonta,OLD.wme_idelemu,OLD.mc_miesiac,_deltawno,_deltamao,OLD.wmv_isbufor);
 END IF;

 IF (_deltawn<>0) OR (_deltama<>0) THEN
  PERFORM updateWymiaryObroty(NEW.kt_idkonta,NEW.wme_idelemu,NEW.mc_miesiac,_deltawn,_deltama,NEW.wmv_isbufor);
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 RETURN NEW;
END;
$$;
