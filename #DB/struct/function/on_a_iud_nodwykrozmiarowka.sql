CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE  
 _kwe_idelemu INT;
 
 _knw_kwhr_idelemu INT; 
 
 _knw_iloscwyk_new NUMERIC:=0;
 _knw_iloscwyk_old NUMERIC:=0;
 _knw_tomagmag_new NUMERIC:=0;
 _knw_tomagmag_old NUMERIC:=0;  
 _knw_tomagmagclosed_new NUMERIC:=0;
 _knw_tomagmagclosed_old NUMERIC:=0;
 
 _knw_iloscwyk_new_arr NUMERIC[];
 _knw_iloscwyk_old_arr NUMERIC[];
 _knw_tomagmag_new_arr NUMERIC[];
 _knw_tomagmag_old_arr NUMERIC[]; 
 _knw_tomagmagclosed_new_arr NUMERIC[];
 _knw_tomagmagclosed_old_arr NUMERIC[]; 
 
 _kwh_idheadu INT;
 _isPWBezWskazaniaHeadRozm BOOLEAN:=FALSE;
 _tmp_arr NUMERIC[];
 arr_low INT;
 arr_upp INT;
BEGIN

 IF (TG_OP='INSERT') THEN  
  _kwh_idheadu=NEW.kwh_idheadu;
  IF (NEW.knw_iloscwykrozm IS NULL) THEN
   RETURN NEW;
  END IF;  
  
  IF (NEW.knw_kwhr_idelemu IS NOT NULL OR ((NEW.knw_flaga&(1<<11))=(1<<11))) THEN
   _knw_kwhr_idelemu=NEW.knw_kwhr_idelemu;
   _knw_tomagmag_new=nullzero(NEW.knw_tomagmag);
   _knw_tomagmag_new_arr=NEW.knw_tomagmag_arr;
   _knw_tomagmagclosed_new=nullzero(NEW.knw_tomagmagclosed);   
   _knw_tomagmagclosed_new_arr=NEW.knw_tomagmagclosed_arr;
   _knw_iloscwyk_new=nullzero(NEW.knw_iloscwyk);
   _knw_iloscwyk_new_arr=NEW.knw_iloscwykrozm;
   _isPWBezWskazaniaHeadRozm=TRUE;
  END IF; 
  
  _kwe_idelemu=NEW.kwe_idelemu;
 END IF;
 
 IF (TG_OP='UPDATE') THEN  
  _kwh_idheadu=NEW.kwh_idheadu;
  IF (OLD.knw_iloscwykrozm=NEW.knw_iloscwykrozm AND OLD.knw_iloscopakrozm=NEW.knw_iloscopakrozm AND OLD.knw_tomagmag=NEW.knw_tomagmag AND OLD.knw_tomagmagclosed=NEW.knw_tomagmagclosed) THEN
   RETURN NEW;
  END IF;  
  IF (NEW.knw_kwhr_idelemu IS NOT NULL OR ((NEW.knw_flaga&(1<<11))=(1<<11))) THEN
   _knw_kwhr_idelemu=NEW.knw_kwhr_idelemu;
   _knw_tomagmag_new=nullzero(NEW.knw_tomagmag);
   _knw_tomagmag_new_arr=NEW.knw_tomagmag_arr;
   _knw_tomagmagclosed_new=nullzero(NEW.knw_tomagmagclosed);   
   _knw_tomagmagclosed_new_arr=NEW.knw_tomagmagclosed_arr;
   _knw_iloscwyk_new=nullzero(NEW.knw_iloscwyk);
   _knw_iloscwyk_new_arr=NEW.knw_iloscwykrozm;
   _isPWBezWskazaniaHeadRozm=TRUE;
  END IF;  
  IF (OLD.knw_kwhr_idelemu IS NOT NULL OR ((OLD.knw_flaga&(1<<11))=(1<<11))) THEN
   _knw_kwhr_idelemu=OLD.knw_kwhr_idelemu;
   _knw_tomagmag_old=nullzero(OLD.knw_tomagmag);
   _knw_tomagmag_old_arr=OLD.knw_tomagmag_arr;
   _knw_tomagmagclosed_old=nullzero(OLD.knw_tomagmagclosed);   
   _knw_tomagmagclosed_old_arr=OLD.knw_tomagmagclosed_arr;
   _knw_iloscwyk_old=nullzero(OLD.knw_iloscwyk);
   _knw_iloscwyk_old_arr=OLD.knw_iloscwykrozm;
   _isPWBezWskazaniaHeadRozm=TRUE;
  END IF;    
  _kwe_idelemu=NEW.kwe_idelemu;
 END IF; 

 IF (TG_OP='DELETE') THEN  
  _kwh_idheadu=OLD.kwh_idheadu;
  IF (OLD.knw_iloscwykrozm IS NULL) THEN
   RETURN OLD;
  END IF;    
  IF (OLD.knw_kwhr_idelemu IS NOT NULL OR ((OLD.knw_flaga&(1<<11))=(1<<11))) THEN
   _knw_kwhr_idelemu=OLD.knw_kwhr_idelemu;
   _knw_tomagmag_old=nullzero(OLD.knw_tomagmag);
   _knw_tomagmag_old_arr=OLD.knw_tomagmag_arr;
   _knw_tomagmagclosed_old=nullzero(OLD.knw_tomagmagclosed);   
   _knw_tomagmagclosed_old_arr=OLD.knw_tomagmagclosed_arr;    
   _knw_iloscwyk_old=nullzero(OLD.knw_iloscwyk);
   _knw_iloscwyk_old_arr=OLD.knw_iloscwykrozm;
   _isPWBezWskazaniaHeadRozm=TRUE; 
  END IF; 
  _kwe_idelemu=OLD.kwe_idelemu;
 END IF;
  
 IF (_kwe_idelemu>0) THEN
  UPDATE tr_kkwnod SET kwe_iloscwyk_array=getSumArrayKKWNodWyk_ByKKWNod(kwe_idelemu) WHERE kwe_idelemu=_kwe_idelemu;
 END IF;
  
 IF (_knw_kwhr_idelemu>0) THEN
  UPDATE tr_kkwheadrozm SET 
  kwhr_iloscwmag=kwhr_iloscwmag+_knw_tomagmag_new-_knw_tomagmag_old,
  kwhr_iloscwmagclosed=kwhr_iloscwmagclosed+_knw_tomagmagclosed_new-_knw_tomagmagclosed_old,
  kwhr_iloscwyk=kwhr_iloscwyk+_knw_iloscwyk_new-_knw_iloscwyk_old,        
  kwhr_iloscwmag_arr = array_plus
  (
   kwhr_iloscwmag_arr,
   array_minus
   (
    array_normalize(kwhr_ilosciwkart, _knw_tomagmag_new_arr),
array_normalize(kwhr_ilosciwkart, _knw_tomagmag_old_arr)
   )
  ),  
  kwhr_iloscwmagclosed_arr = array_plus
  (
   kwhr_iloscwmagclosed_arr,
   array_minus
   (
    array_normalize(kwhr_ilosciwkart, _knw_tomagmagclosed_new_arr),
array_normalize(kwhr_ilosciwkart, _knw_tomagmagclosed_old_arr)
   )
  ),  
  kwhr_iloscwyk_arr = array_plus
  (
   kwhr_iloscwyk_arr,
   array_minus
   (
    array_normalize(kwhr_ilosciwkart, _knw_iloscwyk_new_arr),
array_normalize(kwhr_ilosciwkart, _knw_iloscwyk_old_arr)
   )
  )
  WHERE kwhr_idelemu=_knw_kwhr_idelemu;
 ELSE
  IF (_isPWBezWskazaniaHeadRozm) THEN
   _tmp_arr = array_plus(_tmp_arr,_knw_iloscwyk_new_arr);
   _tmp_arr = array_plus(_tmp_arr,_knw_iloscwyk_old_arr);
   _tmp_arr = array_plus(_tmp_arr,_knw_tomagmag_new_arr);
   _tmp_arr = array_plus(_tmp_arr,_knw_tomagmag_old_arr);
   _tmp_arr = array_plus(_tmp_arr,_knw_tomagmagclosed_new_arr);
   _tmp_arr = array_plus(_tmp_arr,_knw_tomagmagclosed_old_arr);
   
   _knw_iloscwyk_new_arr=array_minus(_knw_iloscwyk_new_arr,_knw_iloscwyk_old_arr);
   _knw_tomagmag_new_arr=array_minus(_knw_tomagmag_new_arr,_knw_tomagmag_old_arr);
   _knw_tomagmagclosed_new_arr=array_minus(_knw_tomagmagclosed_new_arr,_knw_tomagmagclosed_old_arr);
    
   arr_low=array_lower(_tmp_arr,1);
   arr_upp=array_upper(_tmp_arr,1);

   FOR i IN arr_low..arr_upp LOOP
    --RAISE NOTICE 'PERFORM updateHeadRozmByDaneWykonania(%, %, %, %, %);', _kwh_idheadu, i, _knw_iloscwyk_new_arr[i], _knw_tomagmag_new_arr[i], _knw_tomagmagclosed_new_arr[i];
    PERFORM updateHeadRozmByDaneWykonania(_kwh_idheadu, i, _knw_iloscwyk_new_arr[i]::NUMERIC, _knw_tomagmag_new_arr[i]::NUMERIC, _knw_tomagmagclosed_new_arr[i]::NUMERIC);
   END LOOP; 
  END IF;
 END IF; 
  
 IF (TG_OP='DELETE') THEN
  RETURN OLD; 
 END IF;
   
 RETURN NEW; 
END;
$$;
