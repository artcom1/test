CREATE FUNCTION droprokkh(integer, boolean DEFAULT false) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 ile INT;
BEGIN

 DELETE FROM kh_raportlisc WHERE rp_idraportu IN (SELECT rp_idraportu FROM kh_raporty WHERE ro_idroku=$1);
 DELETE FROM kh_zapisyhead WHERE ro_idroku=$1;
 
 LOOP
  DELETE FROM kh_konta WHERE ro_idroku=$1 AND kt_idkonta NOT IN (SELECT kt_ref FROM kh_konta WHERE kt_ref IS NOT NULL);
  
  ile=(SELECT count(*) FROM kh_konta WHERE ro_idroku=$1);
  
  EXIT WHEN ile=0;
  RAISE NOTICE 'Pozostalo % kont',ile;  
 END LOOP;

 DELETE FROM kh_wzorce WHERE ro_idroku=$1;
 
 IF ($2=TRUE) THEN
  DELETE FROM kh_lata WHERE ro_idroku=$1;
 END IF;
 
 RETURN TRUE;
END;
$_$;
