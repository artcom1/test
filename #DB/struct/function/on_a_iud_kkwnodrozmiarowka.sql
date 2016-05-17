CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE  
 _kwh_idheadu INT;
 _the_flaga INT:=0; 
 _kwe_idelemu INT; 
BEGIN

 IF (TG_OP='INSERT') THEN  
  IF (NEW.kwe_iloscwyk_array IS NULL) THEN
   RETURN NEW;
  END IF;      
  _kwh_idheadu=NEW.kwh_idheadu;
  _the_flaga=NEW.the_flaga;
  _kwe_idelemu=NEW.kwe_idelemu;
 END IF;
 
 IF (TG_OP='UPDATE') THEN  
  IF (OLD.kwe_iloscwyk_array=NEW.kwe_iloscwyk_array) THEN
   RETURN NEW;
  END IF;    
  _kwh_idheadu=NEW.kwh_idheadu;
  _the_flaga=NEW.the_flaga;
  _kwe_idelemu=NEW.kwe_idelemu;
 END IF; 

 IF (TG_OP='DELETE') THEN  
  IF (OLD.kwe_iloscwyk_array IS NULL) THEN
   RETURN OLD;
  END IF;    
  _kwh_idheadu=OLD.kwh_idheadu;
  _the_flaga=OLD.the_flaga;
  _kwe_idelemu=0;
 END IF;
  
 IF (_kwh_idheadu>0 AND (_the_flaga&(1<<0)=(1<<0))) THEN
  UPDATE tr_kkwhead SET kwh_iloscwyk_array=getSumArrayKKWNod_ByKKW(_kwh_idheadu) WHERE kwh_idheadu=_kwh_idheadu;
 END IF;
  
 IF (_kwe_idelemu>0) THEN
  UPDATE tr_nodrecrozmiarowka SET knrr_iloscwyk=array_round(array_multi(knrr_iloscplan,array_div(NEW.kwe_iloscwyk_array,NEW.kwe_iloscplanwyk_array)),4) 
  WHERE 
  knr_idelemu IN (SELECT knr_idelemu FROM tr_nodrec WHERE kwe_idelemu=_kwe_idelemu);   
 END IF;
  
 IF (TG_OP='DELETE') THEN
  RETURN OLD; 
 END IF;
   
 RETURN NEW; 
END;
$$;
