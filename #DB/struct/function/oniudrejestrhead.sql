CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 miesiac_ksiegowania TEXT;
 flaga INT;
BEGIN
  IF (TG_OP = 'UPDATE') THEN
   IF (NEW.tr_idtrans <> OLD.tr_idtrans) THEN
      RAISE EXCEPTION 'Nie mozna zmienic transakcji w rejestrze';
    END IF;
  END IF;

  IF (TG_OP = 'INSERT') THEN
    flaga=16;
    IF (NEW.rh_skojlog>0) THEN 
    ---zapis skojarzony z innym uaktualniamy flage na pierwszym o skojarzeniu
       UPDATE kh_rejestrhead SET rh_flaga=rh_flaga|4096 WHERE rh_idrejestru=NEW.rh_skojlog;
    END IF;

    UPDATE tg_transakcje SET tr_flaga=tr_flaga|flaga WHERE tr_idtrans=NEW.tr_idtrans;
    IF (NEW.rh_flaga&2048 = 2048) THEN
      IF (NEW.mn_miesiac =NULL) THEN
        miesiac_ksiegowania=date_part('year', NEW.rh_dataoperacji)||UzupelnijMiesiac(date_part('month',NEW.rh_dataoperacji)) ;
        NEW.mn_miesiac=miesiac_ksiegowania::int;
      END IF;
    END IF;
    ---bierzemy nowy numer
      NEW.rh_pozycja=max((SELECT 1+max(rh_pozycja) FROM kh_rejestrhead WHERE nr_idnazwy=NEW.nr_idnazwy AND mn_miesiac=NEW.mn_miesiac),1);
    
    RETURN NEW;
  END IF;
  IF (TG_OP = 'DELETE') THEN
    flaga=16;
    IF (OLD.rh_skojlog>0) THEN 
       ---zapis skojarzony z innym uaktualniamy flage na pierwszym o skojarzeniu
       ---usuwamy zapis orginalny
       DELETE FROM  kh_rejestrhead WHERE rh_idrejestru=OLD.rh_skojlog;
    ELSE
       UPDATE tg_transakcje SET tr_flaga=tr_flaga&(~16) WHERE tr_idtrans=OLD.tr_idtrans;
    END IF;
    
    RETURN OLD;
  END IF;
  RETURN NEW;
END;$$;
