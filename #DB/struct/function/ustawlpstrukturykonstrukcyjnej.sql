CREATE FUNCTION ustawlpstrukturykonstrukcyjnej(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _skr_idrelacji ALIAS FOR $1;
 _new_lp INT:=$2;
 pl1 RECORD;
 max_lp INT;
BEGIN
  SELECT skr_idrelacji, skr_lp, sk_idstrukturyp INTO pl1 FROM tr_strukturakonstrukcyjnarel WHERE skr_idrelacji=_skr_idrelacji;
  
  max_lp:=(SELECT skr_lp FROM tr_strukturakonstrukcyjnarel WHERE sk_idstrukturyp=pl1.sk_idstrukturyp  order by skr_lp desc limit 1);

  IF (_new_lp <= 0) THEN
    _new_lp := 1;
  END IF;
  
  IF (_new_lp > max_lp) THEN
    _new_lp := max_lp;
  END IF;

  IF (_new_lp < pl1.skr_lp) THEN
    UPDATE tr_strukturakonstrukcyjnarel SET skr_lp=skr_lp+1 WHERE sk_idstrukturyp=pl1.sk_idstrukturyp AND skr_lp>=_new_lp AND skr_lp<pl1.skr_lp ;
  ELSE
    UPDATE tr_strukturakonstrukcyjnarel SET skr_lp=skr_lp-1 WHERE sk_idstrukturyp=pl1.sk_idstrukturyp AND skr_lp<=_new_lp AND skr_lp>pl1.skr_lp ;
  END IF;
  
  UPDATE tr_strukturakonstrukcyjnarel SET skr_lp=_new_lp WHERE skr_idrelacji=_skr_idrelacji;

  RETURN _skr_idrelacji;
END;
$_$;
