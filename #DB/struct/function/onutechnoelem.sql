CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (OLD.the_tpz<>NEW.the_tpz OR 
     OLD.the_tpj<>NEW.the_tpj OR 
     OLD.the_iloscosob<>NEW.the_iloscosob OR
     OLD.the_wydajnosc<>NEW.the_wydajnosc OR 
     OLD.the_kosztnah<>NEW.the_kosztnah OR 
     OLD.the_kosztnaj<>NEW.the_kosztnaj OR 
     OLD.the_kosztkooperacji<>NEW.the_kosztkooperacji
    ) THEN
 
  ---przeliczamy na planach niewykonanych czas wedlug normy 
---  UPDATE tr_kkwnodplan SET 
---      knp_flaga=knp_flaga|16384, 
---	 knp_czasnormapozostalo=getSzacowanyCzasPracyNetto(knp_iloscplanowana-knp_iloscwykonana,sp_idstanowiska, kwe_idelemu) 
---	 WHERE kwe_idelemu IN (SELECT kwe_idelemu FROM tr_kkwnod WHERE the_idelem=NEW.the_idelem) AND 
---            knp_flaga&(1|2|16)=0 AND knp_iloscplanowana-knp_iloscwykonana>0 AND 
---	       sp_idstanowiska NOT IN (SELECT sp_idstanowiska FROM tr_technostpracy WHERE tsp_flaga&(1+4)=1 AND the_idelem=NEW.the_idelem);

  ---przeliczamy normy na stanowiskach zaleznych od normy z naglowka
  UPDATE tr_technostpracy SET 
         tsp_tpz=NEW.the_tpz,
	 tsp_tpj=NEW.the_tpj,
	 tsp_iloscosob=NEW.the_iloscosob,
	 tsp_wydajnosc=NEW.the_wydajnosc,
	 tsp_kosztnah=NEW.the_kosztnah,
	 tsp_kosztnaj=NEW.the_kosztnaj, 
	 tsp_kosztkooperacji=NEW.the_kosztkooperacji 
	 WHERE the_idelem=NEW.the_idelem AND tsp_flaga&1=1;

 END IF;

 RETURN NEW;

END;
$$;
