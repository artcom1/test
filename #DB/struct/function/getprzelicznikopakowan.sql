CREATE FUNCTION getprzelicznikopakowan(integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 idopak ALIAS FOR $1;
 przel NUMERIC;
BEGIN
 przel=ilosc;

 IF  (idopak=NULL) THEN
  RETURN przel;
 END IF;

 przel=(SELECT ja_licznik/ja_mianownik FROM tg_jednostkialt WHERE ja_idjednostki=idopak);
 RETURN przel;
END;
$_$;
