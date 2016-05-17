CREATE FUNCTION onchangeajednostkaaltinsertdelete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  PERFORM UpdateRecChange(10,NEW.ttw_idtowaru);
 ELSE 
  IF (TG_OP='UPDATE') THEN
   PERFORM UpdateRecChange(10,NEW.ttw_idtowaru);
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
