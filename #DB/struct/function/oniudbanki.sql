CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 iddom NUMERIC:=0;
BEGIN

 IF (TG_OP='INSERT') THEN
  iddom=(SELECT bk_idbanku FROM ts_banki WHERE fm_idcentrali=NEW.fm_idcentrali AND bk_type=NEW.bk_type AND bk_flaga&32=32 limit 1);

  IF (iddom=NULL) THEN
   NEW.bk_flaga=NEW.bk_flaga|32;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
