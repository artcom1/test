CREATE FUNCTION onaiudvatytowarow() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 
 IF (TG_OP='INSERT') THEN
  UPDATE tg_towary SET ttw_flaga=ttw_flaga|(1<<30) WHERE ttw_idtowaru=NEW.ttw_idtowaru AND ttw_flaga&(1<<30)=0;
 END IF;


 IF (TG_OP='DELETE') THEN
  UPDATE tg_towary SET ttw_flaga=ttw_flaga&(~(1<<30)) WHERE ttw_idtowaru=OLD.ttw_idtowaru AND ttw_flaga&(1<<30)=(1<<30) AND NOT EXISTS (SELECT ttw_idtowaru FROM tg_vatytowarow WHERE tv_idvatu<>OLD.tv_idvatu AND ttw_idtowaru=tg_vatytowarow.ttw_idtowaru);
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
