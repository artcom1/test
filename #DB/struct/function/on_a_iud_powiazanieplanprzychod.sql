CREATE FUNCTION on_a_iud_powiazanieplanprzychod() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 
 IF (TG_OP='INSERT') THEN
  UPDATE tr_nodrec SET knr_flaga=knr_flaga|(1<<14) WHERE knr_idelemu=NEW.knr_idelemu;
 END IF;

 IF (TG_OP='UPDATE') THEN  
 END IF;  
 
 IF (TG_OP='DELETE') THEN
  UPDATE tr_nodrec SET knr_flaga=knr_flaga&(~(1<<14)) WHERE knr_idelemu=OLD.knr_idelemu;
 END IF;
  
 IF (TG_OP<>'DELETE') THEN
  RETURN NEW;
 ELSE
  RETURN OLD;
 END IF; 
 
END;
$$;
