CREATE FUNCTION oniurealizacjaplanuprod() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

 IF (TG_OP='DELETE') THEN
  UPDATE tg_transelem SET tel_flaga=tel_flaga&(~262144)|16384 WHERE tel_idelem=OLD.tel_idelem;
  
  IF (OLD.rpp_flaga&1=1) THEN -- realizacja naprawy
   UPDATE tg_naprawyzlecenia SET nz_ilosczreal=nz_ilosczreal-OLD.rpp_ilosc WHERE nz_idnaprawy=OLD.nz_idnaprawy;
  ELSE
   UPDATE tg_planzlecenia SET pz_ilosczreal=pz_ilosczreal-OLD.rpp_ilosc WHERE pz_idplanu=OLD.pz_idplanu;
  END IF;
  
  RETURN OLD;
 END IF;

 IF (TG_OP='UPDATE') THEN
   IF (OLD.tel_idelem<>NEW.tel_idelem) THEN
     UPDATE tg_transelem SET tel_flaga=tel_flaga&(~262144)|16384 WHERE tel_idelem=OLD.tel_idelem;
     UPDATE tg_transelem SET tel_flaga=tel_flaga|262144|16384 WHERE tel_idelem=NEW.tel_idelem;
   END IF;
   
   IF (OLD.rpp_flaga&1=1) THEN -- realizacja naprawy
    IF (OLD.nz_idnaprawy<>NEW.nz_idnaprawy) THEN
     UPDATE tg_naprawyzlecenia SET nz_ilosczreal=nz_ilosczreal-OLD.rpp_ilosc WHERE nz_idnaprawy=OLD.nz_idnaprawy;
     UPDATE tg_naprawyzlecenia SET nz_ilosczreal=nz_ilosczreal+NEW.rpp_ilosc WHERE nz_idnaprawy=NEW.nz_idnaprawy;
    END IF;
    IF (OLD.nz_idnaprawy=NEW.nz_idnaprawy AND OLD.rpp_ilosc<>NEW.rpp_ilosc) THEN
     UPDATE tg_naprawyzlecenia SET nz_ilosczreal=nz_ilosczreal+NEW.rpp_ilosc-OLD.rpp_ilosc WHERE nz_idnaprawy=NEW.nz_idnaprawy;
    END IF;
   ELSE
    IF (OLD.pz_idplanu<>NEW.pz_idplanu) THEN
     UPDATE tg_planzlecenia SET pz_ilosczreal=pz_ilosczreal-OLD.rpp_ilosc WHERE pz_idplanu=OLD.pz_idplanu;
     UPDATE tg_planzlecenia SET pz_ilosczreal=pz_ilosczreal+NEW.rpp_ilosc WHERE pz_idplanu=NEW.pz_idplanu;
    END IF;
    IF (OLD.pz_idplanu=NEW.pz_idplanu AND OLD.rpp_ilosc<>NEW.rpp_ilosc) THEN
     UPDATE tg_planzlecenia SET pz_ilosczreal=pz_ilosczreal+NEW.rpp_ilosc-OLD.rpp_ilosc WHERE pz_idplanu=NEW.pz_idplanu;
    END IF;
   END IF;
 END IF;

 IF (TG_OP='INSERT') THEN
  UPDATE tg_transelem SET tel_flaga=tel_flaga|262144|16384 WHERE tel_idelem=NEW.tel_idelem;
  
  IF (NEW.rpp_flaga&1=1) THEN -- realizacja naprawy
   UPDATE tg_naprawyzlecenia SET nz_ilosczreal=nz_ilosczreal+NEW.rpp_ilosc WHERE nz_idnaprawy=NEW.nz_idnaprawy;
  ELSE
   UPDATE tg_planzlecenia SET pz_ilosczreal=pz_ilosczreal+NEW.rpp_ilosc WHERE pz_idplanu=NEW.pz_idplanu;
  END IF;  
 END IF;
  
 RETURN NEW;

END;
$$;
