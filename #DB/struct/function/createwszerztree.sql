CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwh_idheadu ALIAS FOR $1;
 r RECORD;
 _kwe_idelemu INT:=0;
 data timestamp without time zone;
 ilosc NUMERIC;
 tmp INT;
BEGIN
 ---pobieram dla kazdego noda daty z aktualnych planow (zaplanowane daty rozpoczecia, zakonczenia oraz rozpoczecia nastepnej operacji 
 ---wedlug ustawien noda operacji (rozpocznij kolejny etap) - w ten sposob nie umiemy policzyc daty rozpoczecia nastepnego etapu dla ustawienia
 ---rozpocznij po skonczeniu x operacji

  ---pobieramy ustawienia odnosnie planow kubelkowych
 tmp=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela='mrp_plan_tensam_kubelek');

 INSERT INTO tr_wt_tmp  
        SELECT kwe_olp,kwe_idelemu,minplan,maxplan , ustawieniedatynextoperacji(minplan,maxplan,the_nextbegin_x,the_flaga) AS datanext
	FROM tr_kkwnod 
	LEFT OUTER JOIN (
	       SELECT kwe_idelemu,min(knp_datarozpoczecia) AS minplan,max(CASE WHEN tmp='1' AND knp_flaga&32=32 THEN knp_datarozpoczecia ELSE knp_datazakonczenia END) AS maxplan
	       FROM tr_kkwnodplan
	       WHERE kwh_idheadu=_kwh_idheadu AND knp_flaga&(1|2|16)=0
	       GROUP BY kwe_idelemu
	     ) AS a USING (kwe_idelemu)
	WHERE kwh_idheadu=_kwh_idheadu;

 -----------------------------------------------------------------------------------------------------------------------------------------------
 ---dla ustawienia rozpocznij po skonczeniu x operacji analizujemy dokladnie plany dla tych operacji i staramy sie wyliczyc date skonczenia tych operacji, wyliczona w ten sposob date uaktualniamy w tabelce
 FOR r IN select kwe_idelemu, knp_datarozpoczecia, knp_datazakonczenia, sum(knp_iloscplanowana) OVER w1 AS iloscrozall , knp_iloscplanowana, sum(knp_iloscplanowana) OVER w AS iloscroz, rank() OVER w AS id, the_nextbegin_x from tr_kkwnodplan AS plan join tr_kkwnod AS nod using (kwe_idelemu) WHERE plan.kwh_idheadu=_kwh_idheadu AND nod.the_flaga&14=4 AND knp_flaga&(1|2|16)=0 WINDOW w AS (PARTITION BY kwe_idelemu ORDER BY knp_datazakonczenia), w1 AS (PARTITION BY kwe_idelemu)
 LOOP  
  IF (_kwe_idelemu<>r.kwe_idelemu) THEN
   ---mam do obrobki inny elem wiec zapisujemy dla wczesniejszego elemu to co wyliczylismy
   IF (_kwe_idelemu>0) THEN
    RAISE NOTICE 'UAKT PETLA % % ',_kwe_idelemu,data;
    UPDATE tr_wt_tmp SET datanext=data WHERE ide=_kwe_idelemu;
   END IF;
   _kwe_idelemu=r.kwe_idelemu;
  END IF;
  IF (r.iloscroz<=r.the_nextbegin_x) THEN
   data=r.knp_datazakonczenia; --nie mamy wszystkich planow, ustawiamy na koniec obecnych planow
  ELSE  
   IF ((r.iloscroz-r.knp_iloscplanowana)<r.the_nextbegin_x) THEN
   --w czesci tego planu zostala przekroczona ilosc operacji - liczymy proporcie wystepienia tego planu do ilosci gdzie zostaje przekroczona ilosc
    ilosc=r.the_nextbegin_x-(r.iloscroz-r.knp_iloscplanowana);
    data=r.knp_datarozpoczecia+((r.knp_datazakonczenia-r.knp_datarozpoczecia)/r.knp_iloscplanowana)*ilosc;
   END IF;
  END IF;
 END LOOP;

 --dla ostatniej obrabianej operacji musimy dokonac zapisu ustalonych danych
 IF (_kwe_idelemu>0) THEN
  RAISE NOTICE 'UAKT KONIEC % % ',_kwe_idelemu,data;
  UPDATE tr_wt_tmp SET datanext=data WHERE ide=_kwe_idelemu;
 END IF;
----koniec dla ustawien x operacji
-----------------------------------------------------------------------------------------------------------------------------------------------

 RETURN TRUE;
END
$_$;
