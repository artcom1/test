CREATE FUNCTION oniudmagazyny() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 iddom NUMERIC:=0;
BEGIN

 IF (TG_OP='INSERT') THEN
  iddom=(SELECT tmg_idmagazynu FROM tg_magazyny WHERE fm_idcentrali=NEW.fm_idcentrali AND tmg_flaga&4=4 );

  IF (iddom=NULL) THEN
   NEW.tmg_flaga=NEW.tmg_flaga|4;
  END IF;

  IF (NEW.tmg_idmagazynufortk IS NULL) AND (NEW.tmg_isfortk=0) THEN
   NEW.tmg_idmagazynufortk=NEW.tmg_idmagazynu;
  END IF;

 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
