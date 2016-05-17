CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 pracownik INTEGER := 0;
 aggrec RECORD;
BEGIN
 pracownik = NEW.p_idpracownika;

 SELECT * INTO aggrec FROM tb_rcp_agregacja AS agg WHERE agg.p_idpracownika=pracownik AND (agg.rcpa_flaga&1)=0 ORDER BY agg.rcpa_data DESC LIMIT 1;

 IF FOUND THEN
  IF (aggrec.rcpa_data != NEW.rcp_czaswydarzenia::date) THEN
   --zamknij stary dzien
   PERFORM ZagregujWydarzeniaRCP(NEW.p_idpracownika, aggrec.rcpa_data::date, true);
  END IF;
 END IF;
 
 --rozlicz ten dzien bez zamykania
 PERFORM ZagregujWydarzeniaRCP(NEW.p_idpracownika, NEW.rcp_czaswydarzenia::date, false);
 
 RETURN NEW;
END;
$$;
