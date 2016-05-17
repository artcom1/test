CREATE FUNCTION on_a_iud_kkwnodczasy() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
 _kwh_idheadu   INT;
 _norma_mh      v.delta;
 _wykonane_mh   v.delta;
 _norma_rbh     v.delta;
 _wykonane_rbh  v.delta;  
BEGIN
 IF (TG_OP<>'DELETE') THEN
  _kwh_idheadu=NEW.kwh_idheadu;    
  _norma_mh.value_new=0;
  _norma_rbh.value_new=0;
  _wykonane_rbh.value_new=0;
  _wykonane_mh.value_new=0;
   
  IF (NEW.kwe_nodtype=0 AND (NEW.kwe_flaga&(1<<11))=(0<<11)) THEN
   _norma_mh.value_new=getNormatywPrac(NEW.kwe_iloscplanwyk+NEW.kwe_iloscplanbrak,NEW.kwe_tpj,NEW.kwe_tpz,NEW.kwe_wydajnosc,1);
   _norma_rbh.value_new=getNormatywPrac(NEW.kwe_iloscplanwyk+NEW.kwe_iloscplanbrak,NEW.kwe_tpj,NEW.kwe_tpz,NEW.kwe_wydajnosc,NEW.kwe_iloscosob);
    IF ((NEW.kwe_flaga&(1<<4))=(1<<4)) THEN 
    _wykonane_mh.value_new=getNormatywPrac((NEW.kwe_iloscplanwyk+NEW.kwe_iloscplanbrak)*NEW.kwe_iloscwykprocent/100,NEW.kwe_tpj,NEW.kwe_tpz,NEW.kwe_wydajnosc,1);
    _wykonane_rbh.value_new=getNormatywPrac((NEW.kwe_iloscplanwyk+NEW.kwe_iloscplanbrak)*NEW.kwe_iloscwykprocent/100,NEW.kwe_tpj,NEW.kwe_tpz,NEW.kwe_wydajnosc,NEW.kwe_iloscosob);
   END IF;
  END IF;  
 END IF;
 
 IF (TG_OP<>'INSERT') THEN
  _kwh_idheadu=OLD.kwh_idheadu;    
  _norma_mh.value_old=0;
  _norma_rbh.value_old=0;
  _wykonane_rbh.value_old=0;
  _wykonane_mh.value_old=0;
   
  IF (OLD.kwe_nodtype=0 AND (OLD.kwe_flaga&(1<<11))=(0<<11)) THEN
   _norma_mh.value_old=getNormatywPrac(OLD.kwe_iloscplanwyk+OLD.kwe_iloscplanbrak,OLD.kwe_tpj,OLD.kwe_tpz,OLD.kwe_wydajnosc,1);
   _norma_rbh.value_old=getNormatywPrac(OLD.kwe_iloscplanwyk+OLD.kwe_iloscplanbrak,OLD.kwe_tpj,OLD.kwe_tpz,OLD.kwe_wydajnosc,OLD.kwe_iloscosob);
    IF ((OLD.kwe_flaga&(1<<4))=(1<<4)) THEN 
    _wykonane_mh.value_old=getNormatywPrac((OLD.kwe_iloscplanwyk+OLD.kwe_iloscplanbrak)*OLD.kwe_iloscwykprocent/100,OLD.kwe_tpj,OLD.kwe_tpz,OLD.kwe_wydajnosc,1);
    _wykonane_rbh.value_old=getNormatywPrac((OLD.kwe_iloscplanwyk+OLD.kwe_iloscplanbrak)*OLD.kwe_iloscwykprocent/100,OLD.kwe_tpj,OLD.kwe_tpz,OLD.kwe_wydajnosc,OLD.kwe_iloscosob);
   END IF;
  END IF;  
 END IF;
 
 IF ((v.deltavaluenew(_norma_mh)<>0 OR v.deltavaluenew(_norma_rbh)<>0 OR v.deltavaluenew(_wykonane_mh)<>0 OR v.deltavaluenew(_wykonane_rbh)<>0) AND _kwh_idheadu IS NOT NULL) THEN
  UPDATE tr_kkwhead SET
  kwh_norma_mh_oczek = kwh_norma_mh_oczek + v.deltavaluenew(_norma_mh),
  kwh_norma_rbh_oczek = kwh_norma_rbh_oczek + v.deltavaluenew(_norma_rbh),
  kwh_norma_mh_wyk = kwh_norma_mh_wyk + v.deltavaluenew(_wykonane_mh),
  kwh_norma_rbh_wyk = kwh_norma_rbh_wyk + v.deltavaluenew(_wykonane_rbh)
  WHERE
  kwh_idheadu=_kwh_idheadu;
 END IF;
    
 IF (TG_OP = 'DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
