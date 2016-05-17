CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _knr_idelemu ALIAS FOR $1;
 _ilosc ALIAS FOR $2;
 _ttw_idtowaru ALIAS FOR $3;
 _zl_idzlecenia ALIAS FOR $4;
 query TEXT;
 d RECORD;
 iledoznalezienia NUMERIC;
 iloscplan NUMERIC;
 wynik NUMERIC:=0;
 _ppp_idelem INT:=0;
BEGIN
 IF (_ilosc>0) THEN
  ---szukamy czy sa powiazania dodane programowo, jesli tak to je aktualizujemy (nawet w nadmiarze i nie szukamy innych planow
  _ppp_idelem=(SELECT ppp_idelem FROM tr_powiazanieplanprzychod WHERE ppp_flaga&2=2 AND knr_idelemu=_knr_idelemu ORDER BY pz_idplanu ASC LIMIT 1);
  
  IF (_ppp_idelem>0) THEN ---jest takie powiazanie, jego zwiekszamy i wychodzimy
   UPDATE tr_powiazanieplanprzychod SET ppp_iloscroz=ppp_iloscroz+_ilosc WHERE ppp_idelem=_ppp_idelem;
   return _ilosc; 
  END IF;

  iledoznalezienia=_ilosc;
  ---musimy dodac nowe powiazania
  query='SELECT pz_idplanu, pz_ilosc-pz_iloscroz AS ilosc FROM tg_planzlecenia ';
  query=query||'WHERE pz_flaga&(1<<19)=(1<<19) AND pz_flaga&(2)=(0) AND pz_flaga&(1<<16)=0 AND pz_flaga&(1<<18)=(1<<18) '; ---tylko plany przeniesione do realizacji nie wykonane na otwartych zleceniach
  query=query||' AND (pz_ilosc-pz_iloscroz)>0 '; ----tylko gdzie cos jeszcze jest niezrozplanowana
  query=query||' AND ttw_idtowaru='||_ttw_idtowaru;
  IF (_zl_idzlecenia>0) THEN
   query=query||' AND zl_idzlecenia='||_zl_idzlecenia; ---wskazane zlecenie
  END IF;
  query=query||' ORDER BY pz_data ASC, zl_idzlecenia ASC, pz_lp ASC, pz_idplanu ASC ';

  FOR d IN EXECUTE query
  LOOP      
   IF (iledoznalezienia<=0) THEN RETURN wynik; END IF;

   iloscplan=d.ilosc;
   
   IF (iloscplan>iledoznalezienia) THEN
    iloscplan=iledoznalezienia;
   END IF;
   iledoznalezienia=iledoznalezienia-iloscplan;
   wynik=wynik+iloscplan;

   INSERT INTO tr_powiazanieplanprzychod (pz_idplanu,knr_idelemu, ppp_iloscroz) VALUES (d.pz_idplanu,_knr_idelemu, iloscplan);  
  END LOOP;

 ELSE
  ---byla zmiejszona ilosc musimy zmniejszyc powiazania ktore juz istnieja;
  iledoznalezienia=-_ilosc;
  query='SELECT ppp_idelem, ppp_iloscroz, ppp_iloscwyk FROM tr_powiazanieplanprzychod WHERE knr_idelemu='||_knr_idelemu;
  query=query||' ORDER BY ppp_iloscwyk ASC, ppp_idelem DESC ';

  FOR d IN EXECUTE query
  LOOP      
   IF (iledoznalezienia<=0) THEN RETURN wynik; END IF;

   iloscplan=d.ppp_iloscroz;
   
   IF (iloscplan>iledoznalezienia) THEN
    UPDATE tr_powiazanieplanprzychod SET ppp_iloscroz=ppp_iloscroz-iledoznalezienia WHERE ppp_idelem=d.ppp_idelem;
    wynik=wynik-iledoznalezienia;
    iledoznalezienia=0;
   ELSE 
    IF (d.ppp_iloscwyk=0) THEN
     ---nie mamy wykonania wiec mozemy skasowac rekord
     DELETE FROM tr_powiazanieplanprzychod WHERE ppp_idelem=d.ppp_idelem;
    ELSE
     UPDATE tr_powiazanieplanprzychod SET ppp_iloscroz=ppp_iloscroz-iloscplan WHERE ppp_idelem=d.ppp_idelem;
    END IF;
    wynik=wynik-iloscplan;
    iledoznalezienia=iledoznalezienia-iloscplan;
   END IF;
  END LOOP;
 END IF;

 return wynik;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _knr_idelemu ALIAS FOR $1;
 _ilosc ALIAS FOR $2;
 _ttw_idtowaru ALIAS FOR $3;
 _zl_idzlecenia ALIAS FOR $4;
 _knr_flaga ALIAS FOR $5;
 query TEXT;
 d RECORD;
 iledoznalezienia NUMERIC;
 iloscplan NUMERIC;
 wynik NUMERIC:=0;
 _ppp_idelem INT:=0;
BEGIN
 IF (_ilosc>=0) THEN
  ---szukamy czy sa powiazania dodane programowo, jesli tak to je aktualizujemy (nawet w nadmiarze i nie szukamy innych planow
  _ppp_idelem=(SELECT ppp_idelem FROM tr_powiazanieplanprzychod WHERE ppp_flaga&2=2 AND knr_idelemu=_knr_idelemu ORDER BY pz_idplanu ASC LIMIT 1);
  
  IF (_ppp_idelem>0) THEN ---jest takie powiazanie, jego zwiekszamy i wychodzimy
   UPDATE tr_powiazanieplanprzychod SET ppp_iloscroz=ppp_iloscroz+_ilosc WHERE ppp_idelem=_ppp_idelem;
   return _ilosc; 
  END IF;

  IF (_knr_flaga&32=0) THEN
   return 0; ---nie mamy ustawionej opcji szukania planow wiec tego nie robimy
  END IF;

  iledoznalezienia=_ilosc;
  ---musimy dodac nowe powiazania
  query='SELECT pz_idplanu, pz_ilosc-pz_iloscroz AS ilosc FROM tg_planzlecenia ';
  query=query||'WHERE pz_flaga&(1<<19)=(1<<19) AND pz_flaga&(2)=(0) AND pz_flaga&(1<<16)=0 AND pz_flaga&(1<<18)=(1<<18) '; ---tylko plany przeniesione do realizacji nie wykonane na otwartych zleceniach
  query=query||' AND (pz_ilosc-pz_iloscroz)>0 '; ----tylko gdzie cos jeszcze jest niezrozplanowana
  query=query||' AND ttw_idtowaru='||_ttw_idtowaru;
  IF (_zl_idzlecenia>0) THEN
   query=query||' AND zl_idzlecenia='||_zl_idzlecenia; ---wskazane zlecenie
  END IF;
  query=query||' ORDER BY pz_data ASC, zl_idzlecenia ASC, pz_lp ASC, pz_idplanu ASC ';

  FOR d IN EXECUTE query
  LOOP      
   IF (iledoznalezienia<=0) THEN RETURN wynik; END IF;

   iloscplan=d.ilosc;
   
   IF (iloscplan>iledoznalezienia) THEN
    iloscplan=iledoznalezienia;
   END IF;
   iledoznalezienia=iledoznalezienia-iloscplan;
   wynik=wynik+iloscplan;

   INSERT INTO tr_powiazanieplanprzychod (pz_idplanu,knr_idelemu, ppp_iloscroz) VALUES (d.pz_idplanu,_knr_idelemu, iloscplan);  
  END LOOP;

 ELSE
  ---byla zmiejszona ilosc musimy zmniejszyc powiazania ktore juz istnieja;
  iledoznalezienia=-_ilosc;
  query='SELECT ppp_idelem, ppp_iloscroz, ppp_iloscwyk FROM tr_powiazanieplanprzychod WHERE knr_idelemu='||_knr_idelemu;
  query=query||' ORDER BY ppp_iloscwyk ASC, ppp_idelem DESC ';

  FOR d IN EXECUTE query
  LOOP      
   IF (iledoznalezienia<=0) THEN RETURN wynik; END IF;

   iloscplan=d.ppp_iloscroz;
   
   IF (iloscplan>iledoznalezienia) THEN
    UPDATE tr_powiazanieplanprzychod SET ppp_iloscroz=ppp_iloscroz-iledoznalezienia WHERE ppp_idelem=d.ppp_idelem;
    wynik=wynik-iledoznalezienia;
    iledoznalezienia=0;
   ELSE 
    IF (d.ppp_iloscwyk=0) THEN
     ---nie mamy wykonania wiec mozemy skasowac rekord
     DELETE FROM tr_powiazanieplanprzychod WHERE ppp_idelem=d.ppp_idelem AND ppp_flaga&2=0;
     UPDATE tr_powiazanieplanprzychod SET ppp_iloscroz=0 WHERE ppp_idelem=d.ppp_idelem AND ppp_flaga&2=2;
    ELSE
     UPDATE tr_powiazanieplanprzychod SET ppp_iloscroz=ppp_iloscroz-iloscplan WHERE ppp_idelem=d.ppp_idelem;
    END IF;
    wynik=wynik-iloscplan;
    iledoznalezienia=iledoznalezienia-iloscplan;
   END IF;
  END LOOP;
 END IF;

 return wynik;
END;
$_$;
