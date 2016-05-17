CREATE FUNCTION onaiudbanki() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='DELETE') THEN
  DELETE FROM tb_bankirel WHERE br_flaga&8=8 AND bk_idbanku=OLD.bk_idbanku;
  return OLD;
 END IF;

 IF (TG_OP='UPDATE') THEN
  UPDATE tb_bankirel SET br_nrkonta=NEW.bk_nrkonta, br_nrkontanorm=NEW.bk_nrkontanorm WHERE br_flaga&8=8 AND bk_idbanku=NEW.bk_idbanku;
 END IF;

 IF (TG_OP='INSERT') THEN
  INSERT INTO tb_bankirel (bk_idbanku,br_flaga,br_nrkonta,br_nrkontanorm) VALUES (NEW.bk_idbanku,8,NEW.bk_nrkonta,NEW.bk_nrkontanorm);
 END IF;
  
 RETURN NEW;

END;
$$;
