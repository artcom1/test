CREATE FUNCTION onbiudfirma() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='UPDATE' OR TG_OP='INSERT') THEN
  IF ((NEW.fm_flagacentr&1)=1 AND NEW.fm_idindextab is NULL) THEN
   NEW.fm_idindextab=nextval('tb_firmaindextab_s');
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
