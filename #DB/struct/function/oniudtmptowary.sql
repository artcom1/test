CREATE FUNCTION oniudtmptowary() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
 flag INT;
BEGIN

 IF (TG_OP='DELETE') THEN
  flag=(SELECT ttw_flaga FROM tg_towary WHERE ttw_idtowaru=OLD.ttw_idtowaru);
  IF (isTMPTowar(flag)) THEN
   DELETE FROM tg_teex WHERE tel_idelem IS NULL AND ttm_idtowmag IN (SELECT ttm_idtowmag FROM tg_towmag WHERE ttw_idtowaru=OLD.ttw_idtowaru);
   DELETE FROM tg_transelem WHERE tel_idelem=OLD.tel_idelem;
   DELETE FROM tg_transelem WHERE ttw_idtowaru=OLD.ttw_idtowaru;
   DELETE FROM tg_towmag WHERE ttw_idtowaru=OLD.ttw_idtowaru;
   DELETE FROM tg_partie WHERE ttw_idtowaru=OLD.ttw_idtowaru;
   DELETE FROM tg_towary WHERE ttw_idtowaru=OLD.ttw_idtowaru;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
