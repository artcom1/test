CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN

 IF (TG_OP<>'INSERT') THEN
  UPDATE gms.tm_simcoll SET
          ---Ilosc WZetek
	  sc_ilosc[0]=sc_ilosc[0]+OLD.so_ilosci[0],
	  ---Ilosc Rezerwacji ciezkich
	  sc_ilosc[1]=sc_ilosc[1]+OLD.so_ilosci[1],
	  ---Ilosc Rezerwacji lekkich
	  sc_ilosc[2]=sc_ilosc[2]+OLD.so_ilosci[2],
	  sc_iloscpoz=sc_iloscpoz+OLD.so_ilosc,
	  sc_iloscused=sc_iloscused-OLD.so_ilosc
  WHERE sc_id=OLD.sc_id;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  UPDATE gms.tm_simcoll SET
          ---Ilosc WZetek
	  sc_ilosc[0]=sc_ilosc[0]-NEW.so_ilosci[0],
	  ---Ilosc Rezerwacji ciezkich
	  sc_ilosc[1]=sc_ilosc[1]-NEW.so_ilosci[1],
	  ---Ilosc Rezerwacji lekkich
	  sc_ilosc[2]=sc_ilosc[2]-NEW.so_ilosci[2],
	  sc_iloscpoz=sc_iloscpoz-NEW.so_ilosc,
	  sc_iloscused=sc_iloscused+NEW.so_ilosc
  WHERE sc_id=NEW.sc_id;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
