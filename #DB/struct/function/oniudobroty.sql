CREATE FUNCTION oniudobroty() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

/*
 ---Faza OLD
 IF (TG_OP<>'INSERT') THEN
  deltawn=deltawn-OLD.ob_wn;
  deltama=deltama-OLD.ob_ma;
 END IF;
 */

 IF (TG_OP='INSERT') THEN
  NEW.kt_ref=(SELECT kt_idkonta FROM kh_obroty WHERE ob_id=NEW.ob_ref);
  NEW.ob_poziom=COALESCE((SELECT ob_poziom FROM kh_obroty WHERE ob_id=NEW.ob_ref),-1)+1;
 END IF;

/*
 ---Faza NEW
 IF (TG_OP<>'DELETE') THEN
  deltawn=deltawn+NEW.ob_wn;
  deltama=deltama+NEW.ob_ma;
 END IF;

 --Faza obliczania wartosci posrednich
 IF (TG_OP<>'DELETE') THEN
  NEW.ob_sumwn=NEW.ob_sumwn+deltawn;
  NEW.ob_summa=NEW.ob_summa+deltama;
 END IF;

 --Zrob update wartosci narastajacych
 IF ((deltawn<>0) OR (deltama<>0)) THEN
  IF (TG_OP='DELETE') THEN
   UPDATE kh_obroty SET ob_sumwn=ob_sumwn+deltawn,ob_summa=ob_summa+deltama WHERE ro_idroku=OLD.ro_idroku AND mn_miesiac>OLD.mn_miesiac AND kt_idkonta=OLD.kt_idkonta;
  ELSE
   UPDATE kh_obroty SET ob_sumwn=ob_sumwn+deltawn,ob_summa=ob_summa+deltama WHERE ro_idroku=NEW.ro_idroku AND mn_miesiac>NEW.mn_miesiac AND kt_idkonta=NEW.kt_idkonta;
  END IF;
 END IF;
*/
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
