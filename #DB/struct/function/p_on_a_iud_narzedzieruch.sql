CREATE FUNCTION p_on_a_iud_narzedzieruch() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 _rec_info_wyk RECORD;
BEGIN

 IF (TG_OP='INSERT') THEN
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (OLD.tel_idelem_odlozenie IS NULL AND NEW.tel_idelem_odlozenie IS NOT NULL) THEN
   UPDATE tr_narzedzie_wyk SET nrw_flaga=nrw_flaga|(1<<0) WHERE nrr_idruchu=NEW.nrr_idruchu;
  END IF;
  
  IF (OLD.tel_idelem_odlozenie IS NOT NULL AND NEW.tel_idelem_odlozenie IS NULL) THEN   
   FOR _rec_info_wyk IN 
   SELECT 
   nrw_idwykonania,
   knw_iloscwyk AS nrw_przebieg_oper,
   (EXTRACT(epoch FROM knw_datawyk-knw_datastart)/3600) AS nrw_przebieg_h
   FROM tr_narzedzie_wyk AS nwyk
   JOIN tr_kkwnodwyk AS wyk USING (knw_idelemu)
   WHERE nrr_idruchu=NEW.nrr_idruchu
   LOOP    
    UPDATE tr_narzedzie_wyk SET 
	nrw_flaga=nrw_flaga&(~(1<<0)), nrw_przebieg_oper=nullzero(_rec_info_wyk.nrw_przebieg_oper), nrw_przebieg_h=nullzero(_rec_info_wyk.nrw_przebieg_h)
	WHERE nrw_idwykonania=_rec_info_wyk.nrw_idwykonania;
   END LOOP;     
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN 
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
