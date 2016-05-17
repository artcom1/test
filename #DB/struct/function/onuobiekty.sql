CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

 ---gdy sie zmienil wydzial nalezy przeliczyc czas wolny dla planow niewykonane plany obejmujace dane stanowisko
 ---stanowisko pracy
 IF ((NEW.ob_flaga&128=128) AND NEW.w_idwydzialu<>OLD.w_idwydzialu) THEN
  UPDATE tr_kkwnodplan SET 
         knp_flaga=knp_flaga|16384, 
	 knp_czaswolny=getfreetime(knp_datarozpoczecia,knp_datazakonczenia,ob_idobiektu) 
	 WHERE ob_idobiektu=NEW.ob_idobiektu AND
	       knp_flaga&(1|2|16)=0;
 END IF;

 RETURN NEW;
END;
$$;
