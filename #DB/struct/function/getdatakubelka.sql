CREATE FUNCTION getdatakubelka(date, time without time zone, time without time zone, integer) RETURNS timestamp without time zone
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kb_data ALIAS FOR $1;
 _zm_godzrozpoczecia ALIAS FOR $2;
 _zm_godzzakonczenia ALIAS FOR $3;
 _typ ALIAS FOR $4; ---0 data rozpoczecia, 1 data zakonczenia
 wynik timestamp without time zone;

BEGIN
 IF (_typ=0) THEN
  wynik=(_kb_data||' '||_zm_godzrozpoczecia)::timestamp;
 ELSE
  IF (_zm_godzzakonczenia<_zm_godzrozpoczecia) THEN
   _kb_data=_kb_data+1;
   wynik=(_kb_data||' '||_zm_godzzakonczenia)::timestamp;
  ELSE
   wynik=(_kb_data||' '||_zm_godzzakonczenia)::timestamp;
  END IF;
 END IF;

 return wynik;
END;
$_$;
