CREATE FUNCTION zmienlpstrukturykonstrukcyjnej(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _skr_idrelacji ALIAS FOR $1;
 typ ALIAS FOR $2;
 pl RECORD;
 pl2 RECORD;

BEGIN
  SELECT skr_idrelacji, skr_lp, sk_idstrukturyp INTO pl FROM tr_strukturakonstrukcyjnarel WHERE skr_idrelacji=_skr_idrelacji;
  
  IF (typ) THEN
   SELECT skr_idrelacji, skr_lp INTO pl2 FROM tr_strukturakonstrukcyjnarel WHERE sk_idstrukturyp=pl.sk_idstrukturyp AND skr_lp<pl.skr_lp AND skr_lp>0  ORDER BY skr_lp DESC LIMIT 1 OFFSET 0;
  ELSE
   SELECT skr_idrelacji, skr_lp INTO pl2 FROM tr_strukturakonstrukcyjnarel WHERE sk_idstrukturyp=pl.sk_idstrukturyp AND skr_lp>pl.skr_lp AND skr_lp>0  ORDER BY skr_lp ASC LIMIT 1 OFFSET 0;
  END IF;
  
    
  UPDATE tr_strukturakonstrukcyjnarel SET skr_lp=pl2.skr_lp WHERE skr_idrelacji=pl.skr_idrelacji;
  UPDATE tr_strukturakonstrukcyjnarel SET skr_lp=pl.skr_lp WHERE skr_idrelacji=pl2.skr_idrelacji;

  return pl2.skr_idrelacji;

END;
$_$;
