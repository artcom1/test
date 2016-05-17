CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
---pierwszy argument identyfikator przenoszonego dokumentu, 2 identyfikator nazwy rejestru do ktorego przenosimy dokument

DECLARE
 data_ksiegowania ALIAS FOR $3;
 rejestr ALIAS FOR $2;
 tranhead RECORD;
 tranheadkorekta RECORD;
 flaga INT:=0;
 rh_idrejestru INT:=0;
 oid1 INT;
 pomoc_flaga INT;
 nr_dokumentu TEXT;
 ro_idroku_id INT;
 data_otrzymania DATE;
 data_wystawienia DATE;
 data_operacji DATE;
 data_platnosci DATE;
 flaga_vatu INT:=1;
 rodzaj_dok INT;
 korekta TEXT;
 query TEXT;
BEGIN
  
 ro_idroku_id=(SELECT ro_idroku FROM ts_nazwarejestru WHERE nr_idnazwy=rejestr);
  query='SELECT * ,extract(year from '||data_ksiegowania||')||UzupelnijMiesiac(extract(month from '||data_ksiegowania||')) AS miesiacksiegowania FROM tg_transakcje WHERE  tr_idtrans='||$1 ;
 
 FOR tranhead IN EXECUTE query
 LOOP
  IF (tranhead.tr_zamknieta&64::int2<>64 OR tranhead.tr_flaga&16=16) THEN
    RAISE NOTICE 'Nie znaleziono transakcji ktora jeszcze nie jest w rejestrze';
    RETURN -1;
  END IF;
 

  IF (tranhead.tr_rodzaj>=10 AND tranhead.tr_rodzaj<20) THEN
     flaga=flaga|2;
     rodzaj_dok=tranhead.tr_rodzaj-10;
     SELECT INTO tranheadkorekta * FROM tg_transakcje WHERE tr_idtrans=tranhead.tr_skojarzona;
     IF ((tranhead.tr_flaga&512)=512) THEN
       korekta=tranheadkorekta.tr_numer||'/'||trim(tranheadkorekta.tr_seria)||'/'||tranheadkorekta.tr_rok;
     ELSE
       korekta=tranheadkorekta.tr_nrobcy;
     END IF;
  ELSE
     rodzaj_dok=tranhead.tr_rodzaj;
  END IF;
  
  IF ((tranhead.tr_zamknieta&9728::int2)>0) THEN
    flaga=flaga|4;
  END IF;
  IF ((tranhead.tr_flaga&512)=512) THEN
  ----ustawiamy flagi dla rejestru sprzedazy 
     nr_dokumentu=tranhead.tr_numer||'/'||trim(tranhead.tr_seria)||'/'||tranhead.tr_rok||'/'||(SELECT DISTINCT trt_skrot FROM tg_rodzajtransakcji WHERE tr_rodzaj=tranhead.tr_rodzaj);
    data_wystawienia=tranhead.tr_datawystaw;
    data_operacji=tranhead.tr_datasprzedaz;
    data_otrzymania=tranhead.tr_datawystaw;
    IF ((tranhead.tr_zamknieta&128::int2)=128) THEN
      flaga=flaga|8;
    END IF;
  ELSE
  ----ustawiamy flagi dla rejestru zakupow
    nr_dokumentu=tranhead.tr_nrobcy;
    data_wystawienia=tranhead.tr_datawystaw;
    data_operacji=tranhead.tr_datasprzedaz;
    data_otrzymania=tranhead.tr_datasprzedaz;
    flaga=flaga|(((tranhead.tr_flaga&196608)>>16)<<3)|(((tranhead.tr_flaga&786432)>>18)<<6);
    flaga_vatu=2;
  END IF;
 

  pomoc_flaga=tranhead.tr_flaga&16;

  IF ((tranhead.tr_zamknieta&8192::int2)<>0) THEN
    flaga=flaga|1024;
  END IF;


  INSERT INTO kh_rejestrhead (rh_flaga,k_idklienta,rh_knazwa,rh_kadres, rh_nip,rh_kkodpocz,rh_kmiasto,rh_pozycja,nr_idnazwy,rh_formaplat,rh_dataotrzymania,rh_datawystaw,rh_dataoperacji,rh_dataplatnosci,rh_koszt,rh_numerdok,tr_idtrans,rh_korekta,rh_rodzaj,rh_netto,rh_brutto,rh_vat,mn_miesiac,ro_idroku) VALUES (flaga,tranhead.k_idklienta,tranhead.tr_knazwa,tranhead.tr_kadres, tranhead.tr_nip,tranhead.tr_kkodpocz,tranhead.tr_kmiasto,nullZero((SELECT max(rh_pozycja) FROM kh_rejestrhead WHERE nr_idnazwy=rejestr AND date_trunc('month',rh_dataoperacji)=date_trunc('month',data_operacji)))+1,rejestr,tranhead.tr_formaplat,data_otrzymania,data_wystawienia,data_operacji,tranhead.tr_dataplatnosci,tranhead.tr_koszt,nr_dokumentu,tranhead.tr_idtrans,korekta,rodzaj_dok,0,0,0,tranhead.miesiacksiegowania::int,ro_idroku_id);
  GET DIAGNOSTICS  oid1 = RESULT_OID;
  rh_idrejestru=getOID2idRecordu(oid1,'kh_rejestrhead','rh_idrejestru');
  flaga=przeniesTranelemyDoRejestru(rh_idrejestru,tranhead.tr_idtrans, tranhead.tr_zamknieta&128::int2,flaga_vatu);
 END LOOP;
 RETURN 0;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
---pierwszy argument identyfikator przenoszonego dokumentu, 2 identyfikator nazwy rejestru do ktorego przenosimy dokument
---czwarty argurmnt miesiac rejestru, 5 - czy zawsze numer wlasny
DECLARE
 rejestr ALIAS FOR $2;
 data_ksiegowania ALIAS FOR $3;
 miesiac ALIAS FOR $4;
 alwayswlasny ALIAS FOR $5;
 tranhead RECORD;
 tranheadkorekta RECORD;
 flaga INT:=0;
 rh_idrejestru INT:=0;
 oid1 INT;
 pomoc_flaga INT;
 nr_dokumentu TEXT;
 ro_idroku_id INT;
 data_otrzymania DATE;
 data_wystawienia DATE;
 data_operacji DATE;
 data_platnosci DATE;
 flaga_vatu INT:=3;
 rodzaj_dok INT;
 korekta TEXT;
 query TEXT;
BEGIN
  
 ro_idroku_id=(SELECT ro_idroku FROM ts_nazwarejestru WHERE nr_idnazwy=rejestr);
  query='SELECT * ,extract(year from '||data_ksiegowania||')||UzupelnijMiesiac(extract(month from '||data_ksiegowania||')) AS miesiacksiegowania FROM tg_transakcje WHERE  tr_idtrans='||$1 ;
 
 FOR tranhead IN EXECUTE query
 LOOP
  IF (miesiac<>'') THEN 
    tranhead.miesiacksiegowania=miesiac;
  END IF;
  IF ((tranhead.tr_zamknieta&64::int2<>64 AND tranhead.tr_rodzaj<>9) OR tranhead.tr_flaga&16=16) THEN
    ----RAISE NOTICE 'Nie znaleziono transakcji ktora jeszcze nie jest w rejestrze';
    RETURN -1;
  END IF;
 

  IF ((tranhead.tr_rodzaj>=10 AND tranhead.tr_rodzaj<20) OR tranhead.tr_rodzaj=245) THEN
     flaga=flaga|2;
     if (tranhead.tr_rodzaj=245) THEN
      rodzaj_dok=45;
     ELSE
       rodzaj_dok=tranhead.tr_rodzaj-10;
     END IF;
     SELECT INTO tranheadkorekta * FROM tg_transakcje WHERE tr_idtrans=tranhead.tr_skojarzona;
     IF ((tranhead.tr_flaga&512)=512) THEN
       korekta=tranheadkorekta.tr_numer||'/'||trim(tranheadkorekta.tr_seria)||'/'||tranheadkorekta.tr_rok;
     ELSE
       korekta=tranheadkorekta.tr_nrobcy;
     END IF;
  ELSE 
   IF (tranhead.tr_rodzaj=103) THEN
     rodzaj_dok=1;
   ELSE
     rodzaj_dok=tranhead.tr_rodzaj;
   END IF;
  END IF;
  
  IF ((tranhead.tr_zamknieta&9728::int2)>0) THEN
    flaga=flaga|4;
  END IF;
  IF ((tranhead.tr_rodzaj=9 OR tranhead.tr_rodzaj=19 ) THEN
    ---sprzedaz wewnetrzna traktujemy zawsze jako export
    flaga=flaga|4;
  END IF;
  IF (tranhead.tr_flaga&512)=512) THEN
  ----ustawiamy flagi dla rejestru sprzedazy 
    nr_dokumentu=tranhead.tr_numer||'/'||trim(tranhead.tr_seria)||'/'||tranhead.tr_rok||'/'||(SELECT DISTINCT trt_skrot FROM tg_rodzajtransakcji WHERE tr_rodzaj=tranhead.tr_rodzaj);
    data_wystawienia=tranhead.tr_datawystaw;
    data_operacji=tranhead.tr_datasprzedaz;
    data_otrzymania=tranhead.tr_datawystaw;
    IF ((tranhead.tr_zamknieta&128::int2)=128) THEN
      flaga=flaga|8;
    END IF;
  ELSE
  ----ustawiamy flagi dla rejestru zakupow
    IF (alwayswlasny) THEN
     nr_dokumentu=tranhead.tr_numer||'/'||trim(tranhead.tr_seria)||'/'||tranhead.tr_rok||'/'||(SELECT DISTINCT trt_skrot FROM tg_rodzajtransakcji WHERE tr_rodzaj=tranhead.tr_rodzaj);
    ELSE
     nr_dokumentu=tranhead.tr_nrobcy;
    END IF;
    data_wystawienia=tranhead.tr_datawystaw;
    data_operacji=tranhead.tr_datasprzedaz;
    data_otrzymania=tranhead.tr_datasprzedaz;
    flaga=flaga|((((tranhead.tr_flaga&196608)>>16)|((tranhead.tr_flaga&16777216)>>22))<<3)|(((tranhead.tr_flaga&786432)>>18)<<6);
-----    flaga_vatu=2;
  END IF;
  ----RAISE NOTICE 'Mam numer wlasny %',nr_dokumentu;
 

  pomoc_flaga=tranhead.tr_flaga&16;

  IF ((tranhead.tr_zamknieta&8192::int2)<>0) THEN
    flaga=flaga|1024;
  END IF;


  INSERT INTO kh_rejestrhead (rh_flaga,k_idklienta,rh_knazwa,rh_kadres, rh_nip,rh_kkodpocz,rh_kmiasto,rh_pozycja,nr_idnazwy,rh_formaplat,rh_dataotrzymania,rh_datawystaw,rh_dataoperacji,rh_dataplatnosci,rh_koszt,rh_numerdok,tr_idtrans,rh_korekta,rh_rodzaj,rh_netto,rh_brutto,rh_vat,mn_miesiac,ro_idroku) VALUES (flaga,tranhead.k_idklienta,tranhead.tr_knazwa,tranhead.tr_kadres, tranhead.tr_nip,tranhead.tr_kkodpocz,tranhead.tr_kmiasto,nullZero((SELECT max(rh_pozycja) FROM kh_rejestrhead WHERE nr_idnazwy=rejestr AND date_trunc('month',rh_dataoperacji)=date_trunc('month',data_operacji)))+1,rejestr,tranhead.tr_formaplat,data_otrzymania,data_wystawienia,data_operacji,tranhead.tr_dataplatnosci,tranhead.tr_koszt,substring(nr_dokumentu,0,30),tranhead.tr_idtrans,substring(korekta,0,30),rodzaj_dok,0,0,0,tranhead.miesiacksiegowania::int,ro_idroku_id);
  GET DIAGNOSTICS  oid1 = RESULT_OID;
  rh_idrejestru=getOID2idRecordu(oid1,'kh_rejestrhead','rh_idrejestru');
  ----RAISE NOTICE 'flaga vatu %',flaga_vatu;
  flaga=przeniesTranelemyDoRejestru(rh_idrejestru,tranhead.tr_idtrans, tranhead.tr_zamknieta&128::int2,flaga_vatu);
 END LOOP;
 RETURN 0;
END;
$_$;
