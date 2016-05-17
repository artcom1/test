CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='INSERT') THEN
  NEW.th_idtechnologii=(SELECT th_idtechnologii FROM tr_technoelem WHERE the_idelem=NEW.the_idelem);

  IF (nullZero((SELECT count(*) FROM tr_technostpracy WHERE tsp_flaga&2=2 AND tsp_flaga&4=NEW.tsp_flaga&4 AND the_idelem=NEW.the_idelem AND tsp_idstanowiska<>NEW.tsp_idstanowiska))=0) THEN
   NEW.tsp_flaga=NEW.tsp_flaga|2;
  END IF;

 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (NEW.tsp_flaga&4=0) THEN
   ---przeliczamy na planach niewykonanych czas wedlug normy
   UPDATE tr_kkwnodplan SET 
    knp_flaga=knp_flaga|16384, 
    knp_czasnormapozostalo=getSzacowanyCzasPracyNetto(knp_iloscplanowana-knp_iloscwykonana,ob_idobiektu, kwe_idelemu) 
   WHERE ob_idobiektu=NEW.ob_idobiektu AND 
        (knp_flaga&(1|2|16)=0) AND knp_iloscplanowana-knp_iloscwykonana>0 AND 
	kwe_idelemu IN (SELECT kwe_idelemu FROM tr_kkwnod WHERE the_idelem=NEW.the_idelem);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;$$;
