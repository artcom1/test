CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 dnetto NUMERIC:=0;
 dbrutto NUMERIC:=0;
 dvat NUMERIC:=0;
 stawka INT:=0;
 
BEGIN

 IF (TG_OP <> 'INSERT') THEN
   dnetto=-OLD.rve_netto;
   dbrutto=-OLD.rve_brutto;
   dvat=-OLD.rve_vat;
 END IF;

 IF (TG_OP ='DELETE') THEN
  UPDATE  kh_rejestrhead SET rh_brutto=rh_brutto+dbrutto, rh_vat=rh_vat+dvat, rh_netto=rh_netto+dnetto WHERE rh_idrejestru=OLD.rh_idrejestru;   
  dnetto=0;
  dbrutto=0;
  dvat=0;
 END IF;
 
 IF (TG_OP <>'DELETE') THEN
/*  IF (NEW.rve_flaga&1) THEN
    NEW.rve_netto=round(NEW.rve_brutto/(100+nullZero(NEW.rve_stawka))*100,2);
    NEW.rve_vat=round(NEW.rve_brutto-NEW.rve_netto,2);
  ELSE
    NEW.rve_vat=round(NEW.rve_netto*nullZero(NEW.rve_stawka)/100,2);
    NEW.rve_brutto=NEW.rve_netto+NEW.rve_vat;
  END IF;
 */
  dnetto=dnetto+NEW.rve_netto;
  dbrutto=dbrutto+NEW.rve_brutto;
  dvat=dvat+NEW.rve_vat;
  IF (dnetto <> '0' OR dbrutto <> '0' OR dvat <> '0') THEN

    UPDATE  kh_rejestrhead SET rh_brutto=dbrutto+rh_brutto, rh_vat=rh_vat+dvat, rh_netto=rh_netto+dnetto WHERE rh_idrejestru=NEW.rh_idrejestru;   
  END IF;
 END IF;
 
 IF (TG_OP <> 'DELETE') THEN
   return NEW;
 ELSE
   return OLD;
 END IF ;
 RETURN OLD;
END;$$;
