CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 brutto numeric;
 zamknieta INT;
 vat_data RECORD;
 ilosc_data RECORD;
 flaga_cena0przymag INT:=0;
BEGIN

/*
 IF (OLD.tel_flaga&1048576=1048576) THEN
  RETURN OLD;
 END IF;

 ---Pobierz informacje o transakcji
 zamknieta=(SELECT tr_zamknieta FROM tg_transakcje WHERE tr_idtrans=OLD.tr_idtrans);

 IF ((zamknieta&(1<<22))=0) THEN

  ---Obliczamy ilosc wydana i niewydana by zaznaczyc czy dokument jest wydany czy nie z uwzglednieniem elementow ukrytych dla zestawu
  SELECT  nullZero(max(0,ceil(min(1,sum(abs(tel_iloscwyd)))))) AS ilosc
  INTO ilosc_data 
  FROM tg_transelem 
  WHERE tr_idtrans=OLD.tr_idtrans AND (tel_flaga&1024=0 OR tel_skojzestaw>0);

  ---Obliczamy dla przychodow na magazyn czy sa jakies pozycje z zerowa cena
  IF ((OLD.tel_newflaga&(1+4))=1) THEN
   --mam przychod magazynowy - wyliczam czy sa jakies z zerowa cena
   flaga_cena0przymag=(SELECT nullZero(min(1,sum(tel_idelem))) FROM tg_transelem WHERE tr_idtrans=OLD.tr_idtrans AND tel_cenawal=0 AND tel_flaga&1024=0);
  END IF;

   ---OBliczamy netto i vat
  SELECT * INTO vat_data FROM vatviews.kv_raport_vat WHERE tr_idtrans=OLD.tr_idtrans;


  ---Liczenie od netto, zrob update vatu i wartosci brutto
  UPDATE tg_transakcje SET 
   tr_wartosc=nullZero(vat_data.netto),
   tr_dozaplaty=nullZero(vat_data.brutto),
   tr_vat=nullZero(vat_data.vat),
   tr_flaga=CenyZeroFlaga(iloscPozycjiFlaga((tr_flaga&(~1024))|(ilosc_data.ilosc::int<<10),vat_data.l_pozycji),flaga_cena0przymag)
  WHERE 
   tr_idtrans=OLD.tr_idtrans AND 
   (
    (tr_wartosc<>nullZero(vat_data.netto)) OR 
    (tr_vat<>nullZero(vat_data.vat)) OR 
    (tr_dozaplaty<>nullZero(vat_data.brutto)) OR
    (tr_flaga<>CenyZeroFlaga(iloscPozycjiFlaga((tr_flaga&(~1024))|(ilosc_data.ilosc::int<<10),vat_data.l_pozycji),flaga_cena0przymag))
   );
 END IF;
*/
 
 --------CZESC TRIGEROW POD ZESTAWY
 --jezeli jestem zestawem to nawszelki wypadek kasuje elementy jesli jesze sa
 IF (OLD.tel_newflaga&256=256) THEN
   DELETE FROM tg_transelem WHERE tel_skojzestaw=OLD.tel_idelem;
 END IF;
 --przy kasowaniu elementu zestawu obnizamy koszt dla zestawu, dla towarow powiazanych nic nie robimy
 IF (OLD.tel_skojzestaw>0 AND (OLD.tel_flaga&1024)=1024) THEN
   UPDATE tg_transelem SET tel_kosztnabycia=NullZero(tel_kosztnabycia)-NullZero(OLD.tel_kosztnabycia) WHERE tel_idelem=OLD.tel_skojzestaw;
 END IF;
 -------KONIEC TRIGEROW POD ZESTAWY

 RETURN OLD;
END;
$$;
