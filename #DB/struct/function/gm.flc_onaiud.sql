CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 flag INT:=0;
 mask INT:=0;
 ------
 fcb gm.tm_flagcounterbase;
 cnt INT;
BEGIN

 IF (TG_OP='DELETE') THEN
  fcb=OLD::gm.tm_flagcounterbase;
  cnt=0;   --- Dla delete zachowuj sie tak jakby counter byl rowny 0
 ELSE
  fcb=NEW::gm.tm_flagcounterbase;
  cnt=NEW.flc_counter;
 END IF;
 
 -----------------------------------------------------------------------------------------------------------------------------------------------------------------
 IF (fcb.flc_type='MRPP_HASPOZYCJAMAG') THEN
  mask=(1<<3); ---3:	   paleta posiada pozycje magazynowe (isPZet OR isAPZet)
  flag=(CASE WHEN cnt=0 THEN 0 ELSE mask END); 
 END IF;
 IF (fcb.flc_type='MRPP_HASPOZYCJAPROD') THEN
  mask=(1<<4); ---4:     paleta posiada pozycje produkcyjne (tr_dyspozycjamag.mrpp_idpalety)
  flag=(CASE WHEN cnt=0 THEN 0 ELSE mask END); 
 END IF;
 IF (fcb.flc_type='MRPP_HASAPZ') THEN
  mask=(1<<6); ---6:     paleta posiada APZety (isAPZet)
  flag=(CASE WHEN cnt=0 THEN 0 ELSE mask END); 
 END IF;
 IF (fcb.flc_type='MRPP_HASNIEWYDANYPZ') THEN
  mask=(1<<7); ---7:     paleta posiada ruchy niewydane (isPZet && rc_iloscpoz>0)
  flag=(CASE WHEN cnt=0 THEN 0 ELSE mask END); 
 END IF;
 -----------------------------------------------------------------------------------------------------------------------------------------------------------------
  
 IF (TG_OP='DELETE') THEN
  ---------------------MRP Palety
  IF (mask!=0) AND (OLD.mrpp_idpalety_to IS NOT NULL) THEN
   UPDATE tr_mrppalety SET mrpp_flaga=(mrpp_flaga&(~mask))|flag WHERE mrpp_idpalety=OLD.mrpp_idpalety_to AND (mrpp_flaga&mask)!=flag;
  END IF;
  ---------------------
 ELSE
  ---------------------MRP Palety
  IF (mask!=0) AND (NEW.mrpp_idpalety_to IS NOT NULL) THEN
   UPDATE tr_mrppalety SET mrpp_flaga=(mrpp_flaga&(~mask))|flag WHERE mrpp_idpalety=NEW.mrpp_idpalety_to AND (mrpp_flaga&mask)!=flag;
  END IF;
  --------------------- 
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;
 
 RETURN NEW;
 END;
$$;
