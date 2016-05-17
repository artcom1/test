CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _sk_idstrukturyp ALIAS FOR $1;
 _skr_idrelacji ALIAS FOR $2;
 _lp INT;
BEGIN 

 _lp=(SELECT COALESCE(max(skr_lp+1),1) FROM tr_strukturakonstrukcyjnarel WHERE sk_idstrukturyp=_sk_idstrukturyp);
   
 UPDATE tr_strukturakonstrukcyjnarel SET sk_idstrukturyp=_sk_idstrukturyp, skr_lp=_lp WHERE skr_idrelacji=_skr_idrelacji AND sk_idstrukturyp<>_sk_idstrukturyp;
    
 RETURN 1;
END;
$_$;
