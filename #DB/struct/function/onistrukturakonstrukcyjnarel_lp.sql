CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
 NEW.skr_lp=(SELECT 1+NullZero(max(skr_lp)) FROM tr_strukturakonstrukcyjnarel as sk WHERE sk.sk_idstrukturyp=NEW.sk_idstrukturyp);

 RETURN NEW;
END;
$$;
