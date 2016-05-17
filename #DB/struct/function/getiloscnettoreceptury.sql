CREATE FUNCTION getiloscnettoreceptury(integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _tsk_idskladnika ALIAS FOR $1;
 skladnik RECORD;
 ilosc NUMERIC:=0;
 zanik NUMERIC:=0;
BEGIN
 SELECT tsk_ilosc, tsk_idreceptury, tsk_zanik, tsk_flaga INTO skladnik FROM tg_produkcja WHERE tsk_idskladnika=_tsk_idskladnika;
 IF ((skladnik.tsk_flaga&(512+3))=1) THEN
   --wyrob
   zanik=(SELECT tsk_zanik FROM tg_produkcja WHERE tsk_idskladnika=skladnik.tsk_idreceptury);
   ilosc=skladnik.tsk_ilosc*(1-zanik/100);
 ELSE
    zanik=skladnik.tsk_zanik;
    ilosc=skladnik.tsk_ilosc/(1+zanik/100);
 END IF;

 RETURN Round(ilosc,4);

END;
$_$;
