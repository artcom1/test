CREATE FUNCTION aktualizacjapracykalelem(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
 _roznica INTERVAL;
 _obecnosc NUMERIC;
 recelem RECORD;
 rechead RECORD;
BEGIN
 UPDATE tb_kalendarzelem SET kale_rbhpraca=Round(0,2), kale_rbhobecnosc=Round(0,2) WHERE kale_idkalendarzaelem=_idelem;   
 SELECT kalh_idkalendarzahead AS idhead, SUM(pra_rbh) AS rbh, MIN(wyliczeniestartupracy(pra_datastart,pra_datastop,pra_rbh,pra_flaga)) AS pracaod, MAX(COALESCE(pra_datastop,pra_datastart)) AS pracado INTO recelem FROM tb_kalendarzelem AS elem JOIN tb_kalendarzhead AS head USING (kalh_idkalendarzahead) JOIN tg_praceall AS pr ON (pr.pra_datastart::DATE=elem.kale_dzien) WHERE kale_idkalendarzaelem=_idelem AND pra_flaga&18=2 AND pr.p_idpracownika=head.p_idpracownika AND pr.fm_idcentrali=head.fm_idcentrali GROUP BY kalh_idkalendarzahead; 
 
 _roznica=recelem.pracado-recelem.pracaod;
 _obecnosc=date_part('days',_roznica)*24+date_part('hours',_roznica)+date_part('minute',_roznica)/60;
 _obecnosc=round(_obecnosc,2);
 
 UPDATE tb_kalendarzelem SET kale_pracastart=recelem.pracaod, kale_pracastop=recelem.pracado, kale_rbhpraca=COALESCE(recelem.rbh,Round(0,2)), kale_rbhobecnosc=_obecnosc WHERE kale_idkalendarzaelem=_idelem;
 
 SELECT SUM(kale_rbhpraca) AS _rbhpraca, SUM(kale_rbhurlop) AS _rbhurlop, SUM(kale_rbhnormatyw) AS _rbhnormatyw, SUM(kale_rbhchorobowe) AS _rbhchorobowe, SUM(kale_rbhodebranienadgodzin) AS _rbhodebranienadgodzin, SUM(kale_rbhinne) AS _rbhinne, SUM(kale_rbhobecnosc) AS _rbhobecnosc INTO rechead FROM tb_kalendarzelem WHERE kalh_idkalendarzahead=recelem.idhead GROUP BY kalh_idkalendarzahead;
 UPDATE tb_kalendarzhead SET kalh_rbhpraca=COALESCE(rechead._rbhpraca,Round(0,2)), kalh_rbhurlop=COALESCE(rechead._rbhurlop,Round(0,2)), kalh_rbhnormatyw=COALESCE(rechead._rbhnormatyw,Round(0,2)), kalh_rbhchorobowe=COALESCE(rechead._rbhchorobowe,Round(0,2)), kalh_rbhodebranienadgodzin=COALESCE(rechead._rbhodebranienadgodzin,Round(0,2)), kalh_rbhinne=COALESCE(rechead._rbhinne,Round(0,2)), kalh_rbhobecnosc=COALESCE(rechead._rbhobecnosc,Round(0,2)), kalh_flaga=(SELECT (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) FROM tb_kalendarzelem WHERE (kale_rbhnormatyw-kale_rbhurlop-kale_rbhchorobowe-kale_rbhinne-kale_rbhpraca)<>0 AND kalh_idkalendarzahead=recelem.idhead) WHERE kalh_idkalendarzahead=recelem.idhead;
   
 RETURN 0;
END;
$_$;
