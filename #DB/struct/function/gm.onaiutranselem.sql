CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 brutto numeric;
 zamknieta INT;
 vat_data RECORD;
 ilosc_data RECORD;
 flaga_cena0przymag INT:=0;
 masknew INT:=0;
 flagnew INT:=0;
BEGIN

 IF (NEW.tel_flaga&1048576=1048576) THEN
  RETURN NEW;
 END IF;  

 ------------------------------------------------------------------------------------------------------
 IF ((NEW.tel_newflaga&(1<<28))<>0) AND (NEW.tel_newflaga&4=0) THEN
  --Inwentaryzacja po partii
  PERFORM dodajWskRez(NEW.tel_idelem,NEW.tel_iloscf);
 END IF;
 ------------------------------------------------------------------------------------------------------


 --------CZESC TRIGEROW POD ZESTAWY
 --jezeli jestem zestawem to nawszelki wypadek aktualizuje ilosc jesli sie zmienila, tylko dla rekordow ktore nie maja kopii
 IF (NEW.tel_newflaga&256=256 AND NEW.tel_flaga&32768=0) THEN
  IF (TG_OP='UPDATE') THEN
    ---gdy update to wowczas gdy sie zmienila ilosc
    IF (NEW.tel_iloscf<>OLD.tel_iloscf) OR 
       (NEW.tel_datazam IS DISTINCT FROM OLD.tel_datazam)
    THEN
     ---RAISE NOTICE '!!!!!!!!!! Uaktualniam ilosc % % ',NEW.tel_idelem,NEW.tel_iloscf;
     UPDATE tg_transelem 
	 SET tel_ilosc=NEW.tel_iloscf,
         
		 tel_datazam=NEW.tel_datazam
	 WHERE tel_skojzestaw=NEW.tel_idelem AND (((NEW.tel_new2flaga>>17)&15) IN (0,1,2));    --- Pomin rozmiarowke
    END IF;
  ELSE 
   UPDATE tg_transelem SET tel_ilosc=NEW.tel_iloscf WHERE tel_skojzestaw=NEW.tel_idelem AND (((NEW.tel_new2flaga>>17)&15) IN (0,1,2));
  END IF;
 END IF;
 --przy kasowaniu elementu zestawu obnizamy koszt dla zestawu
 IF (NEW.tel_skojzestaw>0 AND (NEW.tel_flaga&1024)=1024) THEN
  IF (TG_OP='UPDATE') THEN
    ---gdy update to wowczas gdy sie zmienila ilosc
    IF (NEW.tel_kosztnabycia<>OLD.tel_kosztnabycia) THEN
     UPDATE tg_transelem SET tel_kosztnabycia=NullZero(tel_kosztnabycia)-NullZero(OLD.tel_kosztnabycia)+NullZero(NEW.tel_kosztnabycia) WHERE tel_idelem=NEW.tel_skojzestaw;
    END IF;
  ELSE 
    UPDATE tg_transelem SET tel_kosztnabycia=NullZero(tel_kosztnabycia)+NullZero(NEW.tel_kosztnabycia) WHERE tel_idelem=NEW.tel_skojzestaw;
  END IF;
 END IF;
 -------KONIEC TRIGEROW POD ZESTAWY
 --korekta z automatycznymi cenami
 IF (NEW.tel_flaga&196608=196608) THEN
  UPDATE tg_transelem SET tel_cenawal=NEW.tel_cenawal,tel_cenabwal=NEW.tel_cenabwal WHERE tr_idtrans=NEW.tr_idtrans AND tel_skojarzony=NEW.tel_skojarzony AND tel_flaga&65536=0 AND ttw_idtowaru=NEW.ttw_idtowaru;
 END IF;


 --- Pobierz informacje o transakcji
 zamknieta=(SELECT tr_zamknieta FROM tg_transakcje WHERE tr_idtrans=NEW.tr_idtrans);

 ---Liczenie od netto
 IF (TG_OP='UPDATE') THEN

  IF ((NEW.tel_newflaga&(1<<28))=0) AND ((OLD.tel_newflaga&(1<<28))<>0) THEN
   --Inwentaryzacja po partii
   PERFORM dodajWskRez(NEW.tel_idelem,0);
  END IF;

 END IF;

 RETURN NEW;
END;
$$;
