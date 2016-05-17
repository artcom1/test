CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _miesiac ALIAS FOR $1;
 _rejestr ALIAS FOR $2;
 miesiacpop INT;
 pozyc INT;
 rejestr RECORD;
 miesiecznanumeracja TEXT;
 nazwaustawienia TEXT;
BEGIN
  nazwaustawienia='REJVATMIES';
  miesiacpop=_miesiac-1;
  IF ((miesiacpop % 100)=0 ) THEN
    miesiacpop=miesiacpop-88;
  END IF;
  miesiecznanumeracja=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela=nazwaustawienia);
  IF (miesiecznanumeracja='1') THEN
  ------miesieczna numeracja
    pozyc=1;
  ELSE
  ----roczna numeracja
    pozyc=(SELECT max(rh_pozycja) FROM kh_rejestrhead WHERE mn_miesiac=miesiacpop AND nr_idnazwy=_rejestr );
    IF (pozyc=0 OR pozyc=NULL) THEN
      pozyc=1;
    ELSE 
      pozyc=pozyc+1;
    END IF;
  END IF;
  FOR rejestr IN SELECT rh_idrejestru, rh_pozycja FROM kh_rejestrhead WHERE mn_miesiac=_miesiac AND  nr_idnazwy=_rejestr ORDER BY rh_dataotrzymania, mylpad(mysubstr(rh_numerdok,1,strpos(rh_numerdok,'/')-1),20,'0') ASC ,rh_numerdok,rh_pozycja
  LOOP
    UPDATE kh_rejestrhead SET rh_pozycja=pozyc WHERE rh_idrejestru=rejestr.rh_idrejestru;
    pozyc=1+pozyc;
  END LOOP;
  RETURN 1;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 pozyc INT;
 rejestr RECORD;
BEGIN
  pozyc=(SELECT max(rh_pozycja) FROM kh_rejestrhead WHERE rh_dataotrzymania<$1 AND nr_idnazwy=$3 );
  IF (pozyc=0 OR pozyc=NULL) THEN
     pozyc=1;
  END IF;
  FOR rejestr IN SELECT rh_idrejestru, rh_pozycja FROM kh_rejestrhead LEFT JOIN tg_transakcje USING (tr_idtrans) WHERE rh_dataotrzymania>=$1 AND rh_dataotrzymania<=$2 AND nr_idnazwy=$3 ORDER BY rh_dataotrzymania, tr_numer, rh_numerdok,rh_pozycja
  LOOP
    UPDATE kh_rejestrhead SET rh_pozycja=pozyc WHERE rh_idrejestru=rejestr.rh_idrejestru;
    pozyc=1+pozyc;
  END LOOP;
  RETURN 1;
END;
$_$;
