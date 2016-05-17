CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 kalk ALIAS FOR $1;
 kolumna ALIAS FOR $2;
 tryb ALIAS FOR $3;
 ret  NUMERIC:=0;
 inne NUMERIC:=0;
BEGIN 

 -- Tryby:
 -- 0 - tylko moje
 -- 1 - z podrzednymi

 -- Kolumny: 
 -- KOSZT_MATERIALY     0
 IF (kolumna=0) THEN ret=kalk.kalk_koszt_materialy; END IF;
 IF (kolumna=0 AND tryb=1 AND kalk.kalk_przelicznik<>0) THEN 
  ret=ret+(kalk.kalk_koszt_materialy_podrz/kalk.kalk_przelicznik)::NUMERIC;
 END IF;
 -- KOSZT_ZAKUP         1
 IF (kolumna=1) THEN
  ret=mrpkalkulacjagetkolumna(kalk,0,tryb);
  ret=ret*(kalk.kalk_narzut_zakup/100);
 END IF;
 -- KOSZT_ROBOCIZNA     2
 IF (kolumna=2) THEN ret=kalk.kalk_koszt_robocizna; END IF;
 IF (kolumna=2 AND tryb=1 AND kalk.kalk_przelicznik<>0) THEN 
  ret=ret+(kalk.kalk_koszt_robocizna_podrz/kalk.kalk_przelicznik)::NUMERIC;
 END IF;
 -- KOSZT_OBROBKA_OBCA  3
 IF (kolumna=3) THEN ret=kalk.kalk_koszt_obrobkaobca; END IF;
 IF (kolumna=3 AND tryb=1 AND kalk.kalk_przelicznik<>0) THEN 
  ret=ret+(kalk.kalk_koszt_obrobkaobca_podrz/kalk.kalk_przelicznik)::NUMERIC;
 END IF;
 -- KOSZT_NARZEDZIA     4
 IF (kolumna=4) THEN ret=kalk.kalk_koszt_narzedzia; END IF;
 IF (kolumna=4 AND tryb=1 AND kalk.kalk_przelicznik<>0) THEN 
  ret=ret+(kalk.kalk_koszt_narzedzia_podrz/kalk.kalk_przelicznik)::NUMERIC; 
 END IF;
 -- KOSZT_WYDZIALOWE    5
 IF (kolumna=5) THEN ret=kalk.kalk_koszt_wydzialowe; END IF;
 IF (kolumna=5 AND tryb=1 AND kalk.kalk_przelicznik<>0) THEN 
  ret=ret+(kalk.kalk_koszt_wydzialowe_podrz/kalk.kalk_przelicznik)::NUMERIC;
 END IF;
 -- KOSZT_OGOLNO_ZAK    6
 IF (kolumna=6) THEN
  ret=mrpkalkulacjagetkolumna(kalk,2,tryb);
  ret=ret*(kalk.kalk_narzut_ogolnozakladowe/100);
 END IF;
 -- KOSZT_WYTWORZENIA   7
 IF (kolumna=7) THEN
  ret=mrpkalkulacjagetkolumna(kalk,0,tryb)+mrpkalkulacjagetkolumna(kalk,1,tryb)+mrpkalkulacjagetkolumna(kalk,2,tryb);
  ret=ret+mrpkalkulacjagetkolumna(kalk,3,tryb)+mrpkalkulacjagetkolumna(kalk,4,tryb)+mrpkalkulacjagetkolumna(kalk,5,tryb);
  ret=ret+mrpkalkulacjagetkolumna(kalk,6,tryb);
 END IF;
 -- KOSZT_STRATA_W_BRAK 8
 IF (kolumna=8) THEN
  ret=mrpkalkulacjagetkolumna(kalk,7,tryb);
  ret=ret*(kalk.kalk_narzut_stratawbrakach/100);
 END IF;
 -- KOSZT_INNE_I_PRZEROB 9
 IF (kolumna=9) THEN inne=kalk.kalk_koszt_inne; END IF;
 IF (kolumna=9 AND tryb=1 AND kalk.kalk_przelicznik<>0) THEN 
  inne=inne+(kalk.kalk_koszt_wydzialowe_podrz/kalk.kalk_przelicznik)::NUMERIC; 
 END IF;
 IF (kolumna=9) THEN
  ret=mrpkalkulacjagetkolumna(kalk,7,tryb);
  ret=ret*(kalk.kalk_narzut_przerobu/100);
  ret=ret+inne;
 END IF;
 -- KOSZT_WLASNE        10
 IF (kolumna=10) THEN
  ret=mrpkalkulacjagetkolumna(kalk,7,tryb)+mrpkalkulacjagetkolumna(kalk,8,tryb)+mrpkalkulacjagetkolumna(kalk,9,tryb);
 END IF;
 -- KOSZT_MARZA         11
 IF (kolumna=11) THEN
  ret=mrpkalkulacjagetkolumna(kalk,10,tryb);
  ret=ret*(kalk.kalk_narzut_zysku/100);
 END IF;
 -- KOSZT_WARTOSC       12
 IF (kolumna=12) THEN
  ret=mrpkalkulacjagetkolumna(kalk,10,tryb)+mrpkalkulacjagetkolumna(kalk,11,tryb);
 END IF;

 ret=COALESCE(ret,0); 
 RETURN ret;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 kalk ALIAS FOR $1;
 _kalk_ilosc ALIAS FOR $2;
 kolumna ALIAS FOR $3;
 _is_calkowite ALIAS FOR $4;
 _is_PLN ALIAS FOR $5;
 tryb ALIAS FOR $6;
 
 ret NUMERIC:=0;
BEGIN 
 IF (_kalk_ilosc<=0) THEN
  RETURN 0;
 END IF;
 
 ret=mrpkalkulacjagetkolumna(kalk,kolumna,tryb);
 
 IF (_is_calkowite=FALSE) THEN
  ret=ret/_kalk_ilosc;
 END IF;
 
 IF (_is_PLN=TRUE) THEN
  ret=ret*kalk.kalk_przelicznik::NUMERIC;
 END IF;
  
 ret=round(ret,4);
 RETURN ret;
END;
$_$;
