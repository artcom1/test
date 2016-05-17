CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
 t TEXT;
BEGIN

 LOOP

  RAISE NOTICE 'Poaczatek petli';
  SELECT * INTO r FROM kh_konta WHERE kt_l=NULL AND kt_r=NULL AND (kt_ref=NULL OR (SELECT kt_l FROM kh_konta AS k WHERE k.kt_idkonta=kh_konta.kt_ref) IS NOT NULL) ORDER BY random() LIMIT 1 OFFSET 0;
  IF NOT FOUND THEN   
   RETURN TRUE;
  END IF;
 
  t:=r.kt_prefix||'-'||r.kt_numer;
  RAISE NOTICE 'Konto % % ',r.kt_idkonta,t;
 
  UPDATE kh_konta SET kt_flaga=kt_flaga|32768 WHERE kt_idkonta=r.kt_idkonta;

  RAISE NOTICE 'Koniec petli';

 END LOOP;

 RETURN TRUE;
END;
$$;
