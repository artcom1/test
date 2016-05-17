CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
 NEW.rd_kwota := NEW.rd_ilosc*NEW.rd_cena; 
 NEW.rd_kwotapln := round(NEW.rd_ilosc*NEW.rd_cena*NEW.rd_kurswaluty,2);
END IF;

IF (TG_OP='DELETE') THEN
RETURN OLD;
ELSE
RETURN NEW;
END IF;
END;
$$;
