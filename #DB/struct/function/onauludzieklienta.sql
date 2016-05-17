CREATE FUNCTION onauludzieklienta() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='UPDATE') THEN
  UPDATE tb_powiazanieklcz SET pkl_flaga=(CASE WHEN NEW.lk_aktywny=1 THEN (pkl_flaga|(1)) ELSE (~((~pkl_flaga)|(1))) END) WHERE lk_idczklienta=NEW.lk_idczklienta;
 END IF;
  
 RETURN NEW;

END;
$$;
