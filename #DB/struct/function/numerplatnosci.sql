CREATE FUNCTION numerplatnosci(text, text, integer, date, integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 seria ALIAS FOR $1;
 sseria ALIAS FOR $2;
 numer ALIAS FOR $3;
 data ALIAS FOR $4;
 flaga ALIAS FOR $5;
 sseriapref TEXT:='';
BEGIN

 IF (flaga&3)=3 THEN  --Kompensata
  RETURN numer::text||'/'||substr(data::text,3,2);
 END IF;

 IF (sseria IS NOT NULL) AND (sseria!='') THEN
  sseriapref=sseria||'/';
 END IF;

 IF (flaga&3)<>1 THEN  --Bank lub inne
  IF (numer=NULL) THEN
   RETURN sseriapref||seria;
  ELSE
   RETURN sseriapref||numer::text||'/'||seria;
  END IF;
 ELSE
  RETURN sseriapref||substr(data::text,6,2)||substr(data::text,9,2)||'/'||seria||'/'||numer::text;
 END IF;

END;
$_$;
