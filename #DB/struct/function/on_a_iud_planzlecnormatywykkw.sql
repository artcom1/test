CREATE FUNCTION on_a_iud_planzlecnormatywykkw() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE  
 _proporcja       NUMERIC; 
 _norma_mh_c      v.delta;
 _wykonane_mh_c   v.delta;
 _norma_rbh_c     v.delta;
 _wykonane_rbh_c  v.delta; 
BEGIN
 IF (TG_OP<>'DELETE') THEN 
  IF (NEW.pz_iloscroz<>0) THEN
   _proporcja=(NEW.pz_ilosc/NEW.pz_iloscroz);
  ELSE
   _proporcja=0;
  END IF;
 
  _norma_mh_c.id_new     = NEW.pz_idref;
  _wykonane_mh_c.id_new  = NEW.pz_idref;
  _norma_rbh_c.id_new    = NEW.pz_idref;
  _wykonane_rbh_c.id_new = NEW.pz_idref;
  
  _wykonane_rbh_c.value_new = (_proporcja*NEW.pz_kkw_norma_rbh_wyk)+ NEW.pz_kkw_norma_rbh_wyk_podrz;
  _norma_rbh_c.value_new    = (_proporcja*NEW.pz_kkw_norma_rbh_roz)+ NEW.pz_kkw_norma_rbh_roz_podrz;
  _wykonane_mh_c.value_new  = (_proporcja*NEW.pz_kkw_norma_mh_wyk) + NEW.pz_kkw_norma_mh_wyk_podrz;
  _norma_mh_c.value_new     = (_proporcja*NEW.pz_kkw_norma_mh_roz) + NEW.pz_kkw_norma_mh_roz_podrz;  
 END IF;
 
 IF (TG_OP<>'INSERT') THEN
  IF (OLD.pz_iloscroz<>0) THEN
   _proporcja=(OLD.pz_ilosc/OLD.pz_iloscroz);
  ELSE
   _proporcja=0;
  END IF;
 
  _norma_mh_c.id_old     = OLD.pz_idref;
  _wykonane_mh_c.id_old  = OLD.pz_idref;
  _norma_rbh_c.id_old    = OLD.pz_idref;
  _wykonane_rbh_c.id_old = OLD.pz_idref;
  
  _wykonane_rbh_c.value_old = (_proporcja*OLD.pz_kkw_norma_rbh_wyk)+ OLD.pz_kkw_norma_rbh_wyk_podrz;
  _norma_rbh_c.value_old    = (_proporcja*OLD.pz_kkw_norma_rbh_roz)+ OLD.pz_kkw_norma_rbh_roz_podrz;
  _wykonane_mh_c.value_old  = (_proporcja*OLD.pz_kkw_norma_mh_wyk) + OLD.pz_kkw_norma_mh_wyk_podrz;
  _norma_mh_c.value_old     = (_proporcja*OLD.pz_kkw_norma_mh_roz) + OLD.pz_kkw_norma_mh_roz_podrz; 
 END IF;
 
 IF (v.deltavalueold(_norma_mh_c)<>0 OR v.deltavalueold(_wykonane_mh_c)<>0 OR v.deltavalueold(_norma_rbh_c)<>0 OR v.deltavalueold(_wykonane_rbh_c)<>0) THEN
  UPDATE tg_planzlecenia SET
  pz_kkw_norma_rbh_wyk_podrz = pz_kkw_norma_rbh_wyk_podrz - v.deltavalueold(_wykonane_rbh_c),
  pz_kkw_norma_rbh_roz_podrz = pz_kkw_norma_rbh_roz_podrz - v.deltavalueold(_norma_rbh_c),
  pz_kkw_norma_mh_wyk_podrz = pz_kkw_norma_mh_wyk_podrz - v.deltavalueold(_wykonane_mh_c),
  pz_kkw_norma_mh_roz_podrz = pz_kkw_norma_mh_roz_podrz - v.deltavalueold(_norma_mh_c)
  WHERE
  pz_idplanu=_norma_mh_c.id_old;
 END IF;
 
 IF (v.deltavaluenew(_norma_mh_c)<>0 OR v.deltavaluenew(_wykonane_mh_c)<>0 OR v.deltavaluenew(_norma_rbh_c)<>0 OR v.deltavaluenew(_wykonane_rbh_c)<>0) THEN
  UPDATE tg_planzlecenia SET
  pz_kkw_norma_rbh_wyk_podrz = pz_kkw_norma_rbh_wyk_podrz + v.deltavaluenew(_wykonane_rbh_c),
  pz_kkw_norma_rbh_roz_podrz = pz_kkw_norma_rbh_roz_podrz + v.deltavaluenew(_norma_rbh_c),
  pz_kkw_norma_mh_wyk_podrz = pz_kkw_norma_mh_wyk_podrz + v.deltavaluenew(_wykonane_mh_c),
  pz_kkw_norma_mh_roz_podrz = pz_kkw_norma_mh_roz_podrz + v.deltavaluenew(_norma_mh_c)
  WHERE
  pz_idplanu=_norma_mh_c.id_new;
 END IF;
    
 IF (TG_OP = 'DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
