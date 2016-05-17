CREATE FUNCTION przeliczkalhead(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idhead ALIAS FOR $1;
 rechead RECORD;
BEGIN
 SELECT SUM(kale_rbhpraca) AS _rbhpraca, SUM(kale_rbhurlop) AS _rbhurlop, SUM(kale_rbhnormatyw) AS _rbhnormatyw, SUM(kale_rbhchorobowe) AS _rbhchorobowe, SUM(kale_rbhinne) AS _rbhinne, SUM(kale_rbhodebranienadgodzin) AS _rbhodebranienadgodzin, SUM(kale_rbhobecnosc) AS _rbhobecnosc INTO rechead FROM tb_kalendarzelem WHERE kalh_idkalendarzahead=_idhead GROUP BY kalh_idkalendarzahead;
 UPDATE tb_kalendarzhead SET kalh_dataaktrbh=now(), kalh_rbhpraca=COALESCE(rechead._rbhpraca,Round(0,2)), kalh_rbhurlop=COALESCE(rechead._rbhurlop,Round(0,2)), kalh_rbhnormatyw=COALESCE(rechead._rbhnormatyw,Round(0,2)), kalh_rbhchorobowe=COALESCE(rechead._rbhchorobowe,Round(0,2)), kalh_rbhinne=COALESCE(rechead._rbhinne,Round(0,2)), kalh_rbhodebranienadgodzin=COALESCE(rechead._rbhodebranienadgodzin,Round(0,2)), kalh_rbhobecnosc=COALESCE(rechead._rbhobecnosc,Round(0,2)), kalh_flaga=(SELECT (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) FROM tb_kalendarzelem WHERE (kale_rbhnormatyw-kale_rbhurlop-kale_rbhchorobowe-kale_rbhinne-kale_rbhpraca)<>0 AND kalh_idkalendarzahead=_idhead) WHERE kalh_idkalendarzahead=_idhead;
 RETURN 0;
END;
$_$;
