CREATE FUNCTION oniudzapisykpir() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 miesiac_ksiegowania TEXT;
 miesiecznanumeracja TEXT;
 nazwaustawienia TEXT;
BEGIN
  IF (TG_OP = 'UPDATE') THEN
    IF (NEW.kp_flaga&4=4) THEN
      DELETE FROM kh_konwersjakpir  WHERE kp_idzapisu=NEW.kp_idzapisu;
    END IF;
  END IF;

  IF (TG_OP = 'INSERT') THEN
    IF (NEW.mn_miesiac =NULL) THEN
      miesiac_ksiegowania=date_part('year', NEW.kp_dataop)||UzupelnijMiesiac(date_part('month',NEW.kp_dataop)) ;
      NEW.mn_miesiac=miesiac_ksiegowania::int;
    END IF;
    ---pobieram numur kolejny 
    nazwaustawienia='ksiegakpmies';
    miesiecznanumeracja=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela=nazwaustawienia);
    IF (miesiecznanumeracja='1') THEN
     NEW.kp_pozycja=max((SELECT 1+max(kp_pozycja) FROM kh_zapisykpir WHERE mn_miesiac=NEW.mn_miesiac),1);
    ELSE
     NEW.kp_pozycja=max((SELECT 1+max(kp_pozycja) FROM kh_zapisykpir WHERE ro_idroku=NEW.ro_idroku),1);
    END IF;

    RETURN NEW;
  END IF;

  IF (TG_OP = 'DELETE') THEN
    DELETE FROM kh_konwersjakpir  WHERE kp_idzapisu=OLD.kp_idzapisu;
    RETURN OLD;
  END IF;
 
  RETURN NEW;
END;$$;
