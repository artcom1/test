CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 ----------------------------------------------------------------------------
 ---Podpiecie przejazdu rowniez pod zlecenia
 ----------------------------------------------------------------------------
 IF (TG_OP='INSERT') THEN
  IF (NEW.zl_idzlecenia<=0) THEN
    NEW.zl_idzlecenia=NULL;
  END IF;
 END IF;
 
 ----------------------------------------------------------------------------
 ----naliczanie kosztow oraz rbh do zlecen
 ----------------------------------------------------------------------------
 IF (TG_OP<>'INSERT') THEN
  IF (OLD.zl_idzlecenia>0) THEN
   ---wycofujemy uaktualnienie dla starego zlecenia podpietego do przejazdu
   UPDATE tg_zlecenia SET zl_przejazdynto=zl_przejazdynto-NullZero(OLD.pr_kosztnetto), zl_przejazdybto=zl_przejazdybto-NullZero(OLD.pr_kosztbrutto) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
  END IF;
 END IF;
 IF (TG_OP<>'DELETE') THEN
  IF (NEW.zl_idzlecenia>0) THEN
   ---dodajemy uaktualnienie dla nowego zlecenia podpietego do pracy
   UPDATE tg_zlecenia SET zl_przejazdynto=zl_przejazdynto+NullZero(NEW.pr_kosztnetto), zl_przejazdybto=zl_przejazdybto+NullZero(NEW.pr_kosztbrutto) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
