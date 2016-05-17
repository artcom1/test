CREATE FUNCTION onbudtechnoelemstkl() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
 _ob_idobiektu_old INT:=0;
 _ob_idobiektu_new INT:=0;
 _k_idklienta_old INT:=0;
 _k_idklienta_new INT:=0;
 _the_nodtype INT:=-1;
 _tsp_idstanowiska_new INT:=0;
 _tsp_flaga INT:=0;
BEGIN
 -- KKWNT_NORMALNOD  = 0
 -- KKWNT_KOOPERACJA = 1
  
  IF (TG_OP='UPDATE') THEN
   IF (NEW.the_nodtype<>OLD.the_nodtype) THEN 
     RETURN NEW; 
   END IF;
  END IF;
 
 -- NEW
 IF (TG_OP='UPDATE') THEN
  IF ((NEW.the_flaga&(1<<17))=(1<<17)) THEN 
    RETURN NEW; 
  END IF;
  
  _the_nodtype=NEW.the_nodtype;
  
  IF (NEW.the_nodtype=0) THEN
   _ob_idobiektu_new=COALESCE(NEW.ob_idobiektu,0);
  END IF;
  
  IF (NEW.the_nodtype=1) THEN
   _k_idklienta_new=COALESCE(NEW.k_idklienta,0);
  END IF;      
 END IF;
 
 -- OLD
 IF ((OLD.the_flaga&(1<<17))=(1<<17)) THEN 
   RETURN OLD; 
 END IF;
  
 _the_nodtype=OLD.the_nodtype;
  
 IF (OLD.the_nodtype=0) THEN
  _ob_idobiektu_old=COALESCE(OLD.ob_idobiektu,0);
 END IF;
  
 IF (OLD.the_nodtype=1) THEN
  _k_idklienta_old=COALESCE(OLD.k_idklienta,0);
 END IF;
 
 IF (_the_nodtype=0) THEN  -- Normalny NOD, ze stanowiskiem
  IF (_ob_idobiektu_old=_ob_idobiektu_new) THEN
   -- Aktualizuje tylko flage
   IF (_ob_idobiektu_new<>0) THEN -- Nie zmienil mi sie obiekt i mam pewnosc ze jest ustawiony => jest update
    IF((OLD.the_flaga&(1<<18))<>(NEW.the_flaga&(1<<18))) THEN -- Zmienilo mi sie ustawienie "Przy plan. i wyk. uwzgledniaj wszystkie stanowiska tego samego rodzaju"
 IF ((NEW.the_flaga&(1<<18))=(1<<18)) THEN
  UPDATE tr_technostpracy SET tsp_flaga=(tsp_flaga|8) WHERE ob_idobiektu=_ob_idobiektu_new AND the_idelem=NEW.the_idelem;
 ELSE
  UPDATE tr_technostpracy SET tsp_flaga=(tsp_flaga&(~8)) WHERE ob_idobiektu=_ob_idobiektu_new AND the_idelem=NEW.the_idelem;
 END IF;
END IF;
   END IF;
  ELSE  
   -- Przypadek I
   IF (_ob_idobiektu_old=0) THEN -- Starego nie bylo - robie inserta
    _tsp_flaga=3+16;
IF ((NEW.the_flaga&(1<<18))=(1<<18)) THEN
 _tsp_flaga=11+16;
END IF;
    INSERT INTO tr_technostpracy(tsp_flaga,ob_idobiektu,the_idelem,tsp_tpz,tsp_tpj,tsp_wydajnosc,tsp_iloscosob,tsp_kosztnah,tsp_kosztnaj,tsp_kosztkooperacji,tsp_zaangazpracownika,tsp_koopczasreal) VALUES (_tsp_flaga,_ob_idobiektu_new,NEW.the_idelem,NEW.the_tpz,NEW.the_tpj,NEW.the_wydajnosc,NEW.the_iloscosob,NEW.the_kosztnah,NEW.the_kosztnaj,NEW.the_kosztkooperacji,NEW.the_zaangazpracownika,NEW.the_koopczasreal);
   END IF;
   -- Przypadek II
   IF (_ob_idobiektu_new=0) THEN -- Nie ma nowego - robie deleta  
    DELETE FROM tr_technostpracy WHERE ob_idobiektu=_ob_idobiektu_old AND the_idelem=OLD.the_idelem;
    IF (TG_OP='UPDATE') THEN
     NEW.ob_idobiektu=(SELECT ob_idobiektu FROM tr_technostpracy WHERE tsp_flaga&3=3 AND the_idelem=NEW.the_idelem);
END IF;
   END IF;  
   -- Przypadek III
   IF (_ob_idobiektu_new<>0 AND _ob_idobiektu_old<>0) THEN -- Zmieniam z jednego na drugi a stary usuwam
    -- 1. Szukam nowego obiektu na liscie stanowisk pracy
     DELETE FROM tr_technostpracy WHERE ob_idobiektu=_ob_idobiektu_old AND the_idelem=NEW.the_idelem AND tsp_flaga&(1<<4)=(1<<4);
    _tsp_idstanowiska_new=(SELECT tsp_idstanowiska FROM tr_technostpracy WHERE ob_idobiektu=_ob_idobiektu_new AND the_idelem=NEW.the_idelem);
    IF (COALESCE(_tsp_idstanowiska_new,0)=0) THEN -- Nie ma jeszcze takiego na mojej liscie - dodaje go
 _tsp_flaga=3+16;
 IF ((NEW.the_flaga&(1<<18))=(1<<18)) THEN
  _tsp_flaga=11+16;
 END IF;
     INSERT INTO tr_technostpracy(tsp_flaga,ob_idobiektu,the_idelem,tsp_tpz,tsp_tpj,tsp_wydajnosc,tsp_iloscosob,tsp_kosztnah,tsp_kosztnaj,tsp_kosztkooperacji,tsp_zaangazpracownika,tsp_koopczasreal) VALUES (_tsp_flaga,_ob_idobiektu_new,NEW.the_idelem,NEW.the_tpz,NEW.the_tpj,NEW.the_wydajnosc,NEW.the_iloscosob,NEW.the_kosztnah,NEW.the_kosztnaj,NEW.the_kosztkooperacji,NEW.the_zaangazpracownika,NEW.the_koopczasreal);
    ELSE -- Mam juz tekiego, wiec tylko ustawiam go jako domyslnego
     UPDATE tr_technostpracy SET tsp_flaga=(tsp_flaga|2) WHERE tsp_idstanowiska=_tsp_idstanowiska_new;
    END IF;
   END IF;  
  END IF;  
 END IF;
 
 IF (_the_nodtype=1 AND _k_idklienta_old<>_k_idklienta_new) THEN -- Normalny NOD, z kooperantem
  -- Przypadek I
  IF (_k_idklienta_old=0) THEN -- Starego nie bylo - robie inserta
   INSERT INTO tr_technostpracy(tsp_flaga,k_idklienta,the_idelem,tsp_tpz,tsp_tpj,tsp_wydajnosc,tsp_iloscosob,tsp_kosztnah,tsp_kosztnaj,tsp_kosztkooperacji,tsp_zaangazpracownika,tsp_koopczasreal) VALUES (23,_k_idklienta_new,NEW.the_idelem,NEW.the_tpz,NEW.the_tpj,NEW.the_wydajnosc,NEW.the_iloscosob,NEW.the_kosztnah,NEW.the_kosztnaj,NEW.the_kosztkooperacji,NEW.the_zaangazpracownika,NEW.the_koopczasreal);
  END IF;

  -- Przypadek II
  IF (_k_idklienta_new=0) THEN -- Nie ma nowego - robie deleta
   DELETE FROM tr_technostpracy WHERE k_idklienta=_k_idklienta_old AND the_idelem=OLD.the_idelem;
   IF (TG_OP='UPDATE') THEN
    NEW.k_idklienta=(SELECT k_idklienta FROM tr_technostpracy WHERE tsp_flaga&7=7 AND the_idelem=NEW.the_idelem);
   END IF;
  END IF;
  
  -- Przypadek III
  IF (_k_idklienta_new<>0 AND _k_idklienta_old<>0) THEN -- Zmieniam z jednego na drugi , ale starego usuwam 
    DELETE FROM tr_technostpracy WHERE k_idklienta=_k_idklienta_old AND the_idelem=NEW.the_idelem AND tsp_flaga&(1<<4)=(1<<4);
   -- 1. Szukam nowego obiektu na liscie kooperantow
   _tsp_idstanowiska_new=(SELECT tsp_idstanowiska FROM tr_technostpracy WHERE k_idklienta=_k_idklienta_new AND the_idelem=NEW.the_idelem);
   IF (COALESCE(_tsp_idstanowiska_new,0)=0) THEN -- Nie ma jeszcze takiego na mojej liscie - dodaje go
    INSERT INTO tr_technostpracy(tsp_flaga,k_idklienta,the_idelem,tsp_tpz,tsp_tpj,tsp_wydajnosc,tsp_iloscosob,tsp_kosztnah,tsp_kosztnaj,tsp_kosztkooperacji,tsp_zaangazpracownika,tsp_koopczasreal) VALUES (23,_k_idklienta_new,NEW.the_idelem,NEW.the_tpz,NEW.the_tpj,NEW.the_wydajnosc,NEW.the_iloscosob,NEW.the_kosztnah,NEW.the_kosztnaj,NEW.the_kosztkooperacji,NEW.the_zaangazpracownika,NEW.the_koopczasreal);
   ELSE -- Mam juz tekiego, wiec tylko ustawiam go jako domyslnego
    UPDATE tr_technostpracy SET tsp_flaga=(tsp_flaga|2) WHERE tsp_idstanowiska=_tsp_idstanowiska_new;
   END IF;
  END IF;
  
 END IF; 
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
