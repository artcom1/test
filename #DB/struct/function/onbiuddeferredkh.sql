CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 m_start INT;
 m_end INT;
 r RECORD;
BEGIN
 
 IF (TG_OP!='DELETE') THEN
  SELECT ro_start,ro_end INTO r FROM kh_lata WHERE ro_idroku=NEW.ro_idroku;
  m_start=substr(replace(r.ro_start::text,'-',''),1,6)::int;
  m_end=substr(replace(r.ro_end::text,'-',''),1,6)::int;
 
  --KH Miesiac
  IF (NEW.dkh_kh_mn_miesiac IS NOT NULL) THEN  
   IF (NEW.dkh_kh_mn_miesiac<m_start) OR (NEW.dkh_kh_mn_miesiac>m_end) THEN
    NEW.dkh_kh_mn_miesiac=NULL;
   END IF;
  END IF;
  --KH Wzorzec
  IF (NEW.dkh_kh_wz_idwzorca IS NOT NULL) THEN
   IF ((SELECT ro_idroku FROM kh_wzorce WHERE wz_idwzorca=NEW.dkh_kh_wz_idwzorca) IS DISTINCT FROM NEW.ro_idroku) THEN
    NEW.dkh_kh_wz_idwzorca=NULL;
   END IF;
  END IF;
  --RV Miesiac
  IF (NEW.dkh_rv_mc_ustalony IS NOT NULL) THEN  
   IF (NEW.dkh_rv_mc_ustalony<m_start) OR (NEW.dkh_rv_mc_ustalony>m_end) THEN
    NEW.dkh_rv_mc_ustalony=NULL;
   END IF;
  END IF;
  --RV Rejestr
  IF (NEW.dkh_rv_nr_idnazwy IS NOT NULL) THEN
   IF ((SELECT ro_idroku FROM ts_nazwarejestru WHERE nr_idnazwy=NEW.dkh_rv_nr_idnazwy) IS DISTINCT FROM NEW.ro_idroku) THEN
    NEW.dkh_rv_nr_idnazwy=NULL;
   END IF;
  END IF;
  --RV Rejestr2
  IF (NEW.dkh_rv_nr_idnazwy2 IS NOT NULL) THEN
   IF ((SELECT ro_idroku FROM ts_nazwarejestru WHERE nr_idnazwy=NEW.dkh_rv_nr_idnazwy2) IS DISTINCT FROM NEW.ro_idroku) THEN
    NEW.dkh_rv_nr_idnazwy2=NULL;
   END IF;
  END IF;
  --KPiR Miesiac
  IF (NEW.dkh_kpir_mn_miesiac IS NOT NULL) THEN  
   IF (NEW.dkh_kpir_mn_miesiac<m_start) OR (NEW.dkh_kpir_mn_miesiac>m_end) THEN
    NEW.dkh_kpir_mn_miesiac=NULL;
   END IF;
  END IF;
 END IF;
 

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
