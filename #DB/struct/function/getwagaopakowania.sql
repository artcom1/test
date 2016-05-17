CREATE FUNCTION getwagaopakowania(integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 idopak ALIAS FOR $1;
 waga NUMERIC;
BEGIN
 waga=0;

 IF  (idopak=NULL) THEN
  RETURN waga;
 END IF;

 waga=(SELECT ja_waga FROM tg_jednostkialt WHERE ja_idjednostki=idopak);
 RETURN waga;
END;
$_$;
