CREATE FUNCTION getczasefektywnykkwnodwyk(_knw_idelemu integer, _zaangazpracwyk numeric, _start timestamp without time zone, _stop timestamp without time zone, _updatezachodzacych boolean) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
 _czas     NUMERIC;
 wynik_l   NUMERIC:=0;
 wynik_p   NUMERIC:=0;
 wynik     NUMERIC:=0;
 rec       RECORD;
 recUpdate RECORD;
BEGIN

 -- czas efektywny=(czas_prac_danejoperacji*knw_zaangazpracwykonanie)+suma_dla_kazdej_operacji_w_czasie_tej_operacji_dla_pracownika(czas_zachodzacy*knw_zaangazpracwykonanie)
 _czas=(EXTRACT(epoch FROM _stop-_start)/3600)::NUMERIC;
 wynik_l=_czas*_zaangazpracwyk/100;
 
 SELECT sum((knw_zaangazpracwykonanie/100)*wsp) AS wyniksql INTO rec FROM 
 (
  SELECT knw_idelemu, knw_zaangazpracwykonanie, getCzasWspolny(knw_datastart::timestamp, knw_datawyk::timestamp, _start, _stop) AS wsp
  FROM tr_kkwnodwyk  
  WHERE   
  knw_flaga&1=1 AND
  knw_idelemu IN
  (
   SELECT knw_idelemu
   FROM tr_kkwnodwykdet  
   WHERE 
   p_idpracownika IN (SELECT p_idpracownika FROM tr_kkwnodwykdet WHERE knw_idelemu=_knw_idelemu) AND
   knw_idelemu<>_knw_idelemu
  )
 ) AS a
 WHERE wsp>0;
 
 wynik_p=rec.wyniksql; 
 wynik=nullzero(wynik_l)+nullzero(wynik_p); 
 wynik=round(wynik,4);
 
 IF (_updateZachodzacych) THEN
  FOR recUpdate IN 
  SELECT knw_idelemu, (knw_zaangazpracwykonanie/100)*wsp AS wyniksql
  FROM
  (
   SELECT knw_idelemu, knw_zaangazpracwykonanie, getCzasWspolny(knw_datastart::timestamp, knw_datawyk::timestamp, _start, _stop) AS wsp
   FROM tr_kkwnodwyk  
   WHERE
   knw_flaga&1=1 AND
   knw_idelemu IN
   (
    SELECT knw_idelemu
    FROM tr_kkwnodwykdet  
    WHERE 
    p_idpracownika IN (SELECT p_idpracownika FROM tr_kkwnodwykdet WHERE knw_idelemu=_knw_idelemu) AND
    knw_idelemu<>_knw_idelemu
   )
  ) AS a
  WHERE wsp>0
  LOOP    
   UPDATE tr_kkwnodwyk 
   SET knw_czasefektywny=getCzasEfektywnyKKWNodWyk(knw_idelemu, knw_zaangazpracwykonanie, knw_datastart::TIMESTAMP, knw_datawyk::TIMESTAMP, FALSE)
   WHERE knw_idelemu=recUpdate.knw_idelemu;
  END LOOP;   
 END IF;
 
 RETURN wynik;
END;
$$;
