CREATE FUNCTION oniudzlecenie() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 zmiana_prorytetow TEXT;
 _wherenew TEXT;
 _whereold TEXT;
 _query TEXT;
BEGIN
 IF (TG_OP='INSERT') THEN
 ---przy dodawaniu zlecenia jesli jest otwarte nadaje prorytet jako ostatni
  IF (((NEW.zl_status&14)=0 OR (NEW.zl_status&14)=2)) THEN
   ---jest wykonanie anulujemy prorytet
   SELECT podzialpriorytetowzlecen(NEW.zl_typ, NEW.fm_idcentrali, NEW.zl_rodzajimp, NEW.p_odpowiedzialny, NEW.dz_iddzialu) INTO _wherenew;
   _query := 'SELECT NullZero(max(zl_prorytet))+1 FROM tg_zlecenia WHERE ' || _wherenew;
   EXECUTE _query INTO NEW.zl_prorytet;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
   ---zmiany prac jesli zmieni sie obiekt pod zlecenia serwisowe
   IF (OLD.ob_idobiektu<>NEW.ob_idobiektu) THEN
     UPDATE tg_prace SET ob_idobiektu=NEW.ob_idobiektu WHERE zl_idzlecenia=NEW.zl_idzlecenia;
 NEW.rb_idrodzaju=(SELECT rb_idrodzaju FROM tg_obiekty AS ob WHERE ob.ob_idobiektu=NEW.ob_idobiektu);
   END IF;

   ---jesli zlecenie wykonujemy zlecenie lub anulujemy to kasuje sie prorytet
   IF (((OLD.zl_status&14)=0 OR (OLD.zl_status&14)=2) AND ((NEW.zl_status&14)!=0 AND (NEW.zl_status&14)!=2)) THEN
    ---pobieramy ustawienia programu odnosnie czy ma zmienic prorytet innym zleceniom automatycznie
    zmiana_prorytetow=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela='ZLEC_AUT_ZM_PROR'||NEW.zl_typ::text);
    IF (zmiana_prorytetow='1') THEN
     ---zmieniamy automatycznie innym prorytet
     SELECT podzialpriorytetowzlecen(NEW.zl_typ, NEW.fm_idcentrali, NEW.zl_rodzajimp, NEW.p_odpowiedzialny, NEW.dz_iddzialu) INTO _wherenew;
     _query := 'UPDATE tg_zlecenia SET zl_prorytet=zl_prorytet-1 WHERE ' || _wherenew || ' AND zl_prorytet>' || NEW.zl_prorytet;
     EXECUTE _query;
    END IF;
    ---jest wykonanie anulujemy prorytet
    NEW.zl_prorytet=NULL;
    ---oznaczamy plany zlecenia ze zlecenie jest zamkniete
    UPDATE tg_planzlecenia SET pz_flaga=pz_flaga|(1<<16) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
   ---przy otwarciu prorytet na koniec kolejki
   IF (((NEW.zl_status&14)=0 OR (NEW.zl_status&14)=2) AND ((OLD.zl_status&14)!=0 AND (OLD.zl_status&14)!=2)) THEN
    SELECT podzialpriorytetowzlecen(NEW.zl_typ, NEW.fm_idcentrali, NEW.zl_rodzajimp, NEW.p_odpowiedzialny, NEW.dz_iddzialu) INTO _wherenew;
    _query := 'SELECT NullZero(max(zl_prorytet))+1 FROM tg_zlecenia WHERE ' || _wherenew;
    EXECUTE _query INTO NEW.zl_prorytet;
    ---informacja na planie zlecenie ze zlecenie otwarte
    UPDATE tg_planzlecenia SET pz_flaga=pz_flaga&(~(1<<16)) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
 END IF;


 IF (TG_OP='DELETE') THEN 
  ---pobieramy ustawienia programu odnosnie czy ma zmienic prorytet innym zleceniom automatycznie
  IF ((OLD.zl_status&14)=0 OR (OLD.zl_status&14)=2) THEN
   ---zlecenie w edycji ma prorytet
   zmiana_prorytetow=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela='ZLEC_AUT_ZM_PROR'||OLD.zl_typ::text);
   IF (zmiana_prorytetow='1') THEN
    ---zmieniamy automatycznie innym prorytet
    SELECT podzialpriorytetowzlecen(OLD.zl_typ, OLD.fm_idcentrali, OLD.zl_rodzajimp, OLD.p_odpowiedzialny, OLD.dz_iddzialu) INTO _whereold;
    _query := 'UPDATE tg_zlecenia SET zl_prorytet=zl_prorytet-1 WHERE ' || _whereold || ' AND zl_prorytet>' || OLD.zl_prorytet;
    EXECUTE _query;
   END IF;
  END IF;
  return OLD;
 END IF;
 
 NEW.zl_narzutroboc=round((CASE WHEN NEW.zl_robociznanetto=0 THEN 0 ELSE (100 * (NEW.zl_robocizna - NEW.zl_robociznanetto) / NEW.zl_robociznanetto) END),2);
 
 RETURN NEW;
END;
$$;
