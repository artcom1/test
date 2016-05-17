CREATE FUNCTION onuklientkh() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 UPDATE kh_konta SET kt_numer=NEW.k_kod WHERE k_idklienta=NEW.k_idklienta AND ((kt_zerosto&(1<<9))!=0);

 RETURN NEW;
 END;
$$;
