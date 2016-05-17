CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
----argumenty od_czasu, do_czasu, idbanku
DECLARE
 bilans RECORD;
 platnosci RECORD;
 b_otwarcia NUMERIC;
 pl_flaga INT;
 p_idpracownika INT;
BEGIN
  pl_flaga=132;   ----128+4
  p_idpracownika=38;
  DELETE FROM kh_platnosci WHERE PLisBilans(pl_flaga) AND pl_datawplywu::date>=date($1) AND pl_datawplywu::date<=date($2) AND bk_idbanku=$3;
  
  FOR platnosci IN SELECT pl_datawplywu,bk_idbanku,wl_idwaluty,pl_formaplat,sum	(round(pl_wartosc*pl_wplyw,2)) AS suma FROM kh_platnosci WHERE PLisNormal(pl_flaga) AND pl_datawplywu>=$1 AND pl_datawplywu<=$2 AND pl_formaplat<=2 AND bk_idbanku=$3 GROUP BY bk_idbanku,wl_idwaluty,pl_formaplat,pl_datawplywu ORDER BY pl_datawplywu ASC
     LOOP
        RAISE NOTICE 'MAM PLATNOSC';    		b_otwarcia=getBilansOtwarcia(platnosci.pl_datawplywu,platnosci.bk_idbanku,platnosci.wl_idwaluty,platnosci.pl_formaplat);
        INSERT INTO kh_platnosci (k_idklienta,pl_flaga,pl_wplyw, pl_wartosc, p_idpracownika, pl_formaplat,wl_idwaluty,bk_idbanku,pl_datawplywu) VALUES (0,pl_flaga,0,b_otwarcia,p_idpracownika,platnosci.pl_formaplat,platnosci.wl_idwaluty,platnosci.bk_idbanku,platnosci.pl_datawplywu);
     END LOOP;  
  RETURN 1;
END;$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
----argumenty od_czasu, do_czasu, idbanku, wl_idwaluty, formaplatnosci, UID
DECLARE
 bilans RECORD;
 platnosci RECORD;
 b_otwarcia NUMERIC;
 pl_flaga1 INT;
 p_idpracownika1 INT;
 data_bil DATE;
 data_wplywu TEXT;
BEGIN
  pl_flaga1=132;   ----128+4
  p_idpracownika1=$6;
  data_wplywu=$1;
  data_bil=$1;
 
  DELETE FROM kh_platnosci WHERE PLisBilans(pl_flaga) AND pl_datawplywu::date>=date($1::timestamp+'1 day'::interval) AND pl_datawplywu::date<=date($2::timestamp+'1 day'::interval) AND bk_idbanku=$3 AND pl_formaplat=$5 AND wl_idwaluty=$4;
  
  FOR platnosci IN SELECT pl_datawplywu,bk_idbanku,wl_idwaluty,pl_formaplat,sum	(round(pl_wartosc*pl_wplyw,2)) AS suma FROM kh_platnosci WHERE PLisNormal(pl_flaga) AND pl_datawplywu>=$1 AND pl_datawplywu<=$2 AND pl_formaplat=$5 AND wl_idwaluty=$4 AND bk_idbanku=$3 GROUP BY bk_idbanku,wl_idwaluty,pl_formaplat,pl_datawplywu ORDER BY pl_datawplywu ASC
     LOOP


       data_wplywu=platnosci.pl_datawplywu;
       b_otwarcia=getBilansOtwarcia(platnosci.pl_datawplywu,platnosci.bk_idbanku,platnosci.wl_idwaluty,platnosci.pl_formaplat);

        ---dodajemy bilanse na okres w ktorym nie bylo platnosci
        WHILE platnosci.pl_datawplywu>data_bil LOOP
          b_otwarcia=getBilansOtwarcia(data_bil,platnosci.bk_idbanku,platnosci.wl_idwaluty,platnosci.pl_formaplat);
          data_bil=date(data_bil::timestamp+'1.5 day'::interval);
          RAISE NOTICE 'MAM PLATNOSC %', data_bil;    		
          RAISE NOTICE 'MAM PLATNOSC bilans%', b_otwarcia;    		
          INSERT INTO kh_platnosci 
	   (k_idklienta,pl_flaga,pl_wplyw, pl_wartosc, p_idpracownika, pl_formaplat,wl_idwaluty,bk_idbanku,pl_datawplywu,fm_idcentrali) 
	  VALUES 
	  (0,pl_flaga1,0,b_otwarcia,p_idpracownika1,platnosci.pl_formaplat,platnosci.wl_idwaluty,platnosci.bk_idbanku,date(data_bil),(SELECT fm_idcentrali FROM ts_banki WHERE bk_idbanku=platnosci.bk_idbanku));
        END LOOP;
        data_bil=date(data_bil::timestamp+'1.5 day'::interval);	
	b_otwarcia=b_otwarcia+platnosci.suma::numeric;
         RAISE NOTICE 'bilans  %',b_otwarcia;    		
        INSERT INTO kh_platnosci 
	 (k_idklienta,pl_flaga,pl_wplyw, pl_wartosc, p_idpracownika, pl_formaplat,wl_idwaluty,bk_idbanku,pl_datawplywu,fm_idcentrali) 
	VALUES 
	 (0,pl_flaga1,0,b_otwarcia,p_idpracownika1,platnosci.pl_formaplat,platnosci.wl_idwaluty,platnosci.bk_idbanku,date(platnosci.pl_datawplywu::timestamp+'1.5 day'::interval),(SELECT fm_idcentrali FROM ts_banki WHERE bk_idbanku=platnosci.bk_idbanku));
     END LOOP;
   
     ---dodajemy bilanse w okresie w ktorym juz nie bylo zadnych platnosci
     WHILE $2>data_bil LOOP
	  b_otwarcia=getBilansOtwarcia(data_bil,$3,$4,$5);
          data_bil=date(data_bil::timestamp+'1.5 day'::interval);
	  RAISE NOTICE 'Nie mam PLATNOSC %',data_bil;    		
          RAISE NOTICE 'Nie mam bilans %',b_otwarcia;    		
	  INSERT INTO kh_platnosci 
	   (k_idklienta,pl_flaga,pl_wplyw, pl_wartosc, p_idpracownika, pl_formaplat,wl_idwaluty,bk_idbanku,pl_datawplywu,fm_idcentrali) 
	  VALUES (0,pl_flaga1,0,b_otwarcia,p_idpracownika1,$5,$4,$3,data_bil,(SELECT fm_idcentrali FROM ts_banki WHERE bk_idbanku=$3));
     END LOOP;
     
  RETURN 1;
END;$_$;
