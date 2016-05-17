CREATE FUNCTION aktualizacjaprackalhead(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idhead ALIAS FOR $1;
 pracownik INT;
 prace NUMERIC;
 rechead RECORD;
 recpraca RECORD;
BEGIN
 UPDATE tb_kalendarzelem SET kale_rbhpraca=Round(0,2), kale_rbhobecnosc=Round(0,2) WHERE kalh_idkalendarzahead=_idhead;
 SELECT kalh_idkalendarzahead, kalh_datastartmies, kalh_datastopmies, p_idpracownika, kalh_rodzaj, kalh_flaga, fm_idcentrali INTO rechead FROM tb_kalendarzhead WHERE kalh_idkalendarzahead=_idhead;
 
 FOR recpraca IN SELECT pra_datastart::DATE AS dzien, SUM(pra_rbh) AS rbh, MIN(wyliczeniestartupracy(pra_datastart,pra_datastop,pra_rbh,pra_flaga)) AS pracaod, MAX(COALESCE(pra_datastop,pra_datastart)) AS pracado FROM tg_praceall WHERE pra_datastart::DATE>=rechead.kalh_datastartmies AND pra_datastart::DATE<=rechead.kalh_datastopmies AND pra_flaga&18=2 AND tg_praceall.p_idpracownika=rechead.p_idpracownika AND tg_praceall.fm_idcentrali=rechead.fm_idcentrali GROUP BY pra_datastart::DATE
 LOOP
  PERFORM aktualizacjaprackalelem(_idhead,recpraca.dzien,recpraca.rbh,0,recpraca.pracaod,recpraca.pracado, false);
 END LOOP;
 
 PERFORM przeliczkalhead(_idhead);
   
 RETURN 0;
END;
$_$;
