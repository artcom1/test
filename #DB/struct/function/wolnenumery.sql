CREATE FUNCTION wolnenumery(integer, text, text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rodzaj ALIAS FOR $1;
 _seria ALIAS FOR $2;
 _rok ALIAS FOR $3;
 r RECORD;
 lastnr INT;
BEGIN

 lastnr=0;
 FOR r IN SELECT tr_numer FROM tg_transakcje WHERE tr_rodzaj=_rodzaj AND tr_seria=_seria AND tr_rok=_rok ORDER BY tr_numer ASC
 LOOP
  IF (r.tr_numer!=lastnr+1) THEN
   lastnr=lastnr+1;
   RAISE NOTICE 'Brak numeru % jest %',lastnr,r.tr_numer;
  END IF;
  lastnr=r.tr_numer;
 END LOOP;

 RETURN TRUE;
END;
$_$;
