CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 _ob_idobiektu_new INT:=0; 
 _k_idklienta_new INT:=0;
 _the_nodtype INT:=-1;
 _tsp_flaga INT:=0;
BEGIN
 
 IF ((NEW.the_flaga&(1<<17))=(1<<17)) THEN -- Robocizna
   RETURN NEW; 
 END IF;
  
 _the_nodtype=NEW.the_nodtype;
  
 IF (NEW.the_nodtype=0) THEN
  _ob_idobiektu_new=COALESCE(NEW.ob_idobiektu,0);
 END IF;
  
 IF (NEW.the_nodtype=1) THEN
  _k_idklienta_new=COALESCE(NEW.k_idklienta,0);
 END IF;     
 
 IF (_the_nodtype=0 AND _ob_idobiektu_new<>0) THEN  -- Normalny NOD, ze stanowiskiem
  _tsp_flaga=3+16;
  IF ((NEW.the_flaga&(1<<18))=(1<<18)) THEN
   _tsp_flaga=11+16;
  END IF;
   INSERT INTO tr_technostpracy(tsp_flaga,ob_idobiektu,the_idelem,tsp_tpz,tsp_tpj,tsp_wydajnosc,tsp_iloscosob,tsp_kosztnah,tsp_kosztnaj,tsp_kosztkooperacji,tsp_zaangazpracownika,tsp_koopczasreal) VALUES (_tsp_flaga,_ob_idobiektu_new,NEW.the_idelem,NEW.the_tpz,NEW.the_tpj,NEW.the_wydajnosc,NEW.the_iloscosob,NEW.the_kosztnah,NEW.the_kosztnaj,NEW.the_kosztkooperacji,NEW.the_zaangazpracownika,NEW.the_koopczasreal);
 END IF;

 IF (_the_nodtype=1 AND _k_idklienta_new<>0) THEN -- Normalny NOD, z kooperantem
  INSERT INTO tr_technostpracy(tsp_flaga,k_idklienta,the_idelem,tsp_tpz,tsp_tpj,tsp_wydajnosc,tsp_iloscosob,tsp_kosztnah,tsp_kosztnaj,tsp_kosztkooperacji,tsp_zaangazpracownika,tsp_koopczasreal) VALUES (23,_k_idklienta_new,NEW.the_idelem,NEW.the_tpz,NEW.the_tpj,NEW.the_wydajnosc,NEW.the_iloscosob,NEW.the_kosztnah,NEW.the_kosztnaj,NEW.the_kosztkooperacji,NEW.the_zaangazpracownika,NEW.the_koopczasreal);
 END IF; 
 
 RETURN NEW; 
END;
$$;
