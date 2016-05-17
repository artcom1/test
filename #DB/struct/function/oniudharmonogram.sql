CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 od_czasu timestamp;
 do_czasu timestamp;
 _ob_idobiektu INT;
 _w_idwydzialu INT;

BEGIN
 IF (TG_OP<>'DELETE') THEN
  _ob_idobiektu=NEW.ob_idobiektu;
  _w_idwydzialu=NEW.w_idwydzialu;
  IF (TG_OP='INSERT') THEN
   od_czasu=NEW.hm_odczasu;
   do_czasu=NEW.hm_doczasu;
  ELSE
   od_czasu=min(NEW.hm_odczasu,OLD.hm_odczasu);
   do_czasu=min(NEW.hm_doczasu,OLD.hm_doczasu);
  END IF;
 ELSE
  _ob_idobiektu=OLD.ob_idobiektu;
  _w_idwydzialu=OLD.w_idwydzialu;
  od_czasu=OLD.hm_odczasu;
  do_czasu=OLD.hm_doczasu;
 END IF;

 IF (_ob_idobiektu>0 OR _w_idwydzialu>0) THEN
  UPDATE tr_kkwnodplan SET 
         knp_flaga=knp_flaga|16384, 
         knp_czaswolny=getfreetime(knp_datarozpoczecia,knp_datazakonczenia,ob_idobiektu,1) ,
		 knp_czaswolny_np=getfreetime(knp_datarozpoczecia,knp_datazakonczenia,ob_idobiektu,2) 
 WHERE (ob_idobiektu=_ob_idobiektu OR ob_idobiektu IN (SELECT ob_idobiektu FROM tg_obiekty WHERE ob_flaga&128=128 AND w_idwydzialu=_w_idwydzialu)) AND 
       knp_flaga&(1|2|16|32)=0 AND 
       knp_datarozpoczecia<do_czasu AND 
       knp_datazakonczenia>od_czasu;
	   
 UPDATE tr_kkwnodwyk SET 
         knw_czaswolny=getfreetime(knw_datastart::TIMESTAMP,knw_datawyk::TIMESTAMP,ob_idobiektu,1) ,
		 knw_czaswolny_np=getfreetime(knw_datastart::TIMESTAMP,knw_datawyk::TIMESTAMP,ob_idobiektu,2) 
 WHERE (ob_idobiektu=_ob_idobiektu OR ob_idobiektu IN (SELECT ob_idobiektu FROM tg_obiekty WHERE ob_flaga&128=128 AND w_idwydzialu=_w_idwydzialu)) AND
       knw_datastart<do_czasu AND 
       knw_datawyk>od_czasu;
	   
 ELSE
  UPDATE tr_kkwnodplan SET 
         knp_flaga=knp_flaga|16384, 
         knp_czaswolny=getfreetime(knp_datarozpoczecia,knp_datazakonczenia,ob_idobiektu,1) ,
         knp_czaswolny_np=getfreetime(knp_datarozpoczecia,knp_datazakonczenia,ob_idobiektu,2) 
  WHERE knp_flaga&(1|2|16|32)=0 AND 
        knp_datarozpoczecia<do_czasu AND 
        knp_datazakonczenia>od_czasu;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
