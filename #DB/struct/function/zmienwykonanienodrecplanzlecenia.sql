CREATE FUNCTION zmienwykonanienodrecplanzlecenia(integer, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _knr_idelemu ALIAS FOR $1;
 _ilosc ALIAS FOR $2;
 query TEXT;
 d RECORD;
 iledoznalezienia NUMERIC;
 iloscplan NUMERIC;
 wynik NUMERIC:=0;
BEGIN
 IF (_ilosc>0) THEN
  ---byla zwiekszenie ilosc musimy zwiekszyc wykonanie (maksimum tego co mozemy wykonac;
  iledoznalezienia=_ilosc;
  query='SELECT ppp_idelem, ppp_iloscroz-ppp_iloscwyk AS ile FROM tr_powiazanieplanprzychod WHERE ppp_iloscroz-ppp_iloscwyk>0 AND knr_idelemu='||_knr_idelemu;
  query=query||' ORDER BY ppp_idelem ASC ';

  FOR d IN EXECUTE query
  LOOP      
   IF (iledoznalezienia<=0) THEN RETURN wynik; END IF;

   iloscplan=d.ile;
   
   IF (iloscplan>iledoznalezienia) THEN
    iloscplan=iledoznalezienia;
   END IF;

   UPDATE tr_powiazanieplanprzychod SET ppp_iloscwyk=ppp_iloscwyk+iloscplan WHERE ppp_idelem=d.ppp_idelem;
   wynik=wynik+iloscplan;
   iledoznalezienia=iledoznalezienia-iloscplan;
  END LOOP;
  
  ---sprawdzamy czy nam cos jeszcze nie zostalo z wykonania, jak tak to dodajemy do pierwszego skojarzenia
  IF (iledoznalezienia>0) THEN
   query='SELECT ppp_idelem FROM tr_powiazanieplanprzychod WHERE  knr_idelemu='||_knr_idelemu;
   query=query||' ORDER BY ppp_idelem ASC LIMIT 1';

   FOR d IN EXECUTE query
   LOOP      
    UPDATE tr_powiazanieplanprzychod SET ppp_iloscwyk=ppp_iloscwyk+iledoznalezienia WHERE ppp_idelem=d.ppp_idelem;
    wynik=wynik+iledoznalezienia;
   END LOOP;
  END IF;

 ELSE
  ---byla zmiejszona ilosc musimy zmniejszyc powiazania ktore juz istnieja;
  iledoznalezienia=-_ilosc;
  query='SELECT ppp_idelem, ppp_iloscwyk FROM tr_powiazanieplanprzychod WHERE knr_idelemu='||_knr_idelemu;
  query=query||' ORDER BY ppp_idelem DESC ';

  FOR d IN EXECUTE query
  LOOP      
   IF (iledoznalezienia<=0) THEN RETURN wynik; END IF;

   iloscplan=d.ppp_iloscwyk;
   
   IF (iloscplan>iledoznalezienia) THEN
    iloscplan=iledoznalezienia;
   END IF;

   UPDATE tr_powiazanieplanprzychod SET ppp_iloscwyk=ppp_iloscwyk-iloscplan WHERE ppp_idelem=d.ppp_idelem;
   wynik=wynik-iloscplan;
   iledoznalezienia=iledoznalezienia-iloscplan;

  END LOOP;
 END IF;

 return wynik;
END;
$_$;
