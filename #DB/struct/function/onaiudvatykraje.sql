CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
 
 IF (TG_OP='INSERT') THEN
  UPDATE ts_powiaty SET pw_flaga=pw_flaga|1 WHERE pw_idpowiatu=NEW.pw_idpowiatu AND pw_flaga&1=0;
 END IF;


 IF (TG_OP='DELETE') THEN
  UPDATE ts_powiaty SET pw_flaga=pw_flaga&(~1) WHERE pw_idpowiatu=OLD.pw_idpowiatu AND pw_flaga&1=1 AND NOT EXISTS (SELECT pw_idpowiatu FROM tg_vatykraje WHERE vk_idvatkraj<>OLD.vk_idvatkraj AND pw_idpowiatu=ts_powiaty.pw_idpowiatu);
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
