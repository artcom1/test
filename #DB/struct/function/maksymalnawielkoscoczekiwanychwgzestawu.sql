CREATE FUNCTION maksymalnawielkoscoczekiwanychwgzestawu(numeric, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ttw_idtowaru ALIAS FOR $1;
 _tmg_idmagazyn ALIAS FOR $2;

 wynik NUMERIC:=0;
 receptura RECORD;
BEGIN
  
 IF (_tmg_idmagazyn<0) THEN
  return 0;
 END IF;

 wynik=(SELECT min(NullZero(ttm_bkorderplus)/sz_ilosc) FROM tg_skladnikizestawu AS pr LEFT JOIN tg_towmag AS tw ON (tw.ttw_idtowaru=pr.ttw_idtowaru AND tw.tmg_idmagazynu=_tmg_idmagazyn) WHERE pr.ttw_idtowarusrc=_ttw_idtowaru AND sz_flaga&3=0);

 RETURN wynik;
END;
$_$;
