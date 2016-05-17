CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 _kwh_idheadu      INT:=0;
 _pz_idplanu       INT:=0;
 
 delta_ilosc           NUMERIC:=0;   
 delta_iloscwmag       NUMERIC:=0;
 delta_iloscwmagclosed NUMERIC:=0;
  
 array_delta_ilosc           NUMERIC[];   
 array_delta_iloscwmag       NUMERIC[];
 array_delta_iloscwmagclosed NUMERIC[];
 
 _pzw_ilosczreal       NUMERIC;
 _pzw_ilosczrealclosed NUMERIC;
 
 rec RECORD;
BEGIN
 
 IF (TG_OP='INSERT') THEN
  _kwh_idheadu=NEW.kwhr_kwh_idheadu;
  _pz_idplanu=NEW.kwhr_pz_idplanu;
  
  delta_ilosc=array_sum(NEW.kwhr_ilosciwkart)*NEW.kwhr_ilosckart;  
  delta_iloscwmag=NEW.kwhr_iloscwmag;
  delta_iloscwmagclosed=NEW.kwhr_iloscwmagclosed;
  
  array_delta_ilosc=array_multi_single(NEW.kwhr_ilosciwkart, NEW.kwhr_ilosckart);
  array_delta_iloscwmag=NEW.kwhr_iloscwmag_arr;
  array_delta_iloscwmagclosed=NEW.kwhr_iloscwmagclosed_arr;
 END IF;
  
 IF (TG_OP='UPDATE') THEN
  delta_ilosc=array_sum(NEW.kwhr_ilosciwkart)*NEW.kwhr_ilosckart;
  delta_ilosc=delta_ilosc-array_sum(OLD.kwhr_ilosciwkart)*OLD.kwhr_ilosckart;  
  
  delta_iloscwmag=NEW.kwhr_iloscwmag-OLD.kwhr_iloscwmag;
  delta_iloscwmagclosed=NEW.kwhr_iloscwmagclosed-OLD.kwhr_iloscwmagclosed;
  IF (delta_iloscwmagclosed=0 AND delta_iloscwmag=0 AND delta_ilosc=0 AND NEW.kwhr_ilosciwkart=OLD.kwhr_ilosciwkart AND NEW.kwhr_ilosckart=OLD.kwhr_ilosckart) THEN
   RETURN NEW;
  END IF;
     
  array_delta_ilosc=array_minus(array_multi_single(NEW.kwhr_ilosciwkart, NEW.kwhr_ilosckart),array_multi_single(OLD.kwhr_ilosciwkart, OLD.kwhr_ilosckart));
  array_delta_iloscwmag=array_minus(NEW.kwhr_iloscwmag_arr, OLD.kwhr_iloscwmag_arr);
  array_delta_iloscwmagclosed=array_minus(NEW.kwhr_iloscwmagclosed_arr, OLD.kwhr_iloscwmagclosed_arr);
  
  _kwh_idheadu=NEW.kwhr_kwh_idheadu;  
  _pz_idplanu=NEW.kwhr_pz_idplanu;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  _kwh_idheadu=OLD.kwhr_kwh_idheadu;
  _pz_idplanu=OLD.kwhr_pz_idplanu;
  delta_ilosc=-array_sum(OLD.kwhr_ilosciwkart)*OLD.kwhr_ilosckart;
  
  array_delta_ilosc=array_multi_single(OLD.kwhr_ilosciwkart, -OLD.kwhr_ilosckart);
  array_delta_iloscwmag=array_multi_single(OLD.kwhr_iloscwmag_arr, -1);
  array_delta_iloscwmagclosed=array_multi_single(OLD.kwhr_iloscwmagclosed_arr, -1);
  
  delta_iloscwmag=-OLD.kwhr_iloscwmag;
  delta_iloscwmagclosed=-OLD.kwhr_iloscwmagclosed;
 END IF;
  
 IF (_kwh_idheadu>0 AND (delta_ilosc<>0 OR delta_iloscwmag<>0)) THEN
  UPDATE tr_kkwhead SET kwh_iloscoczek=kwh_iloscoczek+delta_ilosc, kwh_iloscoczek_array=array_round(array_plus(array_delta_ilosc,kwh_iloscoczek_array),4) WHERE kwh_idheadu=_kwh_idheadu;
 END IF;
 
 IF (_kwh_idheadu>0 AND _pz_idplanu>0 AND (delta_ilosc<>0 OR delta_iloscwmag<>0 OR delta_iloscwmagclosed<>0)) THEN
  FOR rec IN 
  SELECT
  kwh_towary,
  kwhr_index
  FROM
  (
   SELECT
   unnest(kwh_towary) AS kwh_towary,
   unnest(array_to_indexarray(kwh_towary)) AS kwhr_index
   FROM tr_kkwhead
   WHERE kwh_idheadu=_kwh_idheadu
  ) AS a   
  LOOP
   IF (COALESCE(rec.kwh_towary,0)<=0) THEN CONTINUE; END IF;
   IF (COALESCE(rec.kwhr_index,0)<=0) THEN CONTINUE; END IF;
   IF (COALESCE(array_delta_iloscwmag[rec.kwhr_index],0)=0 AND COALESCE(array_delta_iloscwmagclosed[rec.kwhr_index],0)=0) THEN CONTINUE; END IF;
  
   UPDATE gmr.tg_planzleceniarozmelems SET 
   pzw_ilosczreal=pzw_ilosczreal+NullZero(array_delta_iloscwmag[rec.kwhr_index]),
   pzw_ilosczrealclosed=pzw_ilosczrealclosed+NullZero(array_delta_iloscwmagclosed[rec.kwhr_index])
   WHERE 
   pz_idplanu=_pz_idplanu AND
   ttw_idtowaru_pdx=rec.kwh_towary;
  
  END LOOP;
 END IF;
 
  IF (_pz_idplanu>0 AND delta_ilosc<>0) THEN
   UPDATE tg_planzlecenia SET 
   pz_iloscroz=pz_iloscroz+delta_ilosc
   WHERE pz_idplanu=_pz_idplanu;
  END IF;
  
 IF (TG_OP='DELETE') THEN
  RETURN OLD; 
 END IF;
   
 RETURN NEW; 
END;
$$;
