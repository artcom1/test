CREATE FUNCTION s_on_a_iud_kkwnod_warianty() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 
 IF (TG_OP='UPDATE') THEN
  RAISE LOG 'DEBUG: 0. UPDATE KKWNOD % kwe_flaga&(1<<11): %->%', NEW.kwe_idelemu, (OLD.kwe_flaga&(1<<11)), (NEW.kwe_flaga&(1<<11));
  
  IF ((NEW.kwe_flaga&(1<<11))<>(OLD.kwe_flaga&(1<<11))) THEN
   UPDATE tr_nodrec SET knr_flaga=flagMask(knr_flaga,16,((NEW.kwe_flaga&(1<<11))<>0)) WHERE kwe_idelemu=NEW.kwe_idelemu;   
   PERFORM zmienAktywnoscPrevNext(NEW.kwe_idelemu,((NEW.kwe_flaga&(1<<11))=0));
  END IF;  
   
  RAISE LOG 'DEBUG: 1. UPDATE KKWNOD % kwe_flaga&(1<<11): %->%', NEW.kwe_idelemu, (OLD.kwe_flaga&(1<<11)), (NEW.kwe_flaga&(1<<11));
 END IF; 
        
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
