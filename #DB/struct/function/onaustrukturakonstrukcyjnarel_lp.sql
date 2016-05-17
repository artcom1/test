CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
 
 IF (NEW.sk_idstrukturyp<>OLD.sk_idstrukturyp) THEN
  UPDATE tr_strukturakonstrukcyjnarel AS sk SET skr_lp=skr_lp-1 WHERE sk.sk_idstrukturyp=OLD.sk_idstrukturyp AND sk.skr_lp>OLD.skr_lp;
 END IF;

 RETURN NEW;
END;
$$;
