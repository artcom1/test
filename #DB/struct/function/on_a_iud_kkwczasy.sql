CREATE FUNCTION on_a_iud_kkwczasy() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
 _norma_mh      v.delta;
 _wykonane_mh   v.delta;
 _norma_rbh     v.delta;
 _wykonane_rbh  v.delta;  
BEGIN
 IF (TG_OP<>'DELETE') THEN 
  _norma_mh.id_new     = NEW.pz_idplanu;
  _wykonane_mh.id_new  = NEW.pz_idplanu;
  _norma_rbh.id_new    = NEW.pz_idplanu;
  _wykonane_rbh.id_new = NEW.pz_idplanu;
 
  _norma_mh.value_new     = NEW.kwh_norma_mh_oczek;
  _wykonane_mh.value_new  = NEW.kwh_norma_mh_wyk;
  _norma_rbh.value_new    = NEW.kwh_norma_rbh_oczek;
  _wykonane_rbh.value_new = NEW.kwh_norma_rbh_wyk;  
 END IF;
 
 IF (TG_OP<>'INSERT') THEN 
  _norma_mh.id_old     = OLD.pz_idplanu;
  _wykonane_mh.id_old  = OLD.pz_idplanu;
  _norma_rbh.id_old    = OLD.pz_idplanu;
  _wykonane_rbh.id_old = OLD.pz_idplanu;
  
  _norma_mh.value_old     = OLD.kwh_norma_mh_oczek;
  _wykonane_mh.value_old  = OLD.kwh_norma_mh_wyk;
  _norma_rbh.value_old    = OLD.kwh_norma_rbh_oczek;
  _wykonane_rbh.value_old = OLD.kwh_norma_rbh_wyk; 
 END IF;
 
 IF (v.deltavalueold(_norma_mh)<>0 OR v.deltavalueold(_wykonane_mh)<>0 OR v.deltavalueold(_norma_rbh)<>0 OR v.deltavalueold(_wykonane_rbh)<>0) THEN
  UPDATE tg_planzlecenia SET
  pz_kkw_norma_rbh_wyk = pz_kkw_norma_rbh_wyk - v.deltavalueold(_wykonane_rbh),
  pz_kkw_norma_rbh_roz = pz_kkw_norma_rbh_roz - v.deltavalueold(_norma_rbh),
  pz_kkw_norma_mh_wyk = pz_kkw_norma_mh_wyk - v.deltavalueold(_wykonane_mh),
  pz_kkw_norma_mh_roz = pz_kkw_norma_mh_roz - v.deltavalueold(_norma_mh)
  WHERE
  pz_idplanu=_norma_mh.id_old;
 END IF;
 
 IF (v.deltavaluenew(_norma_mh)<>0 OR v.deltavaluenew(_wykonane_mh)<>0 OR v.deltavaluenew(_norma_rbh)<>0 OR v.deltavaluenew(_wykonane_rbh)<>0) THEN
  UPDATE tg_planzlecenia SET
  pz_kkw_norma_rbh_wyk = pz_kkw_norma_rbh_wyk + v.deltavaluenew(_wykonane_rbh),
  pz_kkw_norma_rbh_roz = pz_kkw_norma_rbh_roz + v.deltavaluenew(_norma_rbh),
  pz_kkw_norma_mh_wyk = pz_kkw_norma_mh_wyk + v.deltavaluenew(_wykonane_mh),
  pz_kkw_norma_mh_roz = pz_kkw_norma_mh_roz + v.deltavaluenew(_norma_mh)
  WHERE
  pz_idplanu=_norma_mh.id_new;
 END IF;
    
 IF (TG_OP = 'DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
