CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
---funckja wylicza koszt dla uslugi wedlug danych zapisanych na kartotece uslugi
---pierwszy argument to id towaru
---drugi argument ilosc 
---trzeci argument cena netto w walucie podstawowej
DECLARE
 ttw_idtowaru ALIAS FOR $1;
 ilosc ALIAS FOR $2;
 wartoscpln ALIAS FOR $3;
 towar RECORD;
 wynik NUMERIC;
 cena NUMERIC;
 query TEXT;
BEGIN
 
 IF (newflaga&256=256) THEN
  ---Zestaw
  RETURN COALESCE(oldvalue,0);
 END IF;
 
 IF (ttw_idtowaru IS NULL) THEN
  RETURN 0;
 END IF;
 
 wynik=0;
 cena=0;
 IF (ilosc<>0) THEN
  cena=round(wartoscpln/ilosc,2);
 END IF;

 query='SELECT * FROM tg_towary WHERE  ttw_idtowaru='||ttw_idtowaru ;
 
 FOR towar IN EXECUTE query
 LOOP
  ---obliczamy czesc kwotowa
  wynik=wynik+towar.ttw_kosztkw*ilosc;

  ---obliczamy czesc procentowa
  ---liczenie od netto
  IF ((towar.ttw_flaga&1792)=0) THEN
    wynik=wynik+towar.ttw_kosztpr*ilosc*cena/100;
  END IF ;
  ---liczenie od brutto
  IF ((towar.ttw_flaga&1792)=256) THEN
    wynik=wynik+towar.ttw_kosztpr*ilosc*(cena+cena*towar.ttw_vats/100)/100;
  END IF ;
  wynik=round(wynik/(1+towar.ttw_vatm::numeric/100),2);
 END LOOP;

 wynik=ilosc*cena-wynik;

 RETURN floorRound(wynik);
END;
$_$;
