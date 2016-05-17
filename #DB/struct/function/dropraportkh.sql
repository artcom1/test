CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN

 DELETE FROM kh_raportlisc WHERE rp_idraportu=$1;

 LOOP
  DELETE FROM kh_raportelem WHERE rp_idraportu=$1 AND re_idelementu NOT IN (SELECT re_ref FROM kh_raportelem WHERE re_ref IS NOT NULL);
  EXIT WHEN NOT FOUND;
 END LOOP;

 DELETE FROM kh_raporty WHERE rp_idraportu=$1;
 RETURN TRUE;
END;
$_$;
