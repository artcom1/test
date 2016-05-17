CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _nrzapisu ALIAS FOR $1;   --- Numer headu
 _datazapisu ALIAS FOR $2; --- Miesiac
 _dziennik ALIAS FOR $3;   --- Dziennik
 _pozycja ALIAS FOR $4;    --- Numer elemu
 _typ ALIAS FOR $5;        --- Typ
 dziennik TEXT;
 dzien TEXT;
BEGIN

 dziennik:=(SELECT dz_kod FROM kh_dziennik WHERE dz_iddziennika=_dziennik);
 dzien:=substring(_datazapisu::text,length(_datazapisu::text)-3,4);

 IF (dzien='9999') THEN
  dzien='BZ';
 END IF;

 IF (_typ&4=4) THEN
  dziennik:='BZ-'||dziennik;
 END IF;

 RETURN dziennik||'/'||dzien||'/'||_nrzapisu;
END;
$_$;
