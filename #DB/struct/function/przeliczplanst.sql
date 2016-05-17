CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
----funkcja przelicza wartosci bierzace po amortyzacji danego planu dla podanego srodka trwalego
DECLARE
 _str_id ALIAS FOR $1;
 srodek RECORD;
 zdarzenie RECORD;
 plan RECORD;
 query TEXT;
 query_plan TEXT;
 wartosc_srodka NUMERIC;
 wartosc_do_amor NUMERIC;
 wartosc_srodkakoszt NUMERIC;
 wartosc_do_amorkoszt NUMERIC;
 miesiac_od INT;
 miesiac_do INT;
BEGIN
 SELECT str_id,substring(str_datarozp::text,1,4)||substring(str_datarozp::text,6,2) AS miesiacroz, str_datarozp,str_stawkaam,str_stawkaamkoszt,str_wartpocz,str_wartpoczkoszt,str_wartprzen, str_wartprzenkoszt INTO srodek FROM st_srodkitrwale WHERE str_id=_str_id;

 IF (srodek.str_id IS NULL) THEN
  RETURN FALSE;
 END IF;
 
 IF (srodek.str_wartpocz<=0 OR srodek.str_wartpoczkoszt<=0) THEN
  return FALSE;
 END IF;
 
 ---ustawiamy miesiac rozpoczecia amortyzacji
 miesiac_od=srodek.miesiacroz::int;
 wartosc_srodka=srodek.str_wartpocz; 
 wartosc_do_amor=srodek.str_wartpocz-srodek.str_wartprzen;

 wartosc_srodkakoszt=srodek.str_wartpoczkoszt; 
 wartosc_do_amorkoszt=srodek.str_wartpoczkoszt-srodek.str_wartprzenkoszt;


 query='SELECT * FROM st_zdarzeniast  WHERE str_id='||_str_id||' ORDER BY nm_miesiac ASC ';
 FOR zdarzenie IN EXECUTE query
 LOOP
      ---szukam planu do tego zdarzenia by uaktualnic ich wartosci
      query_plan='SELECT * FROM st_planst WHERE str_id='||_str_id||' AND nm_miesiac<'||zdarzenie.nm_miesiac||' AND nm_miesiac>='||miesiac_od||' ORDER BY nm_miesiac ASC';
      FOR plan IN EXECUTE query_plan
      LOOP
  wartosc_do_amor=wartosc_do_amor-plan.pl_wartosc;
  wartosc_do_amorkoszt=wartosc_do_amorkoszt-plan.pl_wartosckoszt;
  UPDATE st_planst SET pl_wartoscbiez=wartosc_do_amor,pl_wartoscbiezkoszt=wartosc_do_amorkoszt WHERE pl_idplanu=plan.pl_idplanu;
      END LOOP;
      miesiac_od=zdarzenie.nm_miesiac;
      wartosc_do_amor=wartosc_do_amor+zdarzenie.zd_zwiekszenie;
      wartosc_do_amorkoszt=wartosc_do_amorkoszt+zdarzenie.zd_zwiekszeniekoszt;
 END LOOP;

 ---szukamy planow po ostatnim zdarzeniu
 query_plan='SELECT * FROM st_planst WHERE str_id='||_str_id||' AND  nm_miesiac>='||miesiac_od||' ORDER BY nm_miesiac ASC';
 FOR plan IN EXECUTE query_plan
 LOOP
      wartosc_do_amor=wartosc_do_amor-plan.pl_wartosc;
      wartosc_do_amorkoszt=wartosc_do_amorkoszt-plan.pl_wartosckoszt;
      UPDATE st_planst SET pl_wartoscbiez=wartosc_do_amor,pl_wartoscbiezkoszt=wartosc_do_amorkoszt  WHERE pl_idplanu=plan.pl_idplanu;
 END LOOP;
 DELETE FROM st_planst WHERE str_id=_str_id AND pl_wartoscbiez<0 AND pl_wartosc<=abs(pl_wartoscbiez) AND pl_wartoscbiezkoszt<0 AND pl_wartosckoszt<=abs(pl_wartoscbiezkoszt);
 UPDATE st_planst SET pl_wartosc=0 WHERE str_id=_str_id AND pl_wartoscbiez<0 AND pl_wartosc<=abs(pl_wartoscbiez);
 UPDATE st_planst SET pl_wartosckoszt=0 WHERE str_id=_str_id AND pl_wartoscbiezkoszt<0 AND pl_wartosckoszt<=abs(pl_wartoscbiezkoszt);
 UPDATE st_planst SET pl_wartosc=pl_wartosc-abs(pl_wartoscbiez) WHERE str_id=_str_id AND pl_wartoscbiez<0 AND pl_wartosc>abs(pl_wartoscbiez);
 UPDATE st_planst SET pl_wartosckoszt=pl_wartosckoszt-abs(pl_wartoscbiezkoszt) WHERE str_id=_str_id AND pl_wartoscbiezkoszt<0 AND pl_wartosckoszt>abs(pl_wartoscbiezkoszt);

 return wartosc_do_amor;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
----funkcja przelicza wartosci bierzace po amortyzacji danego planu dla podanego srodka trwalego
DECLARE
 _str_id ALIAS FOR $1;
 _miesiac_od ALIAS FOR $2;
 srodek RECORD;
 zdarzenie RECORD;
 plan RECORD;
 query TEXT;
 query_plan TEXT;
 wartosc_srodka NUMERIC;
 wartosc_do_amor NUMERIC;
 wartosc_srodkakoszt NUMERIC;
 wartosc_do_amorkoszt NUMERIC;
 miesiac_od INT;
 miesiac_do INT;
BEGIN
 SELECT str_id,substring(str_datarozp::text,1,4)||substring(str_datarozp::text,6,2) AS miesiacroz, str_datarozp,str_stawkaam,str_stawkaamkoszt,str_wartpocz,str_wartpoczkoszt,str_wartprzen, str_wartprzenkoszt INTO srodek FROM st_srodkitrwale WHERE str_id=_str_id;

 IF (srodek.str_id IS NULL) THEN
  RETURN 0;
 END IF;
 
 IF (srodek.str_wartpocz<=0 OR srodek.str_wartpoczkoszt<=0) THEN
  return FALSE;
 END IF;
 
 ---ustawiamy miesiac rozpoczecia amortyzacji
 miesiac_od=srodek.miesiacroz::int;
 wartosc_srodka=srodek.str_wartpocz; 
 wartosc_do_amor=srodek.str_wartpocz-srodek.str_wartprzen;
 wartosc_srodkakoszt=srodek.str_wartpoczkoszt; 
 wartosc_do_amorkoszt=srodek.str_wartpoczkoszt-srodek.str_wartprzenkoszt;


 query='SELECT * FROM st_zdarzeniast  WHERE str_id='||_str_id||' ORDER BY nm_miesiac ASC ';
 FOR zdarzenie IN EXECUTE query
 LOOP
      ---szukam planu do tego zdarzenia by uaktualnic ich wartosci
      query_plan='SELECT * FROM st_planst WHERE str_id='||_str_id||' AND nm_miesiac<'||zdarzenie.nm_miesiac||' AND nm_miesiac>='||miesiac_od||' ORDER BY nm_miesiac ASC';
      FOR plan IN EXECUTE query_plan
      LOOP
  wartosc_do_amor=wartosc_do_amor-plan.pl_wartosc;
  wartosc_do_amorkoszt=wartosc_do_amorkoszt-plan.pl_wartosckoszt;
  IF (plan.nm_miesiac>_miesiac_od) THEN
  ---uaktualniamy tylko pozniejsze
        UPDATE st_planst SET pl_wartoscbiez=wartosc_do_amor,pl_wartoscbiezkoszt=wartosc_do_amorkoszt WHERE pl_idplanu=plan.pl_idplanu; 
  END IF;
      END LOOP;
      miesiac_od=zdarzenie.nm_miesiac;
      wartosc_do_amor=wartosc_do_amor+zdarzenie.zd_zwiekszenie;
      wartosc_do_amorkoszt=wartosc_do_amorkoszt+zdarzenie.zd_zwiekszeniekoszt;
 END LOOP;

 ---szukamy planow po ostatnim zdarzeniu
 query_plan='SELECT * FROM st_planst WHERE str_id='||_str_id||' AND  nm_miesiac>='||miesiac_od||' ORDER BY nm_miesiac ASC';
 FOR plan IN EXECUTE query_plan
 LOOP
      wartosc_do_amor=wartosc_do_amor-plan.pl_wartosc;
      wartosc_do_amorkoszt=wartosc_do_amorkoszt-plan.pl_wartosckoszt;
      IF (plan.nm_miesiac>_miesiac_od) THEN
  ---uaktualniamy tylko pozniejsze
         UPDATE st_planst SET pl_wartoscbiez=wartosc_do_amor, pl_wartoscbiezkoszt=wartosc_do_amorkoszt WHERE pl_idplanu=plan.pl_idplanu;
      END IF;
 END LOOP;

 DELETE FROM st_planst WHERE pl_idplanu IN (SELECT pl_idplanu FROM st_planst WHERE str_id=_str_id AND pl_wartoscbiez<0 AND pl_wartosc<=abs(pl_wartoscbiez) AND pl_wartoscbiezkoszt<0 AND pl_wartosckoszt<=abs(pl_wartoscbiezkoszt) ORDER BY nm_miesiac DESC LIMIT 1 OFFSET 0 );
 UPDATE st_planst SET pl_wartosc=0 WHERE str_id=_str_id AND pl_wartoscbiez<0 AND pl_wartosc<=abs(pl_wartoscbiez);
 UPDATE st_planst SET pl_wartosckoszt=0 WHERE str_id=_str_id AND pl_wartoscbiezkoszt<0 AND pl_wartosckoszt<=abs(pl_wartoscbiezkoszt);
 UPDATE st_planst SET pl_wartosc=pl_wartosc-abs(pl_wartoscbiez) WHERE str_id=_str_id AND pl_wartoscbiez<0 AND pl_wartosc>abs(pl_wartoscbiez);
 UPDATE st_planst SET pl_wartosckoszt=pl_wartosckoszt-abs(pl_wartoscbiezkoszt) WHERE str_id=_str_id AND pl_wartoscbiezkoszt<0 AND pl_wartosckoszt>abs(pl_wartoscbiezkoszt);

 return wartosc_do_amor;
END;
$_$;
