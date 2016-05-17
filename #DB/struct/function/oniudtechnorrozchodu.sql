CREATE FUNCTION oniudtechnorrozchodu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  IF (NEW.the_idelem IS NOT NULL) THEN
   NEW.th_idtechnologii=(SELECT th_idtechnologii FROM tr_technoelem WHERE the_idelem=NEW.the_idelem);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
