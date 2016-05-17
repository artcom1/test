CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 ile INT:=0;
BEGIN
 
 --- Update dla pierwotnego
 IF (NEW.ero_idelementu>0 AND (NEW.eo_flaga&(1<<2))=(1<<2)) THEN
  
  UPDATE tg_elementobiektu SET 
  eo_flaga=(eo_flaga&(~(1<<2))),
  eo_idelementuprev=NEW.eo_idelementu
  
  WHERE 
  ob_idobiektu=NEW.ob_idobiektu AND 
  ero_idelementu=NEW.ero_idelementu AND
  eo_flaga&(1<<2)=(1<<2) AND  
  eo_idelementu<>NEW.eo_idelementu;
  
 END IF;
 
 RETURN NEW;
END;
$$;
