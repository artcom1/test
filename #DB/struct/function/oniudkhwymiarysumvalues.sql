CREATE FUNCTION oniudkhwymiarysumvalues() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE    
BEGIN
 
 IF (TG_OP='INSERT') THEN
  NEW.wmm_valuerestwnwal=NEW.wmm_valuewnwal;
  NEW.wmm_valuerestmawal=NEW.wmm_valuemawal;
  NEW.wmm_valuerestwn=NEW.wmm_valuewn;
  NEW.wmm_valuerestma=NEW.wmm_valuema;
 END IF;

 IF (TG_OP='UPDATE') THEN
  NEW.wmm_valuerestwnwal=NEW.wmm_valuerestwnwal+(NEW.wmm_valuewnwal-OLD.wmm_valuewnwal);
  NEW.wmm_valuerestmawal=NEW.wmm_valuerestmawal+(NEW.wmm_valuemawal-OLD.wmm_valuemawal);
  NEW.wmm_valuerestwn=NEW.wmm_valuerestwn+(NEW.wmm_valuewn-OLD.wmm_valuewn);
  NEW.wmm_valuerestma=NEW.wmm_valuerestma+(NEW.wmm_valuema-OLD.wmm_valuema);
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 RETURN NEW;
END;
$$;
