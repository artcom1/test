CREATE FUNCTION oniudkkwnodwykdet() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 roznica INTERVAL;
 rbh     NUMERIC:=0;
 wyk     RECORD;
 synchro INT:=0;
BEGIN
 IF (TG_OP='INSERT') THEN
  SELECT  kwe_idelemu, kwh_idheadu INTO wyk FROM tr_kkwnodwyk WHERE knw_idelemu=NEW.knw_idelemu; 
  NEW.kwe_idelemu=wyk.kwe_idelemu;
  NEW.kwh_idheadu=wyk.kwh_idheadu;
 END IF;
  
 -------------------------------------------------------------------------------------------------------------
 -- SYNCHRONIZACJA WYK DET
 IF (TG_OP='UPDATE') THEN
  IF ((NEW.kwd_datastart <> OLD.kwd_datastart) OR (NEW.kwd_dataend <> OLD.kwd_dataend) OR ((NEW.kwd_flaga&(1<<0)) <> (OLD.kwd_flaga&(1<<0)))) THEN
   synchro=1; -- Zmiana flagi lub dat - synchronizuj
  END IF;
 END IF; 
 
 IF (TG_OP='INSERT') THEN
  synchro=1; -- Insert - synchronizuj
 END IF; 
 
 IF (synchro=1) THEN -- Zaszly warunki do synchronizacji
  synchro=(SELECT COALESCE(cf_defvalue::int,0) FROM tc_config WHERE cf_tabela='mrp_wyk_synchro_wykdet'); -- Sprawdzam ustawienia programu
  IF (synchro=1) THEN
   SELECT knw_datastart, knw_datawyk, (knw_flaga&(1<<0)) AS flaga INTO wyk FROM tr_kkwnodwyk WHERE knw_idelemu=NEW.knw_idelemu;
   IF (wyk.flaga=0) THEN-- Nie zakonczono pracy
    NEW.kwd_flaga=NEW.kwd_flaga&(~(1<<0));
   ELSE
    NEW.kwd_flaga=NEW.kwd_flaga|(1<<0);
   END IF;
   NEW.kwd_datastart=wyk.knw_datastart;
   NEW.kwd_dataend=wyk.knw_datawyk;  
  END IF;
 END IF; 
 -------------------------------------------------------------------------------------------------------------

 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
  IF (NEW.kwd_flaga&3=3) THEN
   ---przy rejestrowaniu startu i stopu wyliczamy RBH
   roznica=NEW.kwd_dataend-NEW.kwd_datastart;
   rbh=date_part('days',roznica)*24+date_part('hours',roznica)+date_part('minute',roznica)/60;
   rbh=round(rbh,2);
   NEW.kwd_rbh=rbh;
   ---wyliczamy czas wolny/niepracujacy w firmie w czasie trwania tej operacji (prawdziwe dane odnoscie wydajnosci)
   NEW.kwd_czaswolny=getfreetime(NEW.kwd_datastart::timestamp, NEW.kwd_dataend::timestamp, (SELECT ob_idobiektu FROM tr_kkwnodwyk WHERE knw_idelemu=NEW.knw_idelemu) );
  ELSE
   NEW.kwd_czaswolny=0;
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
