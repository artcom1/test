CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 pkidref ALIAS FOR $1;
 wynik TEXT='';
 pack RECORD;
BEGIN
 FOR pack IN SELECT pk_idpaczki FROM tg_packhead WHERE pk_idref=pkidref
 LOOP
  wynik=wynik||','||getIDPaczekPodrzednych(pack.pk_idpaczki);
 END LOOP;

 wynik=pkidref::text||wynik;

 RETURN wynik;
END;
$_$;
