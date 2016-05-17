CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 id INT;
 ide INT;
 ilosczreal NUMERIC:=0;
 ilosczrealclosed NUMERIC:=0;
BEGIN

  ---------------------------------------------------------------------------------------
 IF (TG_OP='DELETE') THEN
  id=OLD.tel_idsrcelem;
 ELSE
  id=NEW.tel_idsrcelem;
 END IF;
 ---------------------------------------------------------------------------------------      
 IF (TG_OP='UPDATE') THEN
  IF (NEW.tel_idsrcelem IS DISTINCT FROM OLD.tel_idsrcelem) THEN
   RAISE EXCEPTION 'Nie mozna zmieniac ID transelemu na planie zlecenia';
  END IF;
 END IF;
 ---------------------------------------------------------------------------------------
 IF (TG_OP!='INSERT') THEN
  ilosczreal=ilosczreal-OLD.pz_ilosczreal;
  ilosczrealclosed=ilosczrealclosed-OLD.pz_ilosczrealclosed;
 END IF;  
 IF (TG_OP!='DELETE') THEN
  ilosczreal=ilosczreal+NEW.pz_ilosczreal;
  ilosczrealclosed=ilosczrealclosed+NEW.pz_ilosczrealclosed;
 END IF;  
 

 IF (id IS NOT NULL) AND ((ilosczreal!=0) OR (ilosczrealclosed!=0)) THEN
  ide=(SELECT tec_id FROM tg_tecontrol WHERE tel_idelem=id);
  IF (ide IS NULL) THEN
   INSERT INTO tg_tecontrol (tel_idelem) VALUES (id);
   ide=(SELECT tec_id FROM tg_tecontrol WHERE tel_idelem=id);
  END IF;
  UPDATE tg_tecontrol SET 
  tec_pz_ilosczreal=tec_pz_ilosczreal+ilosczreal,
  tec_pz_ilosczrealclosed=tec_pz_ilosczrealclosed+ilosczrealclosed
  WHERE tec_id=ide;
 END IF;
 
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 RETURN NEW;
END;
$$;
