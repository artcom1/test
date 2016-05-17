CREATE FUNCTION getokresysymulacji(integer) RETURNS TABLE(id integer, nazwa text, data_od timestamp without time zone, data_do timestamp without time zone)
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rk_idrozmiaru ALIAS FOR $1;

 _ksym_rok_start INT;
 _ksym_rok_stop INT;
 _ksym_rok_acc INT;
 
 _ksym_okres_start INT;
 _ksym_okres_stop INT;
 
 _ksym_okres_min INT; 
 _ksym_okres_max INT;
 
BEGIN
 _ksym_rok_start=(SELECT ksym_rok FROM tr_kubelkisymulacyjne WHERE ksym_czasod<now() AND rk_idrozmiaru=_rk_idrozmiaru ORDER BY ksym_rok DESC, ksym_poczatek DESC LIMIT 1);
 _ksym_okres_start=(SELECT ksym_poczatek FROM tr_kubelkisymulacyjne WHERE ksym_czasod<now() AND rk_idrozmiaru=_rk_idrozmiaru ORDER BY ksym_rok DESC, ksym_poczatek DESC LIMIT 1);
 
 _ksym_rok_stop=(SELECT ksym_rok FROM tr_kubelkisymulacyjne WHERE rk_idrozmiaru=_rk_idrozmiaru ORDER BY ksym_rok DESC, ksym_poczatek DESC LIMIT 1);
 _ksym_okres_stop=(SELECT ksym_poczatek FROM tr_kubelkisymulacyjne WHERE rk_idrozmiaru=_rk_idrozmiaru ORDER BY ksym_rok DESC, ksym_poczatek DESC LIMIT 1);
 
 IF (_ksym_rok_start IS NULL OR _ksym_okres_start IS NULL OR _ksym_rok_stop IS NULL OR _ksym_okres_stop IS NULL) THEN
  RETURN;  
 END IF;
 
 FOR i IN _ksym_rok_start.._ksym_rok_stop LOOP
  
  _ksym_okres_min=1;
  IF (i=_ksym_rok_start) THEN
   _ksym_okres_min=_ksym_okres_start;
  END IF;
  
  _ksym_okres_max=1;  
  IF (i=_ksym_rok_stop) THEN
   _ksym_okres_max=_ksym_okres_stop;
  ELSE
   _ksym_okres_max=(SELECT getMaxOkresKubelkaSymulacyjnego(_rk_idrozmiaru,i));  
  END IF;
    
  FOR j IN _ksym_okres_min.._ksym_okres_max LOOP
   id = (i * 100000 + j);
   nazwa = i || ' - Okres ' || j;
   data_od = (SELECT getDataOdKubelkaSymulacyjnego(_rk_idrozmiaru, i, j));
   data_do = (SELECT getDataDoKubelkaSymulacyjnego(_rk_idrozmiaru, i, j));   
   RETURN NEXT;   
  END LOOP;
 END LOOP;
END;
$_$;
