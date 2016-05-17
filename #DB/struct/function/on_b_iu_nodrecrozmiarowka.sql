CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 _knr_iloscplan NUMERIC;
 _knrr_iloscplan NUMERIC[];
 
 _tr_nodrec RECORD;
 
 _iloscplanwyk_array NUMERIC[];
 _iloscwyk_array     NUMERIC[]; 
 
BEGIN
  
 SELECT 
 nodrec.kwe_idelemu, nodrec.kwh_idheadu,
 knr_licznik, knr_mianownik, 
 trr_flaga, knr_flaga,
 kwh_iloscoczek_array, kwh_iloscwyk_array,
 kwe_iloscplanwyk_array, kwe_iloscwyk_array
 INTO _tr_nodrec FROM tr_nodrec AS nodrec 
 JOIN tr_kkwhead AS kwh ON (kwh.kwh_idheadu=nodrec.kwh_idheadu)
 LEFT JOIN tr_kkwnod AS nod ON (nod.kwe_idelemu=nodrec.kwe_idelemu)
 WHERE nodrec.knr_idelemu=NEW.knr_idelemu;
  
 IF (COALESCE(_tr_nodrec.kwe_idelemu,0)<>0) THEN
  _iloscplanwyk_array=_tr_nodrec.kwe_iloscplanwyk_array;
  _iloscwyk_array=_tr_nodrec.kwe_iloscwyk_array;
 ELSE
  _iloscplanwyk_array=_tr_nodrec.kwh_iloscoczek_array;
  _iloscwyk_array=_tr_nodrec.kwh_iloscwyk_array; 
 END IF; 
 
 IF (_tr_nodrec.knr_mianownik>0) THEN  
  NEW.knrr_iloscplan=array_round(KKWNODObliczIlosc_ARRAY(_iloscplanwyk_array,NULL,NEW.knrr_rozmiarwyst,_tr_nodrec.knr_licznik,_tr_nodrec.knr_mianownik,_tr_nodrec.trr_flaga,_tr_nodrec.knr_flaga,0),4);
  NEW.knrr_iloscwyk=array_round(KKWNODObliczIlosc_ARRAY(_iloscwyk_array,NULL,NEW.knrr_rozmiarwyst,_tr_nodrec.knr_licznik,_tr_nodrec.knr_mianownik,_tr_nodrec.trr_flaga,_tr_nodrec.knr_flaga,0),4);
 END IF;
  
 IF (TG_OP<>'DELETE') THEN
  IF (NEW.knrr_iloscplan IS NULL) THEN NEW.knrr_iloscplan=array_multi_single(NEW.knrr_rozmiarwyst, 0); END IF;
  IF (NEW.knrr_iloscwyk IS NULL) THEN NEW.knrr_iloscwyk=array_multi_single(NEW.knrr_rozmiarwyst, 0); END IF;
  IF (NEW.knrr_iloscrozch IS NULL) THEN NEW.knrr_iloscrozch=array_multi_single(NEW.knrr_rozmiarwyst, 0); END IF;
  IF (NEW.knrr_ilosczam IS NULL) THEN NEW.knrr_ilosczam=array_multi_single(NEW.knrr_rozmiarwyst, 0); END IF;
  IF (NEW.knrr_ilosc_plan_rozplan IS NULL) THEN NEW.knrr_ilosc_plan_rozplan=array_multi_single(NEW.knrr_rozmiarwyst, 0); END IF;
  IF (NEW.knrr_ilosc_plan_wyk IS NULL) THEN NEW.knrr_ilosc_plan_wyk=array_multi_single(NEW.knrr_rozmiarwyst, 0); END IF;
 END IF;
  
 RETURN NEW;
END;
$$;
