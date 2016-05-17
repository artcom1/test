CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 idopak ALIAS FOR $1;
 ilosc ALIAS FOR $2;
 przel NUMERIC;
BEGIN
 przel=ilosc;

 IF  (idopak=NULL) THEN
  RETURN przel;
 END IF;

 przel=(SELECT (ilosc*ja_mianownik)/ja_licznik FROM tg_jednostkialt WHERE ja_idjednostki=idopak);
 RETURN przel;
END;
$_$;
