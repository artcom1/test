CREATE FUNCTION ptowar_onaiudtranselem() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 ---- Delta ilosci (na towmagu)
 dilosci v.delta ;
 ---- Delta wartosci (na towmagu)
 dwartosci v.delta ;
 ---- Delta ilosci rezerwowanej
 drezerwacji v.delta ;
BEGIN

 IF (TG_OP!='INSERT') THEN
  IF (TEisPseudoTowar(OLD.tel_new2flaga)) THEN      ---- Pseudotowar
   dilosci.id_old=OLD.ttm_idtowmag;
   dwartosci.id_old=OLD.ttm_idtowmag;
   drezerwacji.id_old=OLD.ttm_idtowmag;
   ----------------------------------------------------------------------------------------------------------------
   IF (TEisOpMagazyn(OLD.tel_newflaga) AND (OLD.tel_sprzedaz!=0)) THEN     ---- Operacja magazynowa i niezerowa sprzedaz
    dilosci.value_old=(OLD.tel_sprzedaz*OLD.tel_iloscf);
	dwartosci.value_old=(OLD.tel_sprzedaz*(OLD.tel_wartosczakupu+OLD.tel_narzut));
   ELSIF (TEisOpHandel(OLD.tel_newflaga) AND (OLD.tel_sprzedaz<0)) THEN   ---- Operacja handlowa i ujemna sprzedaz
    drezerwacji.value_old=-OLD.tel_iloscwyd;
   END IF;
   
  END IF;
 END IF;

 IF (TG_OP!='DELETE') THEN
  IF (TEisPseudoTowar(NEW.tel_new2flaga)) THEN      ---- Pseudotowar
   dilosci.id_new=NEW.ttm_idtowmag;
   dwartosci.id_new=NEW.ttm_idtowmag;
   drezerwacji.id_new=NEW.ttm_idtowmag;
   ----------------------------------------------------------------------------------------------------------------
   IF (TEisOpMagazyn(NEW.tel_newflaga) AND (NEW.tel_sprzedaz!=0)) THEN     ---- Operacja magazynowa i niezerowa sprzedaz
    dilosci.value_new=(NEW.tel_sprzedaz*NEW.tel_iloscf);
	dwartosci.value_new=(NEW.tel_sprzedaz*(NEW.tel_wartosczakupu+NEW.tel_narzut));
   ELSIF (TEisOpHandel(NEW.tel_newflaga) AND (NEW.tel_sprzedaz<0)) THEN   ---- Operacja handlowa i ujemna sprzedaz
    drezerwacji.value_new=-NEW.tel_iloscwyd;
   END IF;
   
  END IF;
 END IF;
 
 IF (v.deltavalueold(dilosci)!=0 OR v.deltavalueold(dwartosci)!=0 OR v.deltavalueold(drezerwacji)!=0) THEN
  UPDATE tg_towmag SET
         ttm_stan=ttm_stan-v.deltavalueold(dilosci),
		 ttm_wartosc=ttm_wartosc-v.deltavalueold(dwartosci),
		 ttm_rezerwacja=ttm_rezerwacja-v.deltavalueold(drezerwacji)
  WHERE ttm_idtowmag=dilosci.id_old;
 END IF;
 IF (v.deltavaluenew(dilosci)!=0 OR v.deltavaluenew(dwartosci)!=0 OR v.deltavaluenew(drezerwacji)!=0) THEN
  UPDATE tg_towmag SET
         ttm_stan=ttm_stan+v.deltavaluenew(dilosci),
		 ttm_wartosc=ttm_wartosc+v.deltavaluenew(dwartosci),
		 ttm_rezerwacja=ttm_rezerwacja+v.deltavaluenew(drezerwacji)
  WHERE ttm_idtowmag=dilosci.id_new;
 END IF;
 
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 RETURN NEW;
END;
$$;
