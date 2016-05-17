CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 roznica INTERVAL;
 rbh     NUMERIC:=0;
BEGIN

 ----------------------------------------------------------------------------
 ---Podpiecie pracy rowniez pod zlecenia
 ----------------------------------------------------------------------------
 IF (TG_OP='INSERT') THEN
 ---uaktualniamy zlecenie wedlug podpiecia do jakiego bytu sa prace
  IF (NEW.pra_typeref=32) THEN  ---zlecenia
   NEW.zl_idzlecenia=NEW.pra_idref;
  END IF;
  IF (NEW.pra_typeref=56) THEN  ---plan zlecenia
   NEW.zl_idzlecenia=(SELECT zl_idzlecenia FROM tg_planzlecenia WHERE pz_idplanu=NEW.pra_idref);
  END IF;
  IF (NEW.pra_typeref=206) THEN  ---zdarzenia
   NEW.zl_idzlecenia=(SELECT zl_idzlecenia FROM tb_zdarzenia WHERE zd_idzdarzenia=NEW.pra_idref);
  END IF;
  IF (NEW.pra_typeref=132) THEN   ---prace albertowe (wypaly)
   NEW.zl_idzlecenia=(SELECT zl_idzlecenia FROM tp_wypal JOIN tp_kkwelem USING (kwe_idelemu) JOIN tp_kkwhead USING (kwh_idheadu) WHERE wp_idwypalu=NEW.pra_idref);
  END IF;
  IF (NEW.pra_typeref=156) THEN  ---wykonanie produkcji MRP
   NEW.zl_idzlecenia=(SELECT zl_idzlecenia FROM tr_kkwnodwykdet JOIN tr_kkwhead USING (kwh_idheadu) WHERE kwd_idelemu=NEW.pra_idref);
  END IF;

  IF (NEW.zl_idzlecenia<=0) THEN
    NEW.zl_idzlecenia=NULL;
  END IF;
 END IF;
 
  IF (TG_OP='UPDATE') THEN
  --- zl_idzlecenia moge zmieniac tylko wtedy, kiedy wczesniej mialem podpiecie do zlecenia lub nie mialem zadnego podpiecia
  IF (NEW.pra_typeref=32 AND (OLD.pra_typeref=32 OR OLD.pra_typeref=NULL)) THEN
   NEW.zl_idzlecenia=NEW.pra_idref;   
  END IF;
 END IF;

 ------------------------------------------------------------------------------
 ---wyliczenie rbh na podstawie dat jesli rejestracja start-stop
 ------------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  IF (NEW.pra_flaga&1=1) THEN
   IF (NEW.pra_flaga&2=2) THEN
    roznica=NEW.pra_datastop-NEW.pra_datastart;
    rbh=date_part('days',roznica)*24+date_part('hours',roznica)+date_part('minute',roznica)/60;
    rbh=round(rbh,2);
    NEW.pra_rbh=rbh;
   ELSE
    NEW.pra_rbh=0;
   END IF;
  END IF;
 END IF;

 ----------------------------------------------------------------------------
 ---wyliczenie kosztu
 ----------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  IF ((NEW.pra_flaga&8)=0) THEN ---prace nie pochodzace z mrp
   IF ((NEW.pra_flaga&4)=4) THEN ---koszt wedlug ilosci
    NEW.pra_koszt=Round(NEW.pra_ilosc*NEW.pra_cenajedn,2);
    NEW.pra_kosztnetto=Round(NEW.pra_ilosc*NEW.pra_cenajednnetto,2);
   END IF;
   IF ((NEW.pra_flaga&4)=0) THEN ---koszt wedlug rbh
    NEW.pra_koszt=Round(NEW.pra_rbh*NEW.pra_cenajedn,2);
    NEW.pra_kosztnetto=Round(NEW.pra_rbh*NEW.pra_cenajednnetto,2);
   END IF;
   IF ((NEW.pra_flaga&16)=16) THEN ---to jest premia
    NEW.pra_koszt=Round(NEW.pra_cenajedn,2);
    NEW.pra_kosztnetto=Round(NEW.pra_cenajednnetto,2);
   END IF;   
  END IF;
 END IF;

 ----------------------------------------------------------------------------
 ----naliczanie kosztow oraz rbh do zlecen
 ----------------------------------------------------------------------------
 IF (TG_OP<>'INSERT') THEN
  IF (OLD.zl_idzlecenia>0) THEN
   ---wycofujemy uaktualnienie dla starego zlecenia podpietego do pracy
   UPDATE tg_zlecenia SET zl_robocizna=zl_robocizna-NullZero(OLD.pra_koszt),zl_robociznanetto=zl_robociznanetto-NullZero(OLD.pra_kosztnetto),zl_pracerbh=zl_pracerbh-NullZero(round(OLD.pra_rbh,2)) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
  END IF;
 END IF;
 IF (TG_OP<>'DELETE') THEN
  IF (NEW.zl_idzlecenia>0) THEN
   ---dodajemy uaktualnienie dla nowego zlecenia podpietego do pracy
   UPDATE tg_zlecenia SET zl_robocizna=zl_robocizna+NullZero(NEW.pra_koszt),zl_robociznanetto=zl_robociznanetto+NullZero(NEW.pra_kosztnetto),zl_pracerbh=zl_pracerbh+NullZero(round(NEW.pra_rbh,2)) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
