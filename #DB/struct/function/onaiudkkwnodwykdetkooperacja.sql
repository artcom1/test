CREATE FUNCTION onaiudkkwnodwykdetkooperacja() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
 _knw_idelemu INT:=0;
 delta_przyjetodobrych NUMERIC:=0;
 delta_przyjetobrakow NUMERIC:=0;
BEGIN
 
 IF (TG_OP='INSERT') THEN
  _knw_idelemu=NEW.knw_idelemu;
  delta_przyjetodobrych=NEW.kwk_przyjetodobrych;
  delta_przyjetobrakow=NEW.kwk_przyjetobrakow;
 END IF;
  
 IF (TG_OP='UPDATE') THEN
  IF (NEW.kwk_przyjetodobrych=OLD.kwk_przyjetodobrych AND NEW.kwk_przyjetobrakow=OLD.kwk_przyjetobrakow) THEN
   RETURN NEW;
  END IF;
  
  _knw_idelemu=NEW.knw_idelemu;
  delta_przyjetodobrych=NEW.kwk_przyjetodobrych-OLD.kwk_przyjetodobrych;
  delta_przyjetobrakow=NEW.kwk_przyjetobrakow-OLD.kwk_przyjetobrakow;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  _knw_idelemu=OLD.knw_idelemu;
  delta_przyjetodobrych=-OLD.kwk_przyjetodobrych;
  delta_przyjetobrakow=-OLD.kwk_przyjetobrakow;
 END IF;
 
 IF (_knw_idelemu>0) THEN
  UPDATE tr_kkwnodwyk SET  
  knw_iloscskontrolowana=knw_iloscskontrolowana+delta_przyjetodobrych, 
  knw_iloscskontrolowanabraki=knw_iloscskontrolowanabraki+delta_przyjetobrakow 
  WHERE 
  knw_idelemu=_knw_idelemu;
 END IF;
  
 IF (TG_OP='DELETE') THEN
  RETURN OLD; 
 END IF;
   
 RETURN NEW; 
END;
$$;
