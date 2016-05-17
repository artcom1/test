CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
 --gdy sie zmienil wydzial nalezy przeliczyc czas wolny dla planow niewykonane plany obejmujace dane stanowisko
 IF (NEW.w_idwydzialu<>OLD.w_idwydzialu) THEN
  UPDATE tr_kkwnodplan SET 
         knp_flaga=knp_flaga|16384, 
		 knp_czaswolny=getfreetime(knp_datarozpoczecia,knp_datazakonczenia,sp_idstanowiska,1),
		 knp_czaswolny_np=getfreetime(knp_datarozpoczecia,knp_datazakonczenia,sp_idstanowiska,2) 
 WHERE sp_idstanowiska=NEW.sp_idstanowiska AND
       knp_flaga&(1|2|16|32)=0;
 END IF;

 RETURN NEW;
END;
$$;
