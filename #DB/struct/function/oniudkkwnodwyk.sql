CREATE FUNCTION oniudkkwnodwyk() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 delta_zarejestr_new NUMERIC:=0;
 delta_zarejestr_old NUMERIC:=0;

 delta_zarejestr_brak_new NUMERIC:=0;
 delta_zarejestr_brak_old NUMERIC:=0;
 
 delta_wyk_new NUMERIC:=0;
 delta_wyk_old NUMERIC:=0;

 delta_brak_new NUMERIC:=0;
 delta_brak_old NUMERIC:=0;

 delta_plan_new NUMERIC:=0;
 delta_plan_old NUMERIC:=0;

 delta_mag_new NUMERIC:=0;
 delta_mag_old NUMERIC:=0;
 delta_magc_new NUMERIC:=0;
 delta_magc_old NUMERIC:=0;

 delta_rbh_kubelek_old NUMERIC:=0;
 delta_rbh_kubelek_new NUMERIC:=0;
 czasnorma NUMERIC:=0;
 tmp NUMERIC:=0;
 
 przeliczenieczasuefektywnego BOOLEAN:=FALSE;
 
BEGIN
 -- Dla tych bez kontroli przepisuje wartosci
 IF (TG_OP<>'DELETE') THEN
  IF (NEW.knw_flaga&(1<<5)=0) THEN -- Nie wymaga kontroli
   NEW.knw_iloscskontrolowana=NEW.knw_iloscwyk;
   NEW.knw_iloscskontrolowanabraki=NEW.knw_iloscbrakow;
  END IF;
 END IF;

 IF (TG_OP<>'INSERT') THEN
  IF (OLD.knw_flaga&(1<<5)=0) THEN -- Nie wymaga kontroli
   OLD.knw_iloscskontrolowana=OLD.knw_iloscwyk;
   OLD.knw_iloscskontrolowanabraki=OLD.knw_iloscbrakow;
  END IF;
 END IF;
 -- Dla tych bez kontroli przepisuje wartosci
 
 IF (TG_OP='INSERT') THEN
  NEW.kwh_idheadu=(SELECT kwh_idheadu FROM tr_kkwnod WHERE kwe_idelemu=NEW.kwe_idelemu);
 END IF;

 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
  NEW.knw_wspkosztuprac=COALESCE((SELECT tsw_wspkosztuprac FROM ts_slownikwykonania WHERE tsw_idslownika=NEW.tsw_idslownika),1);
  IF ((NEW.knw_flaga&(1<<8))=0) THEN -- Mam synchronizacje zaangazowan
   NEW.knw_zaangazpracwykonanie=NEW.knw_zaangazpracownika;
  ELSE
    NEW.knw_zaangazpracwykonanie=(CASE WHEN getNormatywIlosciWyk(knw_wydajnosc, knw_tpj, knw_datastart::timestamp, knw_datawyk::timestamp)=0 THEN 0 ELSE knw_zaangazpracownika*knw_iloscwyk/getNormatywIlosciWyk(knw_wydajnosc, knw_tpj, knw_datastart::timestamp, knw_datawyk::timestamp) END);
  END IF;
 END IF;

 IF (TG_OP<>'INSERT') THEN
  delta_wyk_old=delta_wyk_old-OLD.knw_iloscskontrolowana;
  delta_zarejestr_old=delta_zarejestr_old-OLD.knw_iloscwyk;
  delta_brak_old=delta_brak_old-OLD.knw_iloscskontrolowanabraki;
  delta_zarejestr_brak_old=delta_zarejestr_brak_old-OLD.knw_iloscbrakow;
  delta_mag_old=delta_mag_old-OLD.knw_tomagmag;
  delta_magc_old=delta_magc_old-OLD.knw_tomagmagclosed;

  IF (OLD.knp_idplanu IS NULL) THEN
   delta_plan_old=delta_plan_old-OLD.knw_iloscskontrolowana;
  END IF;

  ---pod kubelki
  IF (OLD.knw_flaga&4=4) THEN
  ---plan kubelkowy
   ---pobieramy ilosc dla ktorej liczymy norme
   tmp=OLD.knw_iloscskontrolowana;
   IF (OLD.knw_flaga&8=8) THEN
    --wykonanie procentowe, musimy przeliczyc ilosc wedlug procentow
    tmp=Round(tmp*(SELECT kwe_iloscplanwyk FROM tr_kkwnod WHERE kwe_idelemu=OLD.kwe_idelemu)/100,4);
   END IF;
   czasnorma=Round((tmp*OLD.knw_tpj/OLD.knw_wydajnosc)+OLD.knw_tpz,0); ---wyliczamy czas norma dla starych wartosci w minutach
   delta_rbh_kubelek_old=delta_rbh_kubelek_old-(Round(czasnorma/60,2)); 
  END IF;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  ---wyliczamy czas wolny
  IF (NEW.knw_flaga&(1|2)=(1|2)) THEN ---zamkniete 
   NEW.knw_czaswolny=getfreetime(NEW.knw_datastart::timestamp, NEW.knw_datawyk::timestamp, NEW.ob_idobiektu,1);
   NEW.knw_czaswolny_np=getfreetime(NEW.knw_datastart::timestamp, NEW.knw_datawyk::timestamp, NEW.ob_idobiektu,2);
  ELSE 
   NEW.knw_czaswolny=0;
   NEW.knw_czaswolny_np=0;
  END IF;

  delta_wyk_new=delta_wyk_new+NEW.knw_iloscskontrolowana;
  delta_zarejestr_new=delta_zarejestr_new+NEW.knw_iloscwyk;
  
  delta_brak_new=delta_brak_new+NEW.knw_iloscskontrolowanabraki;
  delta_zarejestr_brak_new=delta_zarejestr_brak_new+NEW.knw_iloscbrakow;
  delta_mag_new=delta_mag_new+NEW.knw_tomagmag;
  delta_magc_new=delta_magc_new+NEW.knw_tomagmagclosed;

  IF (NEW.knp_idplanu IS NULL) THEN
   delta_plan_new=delta_plan_new+NEW.knw_iloscskontrolowana;
  END IF;

  ---pod kubelki
  IF (NEW.knw_flaga&4=4) THEN
  ---plan kubelkowy
   tmp=NEW.knw_iloscskontrolowana;
   IF (NEW.knw_flaga&8=8) THEN
    --wykonanie procentowe, musimy przeliczyc ilosc wedlug procentow
    tmp=Round(tmp*(SELECT kwe_iloscplanwyk FROM tr_kkwnod WHERE kwe_idelemu=NEW.kwe_idelemu)/100,4);
   END IF;
   czasnorma=Round((tmp*NEW.knw_tpj/NEW.knw_wydajnosc)+NEW.knw_tpz,0); ---wyliczamy czas norma dla starych wartosci w minutach
   delta_rbh_kubelek_new=delta_rbh_kubelek_new+(Round(czasnorma/60,2)); 
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.kwe_idelemu=OLD.kwe_idelemu) THEN
   delta_wyk_new=delta_wyk_new+delta_wyk_old;
   delta_wyk_old=0;
   delta_zarejestr_new=delta_zarejestr_new+delta_zarejestr_old;
   delta_zarejestr_old=0;
   delta_brak_new=delta_brak_new+delta_brak_old;
   delta_brak_old=0;
   delta_zarejestr_brak_new=delta_zarejestr_brak_new+delta_zarejestr_brak_old;
   delta_zarejestr_brak_old=0;
   delta_plan_new=delta_plan_new+delta_plan_old;
   delta_plan_old=0;
   delta_mag_new=delta_mag_new+delta_mag_old;
   delta_mag_old=0;
   delta_magc_new=delta_magc_new+delta_magc_old;
   delta_magc_old=0;
  END IF;
  ----jezeli zamykamy wykonanie to zamykamy pracownikow
  IF (NEW.knw_flaga&1=1) THEN
   UPDATE tr_kkwnodwykdet SET kwd_flaga=kwd_flaga|1, kwd_dataend=NEW.knw_datawyk WHERE kwd_flaga&1=0 AND knw_idelemu=NEW.knw_idelemu;
  END IF;

  ---pod kubelki
  IF (NEW.kb_idkubelka=OLD.kb_idkubelka AND NEW.knw_flaga&4=4 AND OLD.knw_flaga&4=4) THEN
   delta_rbh_kubelek_new=delta_rbh_kubelek_new+delta_rbh_kubelek_old;
   delta_rbh_kubelek_old=0;
  END IF;
 END IF;

 ----zmiany na kubelkach
 IF (delta_rbh_kubelek_new<>0 ) THEN
  UPDATE tr_kubelki SET kb_pojemnoscwyk=kb_pojemnoscwyk+delta_rbh_kubelek_new WHERE kb_idkubelka=NEW.kb_idkubelka;
 END IF;

 IF (delta_rbh_kubelek_old<>0 ) THEN
  UPDATE tr_kubelki SET kb_pojemnoscwyk=kb_pojemnoscwyk+delta_rbh_kubelek_old WHERE kb_idkubelka=OLD.kb_idkubelka;
 END IF;
 ----koniec zmiany na kubelkach

 IF (
     (delta_wyk_old<>0)       OR (delta_brak_old<>0) OR (delta_plan_old<>0) OR (delta_mag_old<>0) OR (delta_magc_old<>0) OR
 (delta_zarejestr_old<>0) OR (delta_zarejestr_brak_old<>0)
    ) THEN
 ---aktualizujemy nody i plany
  IF (OLD.knw_flaga&8=8) THEN
  ---wykonanie procentowe, aktualizumeny pole odnosnie wykonania procentowego
   UPDATE tr_kkwnod SET kwe_iloscwykprocent=kwe_iloscwykprocent+delta_wyk_old,
kwe_ilosczarejestrprocent=kwe_ilosczarejestrprocent+delta_zarejestr_old,   
kwe_iloscbrakow=kwe_iloscbrakow+delta_brak_old,
kwe_ilosczarejestrbraki=kwe_ilosczarejestrbraki+delta_zarejestr_brak_old,
kwe_iloscrozplanowanaprocent=kwe_iloscrozplanowanaprocent+delta_plan_old,
kwe_tomagmag=kwe_tomagmag+delta_mag_old,
kwe_tomagmagclosed=kwe_tomagmagclosed+delta_magc_old,
kwe_flaga=kwe_flaga|64
   WHERE kwe_idelemu=OLD.kwe_idelemu;
  ELSE ---wykonanie ilosciowe
   UPDATE tr_kkwnod SET kwe_iloscwyk=kwe_iloscwyk+delta_wyk_old,
kwe_ilosczarejestr=kwe_ilosczarejestr+delta_zarejestr_old,   
kwe_iloscbrakow=kwe_iloscbrakow+delta_brak_old,
kwe_ilosczarejestrbraki=kwe_ilosczarejestrbraki+delta_zarejestr_brak_old,
kwe_iloscrozplanowana=kwe_iloscrozplanowana+delta_plan_old,
kwe_tomagmag=kwe_tomagmag+delta_mag_old,
kwe_tomagmagclosed=kwe_tomagmagclosed+delta_magc_old,
kwe_flaga=kwe_flaga|64
   WHERE kwe_idelemu=OLD.kwe_idelemu;
  END IF;

  IF (OLD.knp_idplanu>0) THEN
   UPDATE tr_kkwnodplan SET knp_iloscwykonana=knp_iloscwykonana+delta_wyk_old WHERE knp_idplanu=OLD.knp_idplanu;
  END IF;

 END IF;

 IF (
     (delta_wyk_new<>0) OR (delta_brak_new<>0) OR (delta_plan_new<>0) OR (delta_mag_new<>0) OR (delta_magc_new<>0) OR 
	 (delta_zarejestr_new<>0) OR (delta_zarejestr_brak_new<>0) OR (TG_OP='INSERT')
    ) THEN 
  IF (NEW.knw_flaga&8=8) THEN
  ---wykonanie procentowe, aktualizumeny pole odnosnie wykonania procentowego
   UPDATE tr_kkwnod SET kwe_iloscwykprocent=kwe_iloscwykprocent+delta_wyk_new,
   kwe_ilosczarejestrprocent=kwe_ilosczarejestrprocent+delta_zarejestr_new,
   kwe_iloscbrakow=kwe_iloscbrakow+delta_brak_new,
   kwe_ilosczarejestrbraki=kwe_ilosczarejestrbraki+delta_zarejestr_brak_new,
   kwe_iloscrozplanowanaprocent=kwe_iloscrozplanowanaprocent+delta_plan_new,
   kwe_tomagmag=kwe_tomagmag+delta_mag_new,
   kwe_tomagmagclosed=kwe_tomagmagclosed+delta_magc_new,
   kwe_flaga=kwe_flaga|64|16
   WHERE kwe_idelemu=NEW.kwe_idelemu;
  ELSE
   UPDATE tr_kkwnod SET kwe_iloscwyk=kwe_iloscwyk+delta_wyk_new,
   kwe_ilosczarejestr=kwe_ilosczarejestr+delta_zarejestr_new,
   kwe_iloscbrakow=kwe_iloscbrakow+delta_brak_new,
   kwe_ilosczarejestrbraki=kwe_ilosczarejestrbraki+delta_zarejestr_brak_new,
   kwe_iloscrozplanowana=kwe_iloscrozplanowana+delta_plan_new,
   kwe_tomagmag=kwe_tomagmag+delta_mag_new,
   kwe_tomagmagclosed=kwe_tomagmagclosed+delta_magc_new,
   kwe_flaga=kwe_flaga|64|16
   WHERE kwe_idelemu=NEW.kwe_idelemu;
  END IF;

  IF (NEW.knp_idplanu>0) THEN
   UPDATE tr_kkwnodplan SET knp_iloscwykonana=knp_iloscwykonana+delta_wyk_new WHERE knp_idplanu=NEW.knp_idplanu;   
  END IF;
 END IF;
 
 -------------------------------------------------------------------------------------------------------------
 -- CZAS EFEKTYWNY
 IF (TG_OP='INSERT') THEN
  IF ((NEW.knw_flaga&(1<<0))=(1<<0)) THEN
	przeliczenieczasuefektywnego=TRUE;
  END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  IF ((NEW.knw_datawyk <> OLD.knw_datawyk) OR (NEW.knw_datastart <> OLD.knw_datastart) OR ((NEW.knw_flaga&(1<<0)) <> (OLD.knw_flaga&(1<<0)))) THEN
   przeliczenieczasuefektywnego=TRUE;
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  IF ((OLD.knw_flaga&(1<<0))=(1<<0)) THEN
	przeliczenieczasuefektywnego=TRUE;
  END IF;
 END IF;
 
 IF (przeliczenieczasuefektywnego) THEN
  --tmp=(SELECT COALESCE(cf_defvalue::int,0) FROM tc_config WHERE cf_tabela='mrp_wyk_synchro_czasefekt');
  tmp=1;
  IF (tmp=1) THEN
   IF (TG_OP='DELETE') THEN
    tmp=getCzasEfektywnyKKWNodWyk(OLD.knw_idelemu, OLD.knw_zaangazpracwykonanie, OLD.knw_datastart::TIMESTAMP, OLD.knw_datawyk::TIMESTAMP, TRUE);
   ELSE
    NEW.knw_czasefektywny=getCzasEfektywnyKKWNodWyk(NEW.knw_idelemu, NEW.knw_zaangazpracwykonanie, NEW.knw_datastart::TIMESTAMP, NEW.knw_datawyk::TIMESTAMP, TRUE);
   END IF;
  END IF;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
