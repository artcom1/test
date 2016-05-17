CREATE FUNCTION czymogewykonacoperacjenastanowisku(integer, integer, integer, integer, integer[], integer[]) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwe_idelemu ALIAS FOR $1;
 _kwe_flaga ALIAS FOR $2;
 _nod_ob_idobiektu ALIAS FOR $3;
 _the_idelem ALIAS FOR $4;
 _arr_stanowiska ALIAS FOR $5;
 _arr_rodzaje ALIAS FOR $6;
 _tmp_int INT;
 _query TEXT;
 _rec RECORD;
BEGIN
 -- 1. Sprawdzenie czy mam jakis kontekst stanowisk
 IF (_arr_stanowiska IS NULL OR _arr_rodzaje IS NULL) THEN
  -- RAISE NOTICE '1 % % % % % % %',_kwe_idelemu,_kwe_flaga,_nod_ob_idobiektu,_the_idelem,array_to_string(_arr_stanowiska,','),array_to_string(_arr_rodzaje,','),_tmp_int;
  RETURN TRUE;
 END IF;
  
 -- 2. Porownanie bezposrednio ze stanowiskiem z nodem
 IF (COALESCE(_nod_ob_idobiektu,0)>0) THEN
  FOREACH _tmp_int IN ARRAY _arr_stanowiska
  LOOP
   IF (_nod_ob_idobiektu=_tmp_int) THEN
    -- RAISE NOTICE '2 % % % % % % %',_kwe_idelemu,_kwe_flaga,_nod_ob_idobiektu,_the_idelem,array_to_string(_arr_stanowiska,','),array_to_string(_arr_rodzaje,','),_tmp_int;
    RETURN TRUE;
   END IF;
  END LOOP;
 END IF;
   
 -- 3. Stanowiska pracy z technoelemu 
 IF (_the_idelem IS NOT NULL) THEN
  _query='SELECT count(*) AS ile
		 FROM tr_technostpracy AS tsp
		 JOIN tg_obiekty AS tspob ON (tspob.ob_idobiektu=tsp.ob_idobiektu)
		 WHERE 
		 the_idelem='||_the_idelem||' AND tsp_flaga&(1<<2)=0 AND 
		 (tsp.ob_idobiektu IN ('||array_to_string(_arr_stanowiska,',')||') OR (tsp_flaga&(1<<8)=(1<<8) AND rb_idrodzaju IN ('||array_to_string(_arr_rodzaje,',')||')))';
   
  EXECUTE _query INTO _rec;
  IF (_rec.ile>0) THEN
   -- RAISE NOTICE '3 % % % % % % %',_kwe_idelemu,_kwe_flaga,_nod_ob_idobiektu,_the_idelem,array_to_string(_arr_stanowiska,','),array_to_string(_arr_rodzaje,','),_tmp_int;
   RETURN TRUE;
  END IF;
 END IF;
 
 -- 4. Porownanie z planem
 IF (_kwe_flaga&(1<<3)=0) THEN -- Nie mam zadnego planu, z niczym juz nie moge porownywac, wiec koncze z falsem
  -- RAISE NOTICE '4 % % % % % % %',_kwe_idelemu,_kwe_flaga,_nod_ob_idobiektu,_the_idelem,array_to_string(_arr_stanowiska,','),array_to_string(_arr_rodzaje,','),_tmp_int;
  RETURN FALSE;
 END IF;
 
 _query='SELECT count(*) AS ile
		FROM tr_kkwnodplan AS nodp
		WHERE 
		kwe_idelemu='||_kwe_idelemu||' AND 
		knp_flaga&((1<<0)&(1<<1)&(1<<4))=0 AND 
		nodp.ob_idobiektu IN ('||array_to_string(_arr_stanowiska,',')||')';
 
 EXECUTE _query INTO _rec;   
 IF (_rec.ile>0) THEN
  -- RAISE NOTICE '5 % % % % % % %',_kwe_idelemu,_kwe_flaga,_nod_ob_idobiektu,_the_idelem,array_to_string(_arr_stanowiska,','),array_to_string(_arr_rodzaje,','),_tmp_int;
  RETURN TRUE;
 END IF;
      
 -- RAISE NOTICE '6 % % % % % % %',_kwe_idelemu,_kwe_flaga,_nod_ob_idobiektu,_the_idelem,array_to_string(_arr_stanowiska,','),array_to_string(_arr_rodzaje,','),_tmp_int;
 RETURN FALSE;
END;
$_$;
