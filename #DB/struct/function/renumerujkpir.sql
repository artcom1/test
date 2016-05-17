CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _miesiac ALIAS FOR $1;
 _ksiega ALIAS FOR $2;
 _rok ALIAS FOR $3;
 miesiacpop INT;
 pozyc INT;
 rejestr RECORD;
 miesiecznanumeracja TEXT;
 nazwaustawienia TEXT;
BEGIN
  nazwaustawienia='ksiegakpmies';
  miesiacpop=_miesiac-1;
  IF ((miesiacpop % 100)=0 ) THEN
    miesiacpop=miesiacpop-88;
  END IF;

  miesiecznanumeracja=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela=nazwaustawienia);
  IF (miesiecznanumeracja='1') THEN
  ------miesieczna numeracja
    pozyc=0;
  ELSE
    IF (_ksiega) THEN
      pozyc=(SELECT max(kp_pozycja) FROM kh_zapisykpir WHERE mn_miesiac=miesiacpop AND kp_flaga&2=2 AND ro_idroku=_rok);
    ELSE ---dla buforu biezemy zapisy z ksiegi i buforu (poprzedni miesiac moze byc przeniesieno do ksiegi)
      pozyc=(SELECT max(kp_pozycja) FROM kh_zapisykpir WHERE mn_miesiac=miesiacpop AND ro_idroku=_rok  );
    END IF;
  END IF;
  IF (pozyc=0 OR pozyc=NULL) THEN
     pozyc=1;
  ELSE 
     pozyc=pozyc+1;
  END IF;

  IF (_ksiega) THEN
   FOR rejestr IN SELECT kp_idzapisu, kp_pozycja FROM kh_zapisykpir WHERE mn_miesiac=_miesiac AND kp_flaga&2=2 AND ro_idroku=_rok ORDER BY kp_dataop, mylpad(mysubstr(kp_numerdok,1,strpos(kp_numerdok,'/')-1),20,'0') ASC ,kp_pozycja
   LOOP
     UPDATE kh_zapisykpir SET kp_pozycja=pozyc WHERE kp_idzapisu=rejestr.kp_idzapisu;
     pozyc=1+pozyc;
   END LOOP;
  ELSE
   FOR rejestr IN SELECT kp_idzapisu, kp_pozycja FROM kh_zapisykpir WHERE mn_miesiac=_miesiac AND kp_flaga&2=0 AND ro_idroku=_rok ORDER BY kp_dataop, mylpad(mysubstr(kp_numerdok,1,strpos(kp_numerdok,'/')-1),20,'0') ASC ,kp_pozycja
   LOOP
     UPDATE kh_zapisykpir SET kp_pozycja=pozyc WHERE kp_idzapisu=rejestr.kp_idzapisu;
     pozyc=1+pozyc;
   END LOOP;
  END IF;
  RETURN 1;
END;
$_$;
