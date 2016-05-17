CREATE FUNCTION oniuddostawarozdzial() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltailoscold NUMERIC:=0;
 deltailoscnew NUMERIC:=0;
BEGIN

 IF (TG_OP<>'INSERT') THEN
  deltailoscold=-OLD.dr_ilosc;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  deltailoscnew=NEW.dr_ilosc;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF ((OLD.tel_idelem_pzam=NEW.tel_idelem_pzam) AND (OLD.tel_idelem_fz=NEW.tel_idelem_fz)) THEN
   deltailoscnew=deltailoscnew+deltailoscold;
   deltailoscold=0;
  END IF;
 END IF;


 IF (deltailoscold<>0) THEN
  UPDATE tg_zamilosci SET zmi_if_rozdzielone=zmi_if_rozdzielone+deltailoscold WHERE tel_idelem=OLD.tel_idelem_pzam;
  UPDATE tg_zamilosci SET zmi_if_rozdzielone=zmi_if_rozdzielone+deltailoscold WHERE tel_idelem=OLD.tel_idelem_fz;
 END IF;


 IF (deltailoscnew<>0) THEN
  UPDATE tg_zamilosci SET zmi_if_rozdzielone=zmi_if_rozdzielone+deltailoscnew WHERE tel_idelem=NEW.tel_idelem_pzam;
  UPDATE tg_zamilosci SET zmi_if_rozdzielone=zmi_if_rozdzielone+deltailoscnew WHERE tel_idelem=NEW.tel_idelem_fz;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END 
$$;
