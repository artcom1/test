CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 dosob INT:=0;
 przelicznik INT;
 przelicznikold INT;
 idhotel INT;
 wartosc NUMERIC:=0;
 waluta INT:=0;
BEGIN

 IF (TG_OP = 'INSERT') THEN
  przelicznik=(SELECT hs_przelicznik FROM ts_hotelestruktura WHERE hs_idstruktury=NEW.hs_idstruktury);
  dosob=NEW.he_iloscpokoi*przelicznik;
  idhotel=NEW.ht_idhotelu;
  waluta=NEW.wl_idwaluty;
  wartosc=NEW.he_cenajedn*NEW.he_iloscpokoi;
 END IF;

 IF (TG_OP = 'UPDATE') THEN
  IF (NEW.ht_idhotelu<>OLD.ht_idhotelu) THEN
    RAISE EXCEPTION 'Nie mozna w ten sposob zmieniac elementu hotelu';
  END IF;

  przelicznik=(SELECT hs_przelicznik FROM ts_hotelestruktura WHERE hs_idstruktury=NEW.hs_idstruktury);
  przelicznikold=przelicznik;
  IF (NEW.hs_idstruktury<>OLD.hs_idstruktury) THEN
    przelicznikold=(SELECT hs_przelicznik FROM ts_hotelestruktura WHERE hs_idstruktury=OLD.hs_idstruktury);
  END IF;
 
  dosob=NEW.he_iloscpokoi*przelicznik-OLD.he_iloscpokoi*przelicznikold;
  wartosc=NEW.he_cenajedn*NEW.he_iloscpokoi-OLD.he_iloscpokoi*OLD.he_cenajedn;
  idhotel=NEW.ht_idhotelu;

  IF (NEW.wl_idwaluty<>OLD.wl_idwaluty) THEN
    waluta=NEW.wl_idwaluty;
  END IF;
    
 END IF;

 IF (TG_OP = 'DELETE') THEN
  przelicznik=(SELECT hs_przelicznik FROM ts_hotelestruktura WHERE hs_idstruktury=OLD.hs_idstruktury);
  dosob=-OLD.he_iloscpokoi*przelicznik;
  wartosc=-OLD.he_iloscpokoi*OLD.he_cenajedn;
  idhotel=OLD.ht_idhotelu;
 END IF;

 IF (dosob<>0 OR wartosc<>0) THEN
  UPDATE tg_hotelezlecen SET ht_iloscosob=ht_iloscosob+dosob, ht_wartosc=ht_wartosc+wartosc  WHERE ht_idhotelu=idhotel;
 END IF;

 IF (waluta>0) THEN
  UPDATE tg_hotelezlecen SET wl_idwaluty=waluta  WHERE ht_idhotelu=idhotel;
 END IF;

 IF (TG_OP = 'DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;$$;
