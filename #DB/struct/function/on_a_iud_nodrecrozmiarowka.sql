CREATE FUNCTION on_a_iud_nodrecrozmiarowka() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
 _knr_idelemu INT;
BEGIN
   
 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
 UPDATE tr_nodrec SET 
  knr_iloscplan=array_sum(NEW.knrr_iloscplan),  
  knr_iloscwyk=array_sum(NEW.knrr_iloscwyk),  
  knr_iloscrozch=array_sum(NEW.knrr_iloscrozch),
  knr_ilosczam=array_sum(NEW.knrr_ilosczam)  
  WHERE knr_idelemu=NEW.knr_idelemu;
 END IF;
   
 IF (TG_OP='DELETE') THEN
  RETURN OLD; 
 END IF;
   
 RETURN NEW; 
END;
$$;
