CREATE FUNCTION onaiudplanzlecenia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 synchro_daty INT:=0;
BEGIN
 IF (TG_OP='UPDATE') THEN
  IF (NEW.pz_flaga&16!=0 AND NEW.pz_flaga&(1<<18)=(1<<18)) THEN
   --jestem ojciem, jak zmienily sie jakies dane ktore przekazuje do dzieci to musze je uaktualnic
   IF (NEW.pz_ilosc!=OLD.pz_ilosc OR 
       NEW.pz_ilosczreal!=OLD.pz_ilosczreal OR 
   NEW.pz_iloscroz!=OLD.pz_iloscroz OR 
   NEW.pz_termin!=OLD.pz_termin OR
   (NEW.pz_flaga&(2+1024))!=(OLD.pz_flaga&(2+1024)) OR ---wykonanie planu   
   (NEW.pz_flaga&(3<<24))!=(OLD.pz_flaga&(3<<24)) OR --- oznaczenie planu
   (NEW.pz_flaga&(1<<26))!=(OLD.pz_flaga&(1<<26)) OR --- obecnosc w galezi zakupowej
   (NEW.pz_flaga&(1<<30))!=(OLD.pz_flaga&(1<<30))    --- obecnosc w galezi kooperacji
      ) THEN
  
    UPDATE tg_planzlecenia SET 
pz_idroot=COALESCE(NEW.pz_idroot,NEW.pz_idplanu), 
pz_iloscojciec=NEW.pz_ilosc, 
pz_iloscojciecwyk=NEW.pz_ilosczreal, 
pz_iloscojciecplan=NEW.pz_iloscroz,  
pz_dataojca=NEW.pz_termin, 
pz_flaga=ustalFlagePlanu(pz_flaga,NEW.pz_flaga&(2+1024),NEW.pz_flaga&((1<<24)+(1<<25)), NEW.pz_flaga&(1<<26), NEW.pz_flaga&(1<<30))  
WHERE pz_idref=NEW.pz_idplanu;

   END IF;
  END IF; 
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (NEW.pz_flaga&(1<<12)<>0) THEN
   PERFORM bisserwis.syncPlanZleceniaWZ(NEW.pz_idplanu,NEW.ttw_idtowaru,NEW.pz_ilosc,NEW.pz_datado);
  END IF;
 END IF;
 
 -- Pod zlecenia otwarte
 IF (TG_OP<>'DELETE') THEN
  IF ((NEW.pz_newflaga&(1<<0))=(1<<0)) THEN
   INSERT INTO tg_towaryzlecotwartego(zl_idzlecenia,ttw_idtowaru) 
   SELECT NEW.zl_idzlecenia, NEW.ttw_idtowaru 
   WHERE NOT EXISTS 
   (
    SELECT tzt_idtowaruzlec FROM tg_towaryzlecotwartego WHERE zl_idzlecenia=NEW.zl_idzlecenia AND ttw_idtowaru=NEW.ttw_idtowaru
   ); 
  END IF;
 END IF; 
 -- Pod zlecenia otwarte
 
 -- Pod synchronizacje dat
 IF (TG_OP='INSERT' OR TG_OP='DELETE') THEN
  synchro_daty=1;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  IF (
      NEW.pz_idref<>OLD.pz_idref OR
      NEW.pz_dataod<>OLD.pz_dataod OR
	  NEW.pz_datado<>OLD.pz_datado
	 ) THEN
   synchro_daty=1;
  END IF;
 END IF;
 
 IF (synchro_daty=1) THEN
  synchro_daty=(SELECT COALESCE(cf_defvalue::int,0) FROM tc_config WHERE cf_tabela='mrp_plan_synchro_dzieci'); -- Sprawdzam ustawienia programu
 END IF;
 
 IF (synchro_daty=1) THEN
  IF (TG_OP='INSERT') THEN
   PERFORM aktualizujDatyPlanu(1,NEW.pz_idref);  
  END IF;  
  
  IF (TG_OP='UPDATE') THEN
   IF (NEW.pz_idref<>OLD.pz_idref) THEN
    PERFORM aktualizujDatyPlanu(1,OLD.pz_idref);
	PERFORM aktualizujDatyPlanu(1,NEW.pz_idref);
   ELSE
    PERFORM aktualizujDatyPlanu(1,NEW.pz_idref);
   END IF;   
  END IF;
  
  IF (TG_OP='DELETE') THEN
   PERFORM aktualizujDatyPlanu(1,OLD.pz_idref);
  END IF;
  
 END IF;
 -- Pod synchronizacje dat
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;$$;
