CREATE FUNCTION onbiudtpkkwhead() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltaoldpp NUMERIC:=0;
 deltanewpp NUMERIC:=0;
 deltaoldp_zr NUMERIC:=0;
 deltanewp_zr NUMERIC:=0;
 deltaoldp_wreal NUMERIC:=0;
 deltanewp_wreal NUMERIC:=0;
 deltaoldp_wmag NUMERIC:=0;
 deltanewp_wmag NUMERIC:=0;
BEGIN

 IF (TG_OP<>'INSERT') THEN
  deltaoldpp=deltaoldpp-OLD.kwh_stan;
  deltaoldp_zr=deltaoldp_zr-OLD.kwh_ilosczr;
  deltaoldp_wreal=deltaoldp_wreal-OLD.kwh_stan;
  deltaoldp_wmag=deltaoldp_wmag-OLD.kwh_iloscwmag;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  deltanewpp=deltanewpp+NEW.kwh_stan;
  deltanewp_zr=deltanewp_zr+NEW.kwh_ilosczr;
  deltanewp_wreal=deltanewp_wreal+NEW.kwh_stan;
  deltanewp_wmag=deltanewp_wmag+NEW.kwh_iloscwmag;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (nullZero(OLD.pp_idpolproduktu)=nullZero(NEW.pp_idpolproduktu)) THEN
   deltanewpp=deltanewpp+deltaoldpp;
   deltaoldpp=0;
  END IF;
  IF (nullZero(OLD.kwp_idplanu)=nullZero(NEW.kwp_idplanu)) THEN
   deltanewp_zr=deltanewp_zr+deltaoldp_zr;
   deltaoldp_zr=0;
   deltanewp_wreal=deltanewp_wreal+deltaoldp_wreal;
   deltaoldp_wreal=0;
   deltanewp_wmag=deltanewp_wmag+deltaoldp_wmag;
   deltaoldp_wmag=0;
  END IF;
 END IF;

 IF (deltaoldpp<>0) THEN
  UPDATE tp_polprodukty SET pp_stan=pp_stan+deltaoldpp WHERE pp_idpolproduktu=OLD.pp_idpolproduktu;
  deltaoldpp=0;
 END IF;

 IF (deltaoldp_zr<>0) OR (deltaoldp_wreal<>0) OR (deltaoldp_wmag<>0) THEN
  UPDATE tp_kkwplan SET 
    kwp_ilosczr=kwp_ilosczr+deltaoldp_zr,
    kwp_iloscwreal=kwp_iloscwreal+deltaoldp_wreal,
    kwp_iloscwmag=kwp_iloscwmag+deltaoldp_wmag
  WHERE kwp_idplanu=OLD.kwp_idplanu;
 END IF;

 IF (deltanewp_zr<>0) OR (deltanewp_wreal<>0) OR (deltanewp_wmag<>0) THEN
  UPDATE tp_kkwplan SET 
    kwp_ilosczr=kwp_ilosczr+deltanewp_zr,
    kwp_iloscwreal=kwp_iloscwreal+deltanewp_wreal,
    kwp_iloscwmag=kwp_iloscwmag+deltanewp_wmag
  WHERE kwp_idplanu=NEW.kwp_idplanu;
 END IF;

 IF (deltanewpp<>0) THEN
  UPDATE tp_polprodukty SET pp_stan=pp_stan+deltanewpp WHERE pp_idpolproduktu=NEW.pp_idpolproduktu;
  deltanewpp=0;
 END IF;

 IF (TG_OP<>'DELETE') THEN
  IF (NEW.kwh_stan<0) THEN
   RAISE EXCEPTION 'Stan na KKW nie moze zejsc ponizej 0!';
  END IF;
  IF (NEW.kwh_stan<>0) THEN
   NEW.kwh_flaga=NEW.kwh_flaga&(~1);
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
