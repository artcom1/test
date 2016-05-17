CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
BEGIN
 return obliczodsetki( $1, '1979-11-29'::date, $2 ,$3);
END;
 $_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idrozrachunku ALIAS FOR $1;
 dataOdsetkiOd ALIAS FOR $2;
 dataOdsetkiDo ALIAS FOR $3;
 _idrodzajuOdsetek ALIAS FOR $4;
 wsp NUMERIC:=1;
 wynik NUMERIC:=0;
 dataodktorejliczymyodsetki DATE;

 kwota_do_odsetek NUMERIC;
 rr RECORD;
 wplata RECORD;
 dzientyg INT;
 _trybliczenia INTEGER;
BEGIN

 SELECT rr_datadokumentu,rr_dataplatnosci,rr_datazaplacenia,rr_iswn,rr_kwotawal,rr_wartoscpozwal INTO rr FROM kr_rozrachunki WHERE rr_idrozrachunku=_idrozrachunku;
 
 --- Sprawdzamy czy sa wogole jakies odsetki dla danego rozrachunku
 IF (rr.rr_dataplatnosci>=dataOdsetkiDo) THEN
  RETURN 0;
 END IF;
 --- Sprawdz czy nie zostalo zaplacone w terminie
 IF (rr.rr_dataplatnosci>=rr.rr_datazaplacenia) THEN
  RETURN 0;
 END IF;
 --- Ustaw wsp
 IF (rr.rr_iswn=FALSE) THEN
  wsp=-wsp;
 END IF;

 dataodktorejliczymyodsetki=max(dataOdsetkiOd,rr.rr_dataplatnosci::date);
 _trybliczenia := (SELECT COALESCE(ros_flaga,0)&1 FROM ts_rodzajeodsetek WHERE ros_idrodzaju=_idrodzajuOdsetek);

  IF (_trybliczenia=0) THEN
	 -----Sprawdzamy czy data nie wypadla w sobote lub niedziele
	 dzientyg=(SELECT extract(dow from dataodktorejliczymyodsetki));
	 IF (dzientyg=0) THEN
	  dataodktorejliczymyodsetki=dataodktorejliczymyodsetki+1;
	 END IF;
	 IF (dzientyg=6) THEN
	  dataodktorejliczymyodsetki=dataodktorejliczymyodsetki+2;
	 END IF;
	 ---Sprawdzamy czy data nie jest w dniach wolnych jak jest to przesuwamy dalej
	 dataodktorejliczymyodsetki=JakDzienWolnyToPrzesun(dataodktorejliczymyodsetki);
 END IF;

 ---Kwota do odsetek ustawiamy jako calosc faktury
 kwota_do_odsetek=rr.rr_kwotawal*wsp;

 FOR wplata IN SELECT sum(rl_wartoscwalsrc) AS rl_wartoscwalsrc,rl_datamax FROM krv_rozliczenia WHERE rr_idrozrachunkusrc=_idrozrachunku GROUP BY rl_datamax ORDER BY rl_datamax ASC
 LOOP
  ---jezeli platnosc przed terminem to odejmujemy jej wysokosc od kwoty do wyliczenia odsetek
  IF (wplata.rl_datamax<=dataodktorejliczymyodsetki) THEN
   kwota_do_odsetek=kwota_do_odsetek-wplata.rl_wartoscwalsrc*wsp;
  ELSE 
   --- dla okresu przeterminowanego obliczamy odsetki
   wynik=PodajOdsetki(wplata.rl_wartoscwalsrc*wsp,dataodktorejliczymyodsetki,wplata.rl_datamax,_idrodzajuOdsetek)+wynik;
   kwota_do_odsetek=kwota_do_odsetek-wplata.rl_wartoscwalsrc*wsp;
  END IF;
 END LOOP;

 wynik=PodajOdsetki(kwota_do_odsetek,dataodktorejliczymyodsetki,dataOdsetkiDo,_idrodzajuOdsetek)+wynik;

 return wynik;
END;
 $_$;
