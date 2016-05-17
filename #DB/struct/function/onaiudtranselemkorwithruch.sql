CREATE FUNCTION onaiudtranselemkorwithruch() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
 vold        NUMERIC:=0;
 vnew        NUMERIC:=0;
 v           NUMERIC:=0;
 tel_idelem  INT;
BEGIN
 
 IF (TG_OP<>'INSERT') THEN
  IF ((OLD.tel_newflaga&(1<<16))=(1<<16) AND ((OLD.tel_new2flaga&(1<<3)=(1<<3)) OR (OLD.tel_flaga&(1<<16)=(1<<16)))) THEN
   vold=-OLD.tel_iloscf;
   tel_idelem=OLD.tel_idelem;
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF ((NEW.tel_newflaga&(1<<16))=(1<<16) AND ((NEW.tel_new2flaga&(1<<3)=(1<<3)) OR (NEW.tel_flaga&(1<<16)=(1<<16)))) THEN
   vnew=NEW.tel_iloscf;
   tel_idelem=NEW.tel_idelem;
  END IF;
 END IF;

 v=vnew+vold;
 
 IF (v<>0) THEN
  UPDATE tr_ruchy SET kwc_ilosc=kwc_ilosc+v WHERE tel_idelemdst=tel_idelem OR tel_idelemsrc=tel_idelem;
 END IF;
   
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
