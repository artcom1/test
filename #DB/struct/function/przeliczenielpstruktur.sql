CREATE FUNCTION przeliczenielpstruktur(integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _sk_idstrukturyp ALIAS FOR $1;
 lp INT:=1;
 _rec RECORD;
BEGIN

 FOR _rec IN SELECT skr_idrelacji FROM tr_strukturakonstrukcyjnarel WHERE sk_idstrukturyp=_sk_idstrukturyp ORDER BY skr_idrelacji ASC
 LOOP
  UPDATE tr_strukturakonstrukcyjnarel SET skr_lp=lp WHERE skr_idrelacji=_rec.skr_idrelacji;
  lp=lp+1;
 END LOOP;

 RETURN lp;
END;
$_$;
