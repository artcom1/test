CREATE FUNCTION p_on_a_iud_nodwyk_narzedzia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 _insert BOOLEAN:=FALSE;
 _update BOOLEAN:=FALSE;
 _zeruj BOOLEAN:=FALSE;
 _rec_info_wyk RECORD;
BEGIN

 IF (TG_OP='INSERT') THEN
  _insert=TRUE;
  IF ((NEW.knw_flaga&(1<<0))=(1<<0)) THEN -- zakonczenie wykonania
   _update=TRUE;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN 
  IF ((OLD.knw_flaga&(1<<0))<>(NEW.knw_flaga&(1<<0))) THEN -- zmiana wykonania
   IF (OLD.knw_flaga&(1<<0)=0) THEN -- Mialem nie zakonczony start-stop
    _update=TRUE;
   ELSE -- Mialem zakonczony start-stop
    _zeruj=TRUE;
   END IF;
  END IF;
  IF (OLD.knw_iloscwyk<>NEW.knw_iloscwyk OR OLD.knw_datastart<>NEW.knw_datastart OR OLD.knw_datawyk<>NEW.knw_datawyk) THEN -- zmiana ilosci lub czasu
   _update=TRUE;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN 
  -- Nie musze nic robic bo referencja mi tym steruje
 END IF;
 
 IF (_insert) THEN
  FOR _rec_info_wyk IN 
  SELECT nrr_idruchu FROM tr_narzedzie_ruch WHERE kwe_idelemu=NEW.kwe_idelemu AND nrr_data_odlozenia IS NULL
  LOOP
   IF (_update) THEN
    INSERT INTO tr_narzedzie_wyk 
	(nrr_idruchu, knw_idelemu, nrw_przebieg_oper, nrw_przebieg_h) 
	VALUES 
	(_rec_info_wyk.nrr_idruchu, NEW.knw_idelemu, NEW.knw_iloscwyk, EXTRACT(epoch FROM NEW.knw_datawyk-NEW.knw_datastart)/3600);    
   ELSE
    INSERT INTO tr_narzedzie_wyk (nrr_idruchu, knw_idelemu) VALUES (_rec_info_wyk.nrr_idruchu, NEW.knw_idelemu);
   END IF;
  END LOOP;
   
  IF (_update) THEN      
   _update=FALSE;  
  END IF;
 END IF;
 
 IF (_update) THEN
  UPDATE tr_narzedzie_wyk SET 
  nrw_przebieg_oper=NEW.knw_iloscwyk, 
  nrw_przebieg_h=(EXTRACT(epoch FROM NEW.knw_datawyk-NEW.knw_datastart)/3600)   
  WHERE
  knw_idelemu=NEW.knw_idelemu AND nrw_flaga&(1<<0)=0;
 END IF;
 
 IF (_zeruj) THEN
  UPDATE tr_narzedzie_wyk SET nrw_przebieg_oper=0, nrw_przebieg_h=0 WHERE knw_idelemu=NEW.knw_idelemu AND nrw_flaga&(1<<0)=0;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
