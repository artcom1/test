CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 p tg_partie;
 idnew INT;
BEGIN

 IF (TG_OP!='DELETE') THEN   
  IF (TG_OP='INSERT') AND (NEW.phe_ref IS NULL) THEN
   ------Sproboj przekonwertowac nadindeks do podindeksu jesli sposob pakowania jest jednostkowy
   /*
   IF (NEW.phe_wplyw>0) THEN
    idnew=gmr.tryCovertNDXtoPDX(NEW.ttw_idtowarundx,NEW.rmp_idsposobu);
    IF (idnew IS DISTINCT FROM NEW.ttw_idtowarundx) THEN
     NEW.ttw_idtowaru=idnew;
	 NEW.rmp_idsposobu=NULL;
    END IF;
   END IF; 
   */
   ---Zachowaj partie REF
   NEW.prt_idpartiiplusnosspak_fromref=NEW.prt_idpartiiplus_nosppak;
   ---Skopiuj mnoznik
   NEW.phe_mnoznik=COALESCE((SELECT sum(rmk_przelicznik) FROM tg_rozmsppakelems WHERE rmp_idsposobu=NEW.rmp_idsposobu),1);
  END IF;
  IF (TG_OP='UPDATE') AND (NEW.phe_ref IS NULL) THEN
   NEW.prt_idpartiiplusnosspak_fromref=NEW.prt_idpartiiplus_nosppak;
   ------Sproboj przekonwertowac nadindeks do podindeksu jesli sposob pakowania jest jednostkowy
   IF (NEW.rmp_idsposobu IS DISTINCT FROM OLD.rmp_idsposobu) THEN
   /*
    IF (NEW.phe_wplyw>0) THEN
     idnew=gmr.tryCovertNDXtoPDX(NEW.ttw_idtowarundx,NEW.rmp_idsposobu);
     IF (idnew IS DISTINCT FROM NEW.ttw_idtowarundx) THEN
      NEW.ttw_idtowaru=idnew;
	  NEW.rmp_idsposobu=NULL;
     END IF;
    END IF; 
	*/
	---Skopiuj mnoznik
    NEW.phe_mnoznik=COALESCE((SELECT sum(rmk_przelicznik) FROM tg_rozmsppakelems WHERE rmp_idsposobu=NEW.rmp_idsposobu),1);
   END IF;
  END IF;
  IF (NEW.phe_ref IS NULL) AND (NEW.prt_idpartiiplus_nosppak IS NULL) THEN
   SELECT * INTO p FROM tg_partie WHERE prt_idpartii=NEW.prt_idpartiiplus;
   p.rmp_idsposobu=NULL;
   NEW.prt_idpartiiplus_nosppak=(gmr.findOrCreatePartiaLikeOther(p,p.ttw_idtowaru,true)).prt_idpartii;
   NEW.prt_idpartiiplusnosspak_fromref=NEW.prt_idpartiiplus_nosppak;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
END;
$$;
