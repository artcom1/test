CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 dstanm NUMERIC:=0;
 dmarzapln numeric:=0; --- Delta marzy
 dmarzaplno numeric :=0; --- Delta marzy OLD
 dkosztpln numeric :=0; --- Delta kosztu
 dkosztplno numeric :=0; --- Delta kosztu OLD
 z NUMERIC;
 w NUMERIC;
 k NUMERIC;
 tg_transakcja RECORD;
 towmag RECORD;
 towar RECORD;
 rodzaj INT;
 _ismmp BOOL:=FALSE;
 _ismmpf BOOL:=FALSE;
 _isodnetto BOOL:=TRUE;

 _nettopln NUMERIC:=0;
 _nettoplno NUMERIC:=0;

 tmp NUMERIC:=0;
 _record RECORD;
 _data DATE:=now();
 fm_idind INT;

 transpwgwagi BOOL:=FALSE;
 wagaelem NUMERIC:=0;
 sprzedaz_delta_ilosci NUMERIC:=0;
 zakup_delta_ilosci NUMERIC:=0;
 
 _doupdate BOOL:=TRUE;

 _wnettoplnds NUMERIC;
 
 rnew gm.DODAJ_REZERWACJE_TYPE; 
 pznew gm.DODAJ_PZ_TYPE;
  ---newdostawa gmd.newdostawa_type;
BEGIN

 IF (TG_OP = 'INSERT') THEN
  --- Brak id transakcji - zwroc od razu
  IF (NEW.tr_idtrans=NULL) THEN 
   RAISE EXCEPTION 'Nie podano ID Dokumentu';
  END IF;

  IF (NEW.tel_new2flaga&3=1) THEN
   NEW.tel_ilosc=nullZero((SELECT sum(tex_iloscf) FROM tg_teex WHERE tel_idelem=NEW.tel_idelem));
   NEW.tel_iloscfresttoex=0;
  END IF;
  IF (NEW.tel_new2flaga&3=2) THEN
   --Na razie na minusie - pozniej bedzie dodana iloscf tak by sie obliczylo poprawnie
   NEW.tel_iloscfresttoex=-nullZero((SELECT sum(tex_iloscf) FROM tg_teex WHERE tel_idelem=NEW.tel_idelem));
  END IF;

 END IF;
  
 IF (TG_OP='DELETE') THEN
  PERFORM vendo.setTParamI('TEDELETED_'||OLD.tel_idelem::text,1);
 END IF;

 IF (TG_OP <> 'DELETE') THEN
  IF (NEW.tel_new2flaga&3=0) THEN
   NEW.tel_iloscfresttoex=0;
  END IF;

  ---------------------------------------------------------------------------------------------
  ----kontrola poprawnosci ilosci z ojca dla zestawow (nie moze ona sie nam rozsynchronizowac)
  IF (TG_OP = 'INSERT' ) THEN
   IF (NEW.tel_skojzestaw>0) AND (((NEW.tel_new2flaga>>17)&15) IN (0,1,2)) THEN         --- Wykluczamy rozmiarowke
    NEW.tel_ilosc=(SELECT tel_ilosc FROM tg_transelem WHERE tel_idelem=NEW.tel_skojzestaw);
   END IF;
  ELSE
   IF (NEW.tel_skojzestaw>0) AND (NEW.tel_ilosc!=OLD.tel_ilosc) AND (((NEW.tel_new2flaga>>17)&15) IN (0,1,2)) THEN
    NEW.tel_ilosc=(SELECT tel_ilosc FROM tg_transelem WHERE tel_idelem=NEW.tel_skojzestaw);
   END IF;
  END IF;
   

  IF (NEW.tel_new2flaga&3=1) AND (NEW.tel_przelnilosci<>1000) THEN
   RAISE EXCEPTION 'Pozycja z podbijaniem nie moze miec przelicznika ilosci!';
  END IF;
  IF (NEW.tel_skojzestaw>0) AND (NEW.tel_new2flaga&3<>0) THEN
   --Rekord z TEEX
   RAISE EXCEPTION 'Ten element nie moze miec zestawu';
  END IF;

  ----koniec kontroli dla zestawow
  ---------------------------------------------------------------------------------------------

  --- STARTOF: Zmiana przez bit 16384 - pozostaw tak jak jest
  IF ((NEW.tel_flaga&16384::int4)<>0) THEN --- (IF2)
   NEW.tel_flaga=NEW.tel_flaga&(~16384);
   IF (TG_OP='INSERT') OR ((NEW.tel_flaga&2048)=0) THEN
    RETURN NEW;
   END IF;
  END IF; --- (OF IF2)
  --- ENDOF: Zmiana przez bit 16384

  --- STARTOF: Operacje na ilosci wydanej
  IF (TEisOpHandel(NEW.tel_newflaga) AND NOT TEisOpMagazyn(NEW.tel_newflaga)) THEN
   NEW.tel_iloscwyd=NEW.tel_iloscwyd-NEW.tel_ilosckomp;
   NEW.tel_ilosckomp=0;
  END IF;
  --- ENDOF: Operacje na ilosci wydanej

  --- STARTOF: Element jest naglowkiem sekcji - nie rob nic
  IF (NEW.tel_flaga&128<>0) THEN
   NEW.tel_sprzedaz=0;
   RETURN NEW;
  END IF;
   --- ENDOF: Element jest naglowkiem sekcji - nie rob nic

   --- Zaokraglij ilosc do 4 miejsc
   NEW.tel_ilosc=round(NEW.tel_ilosc,4);
   NEW.tel_iloscpotr=round(NEW.tel_iloscpotr,4);
   --- Zaokraglij przelicznik do 4 miejsc
   NEW.tel_przelnilosci=round(NEW.tel_przelnilosci,4);

   IF (TG_OP='UPDATE') THEN --- (IF3)
    --- STARTOF: Oblicz realizacje zamowienia lub PZAMa - operacja realizowana po to by mozna bylo na zamowieniu zmieniac ilosci (recznie) i by wszystko sie przeliczalo
    IF ((NEW.tel_flaga&8192)<>0) THEN --- (IF4)
     IF (NEW.tel_nadmiarzam>0) THEN --- Oblicz ilosc rzeczywista z uwzglednieniem nadmiaru na zamowieniu, czyli ilosc bedzie mniejsza od 0
      NEW.tel_ilosc=NEW.tel_ilosc-NEW.tel_nadmiarzam;
     END IF;
     IF (NEW.tel_nadmiarzam<0) THEN --- Jesli nadmiar zamowienia jest mniejszy od 0 (nie powinno tak byc w zasadzie?) to ilosc wtedy bedzie rowna 0
      NEW.tel_ilosc=0;
     ELSE
      IF (NEW.tel_ilosc<0) THEN  --- Ilosc jest mniejsza od 0 => Przenies nadwyzke z zamowienia na nadmiar
       NEW.tel_nadmiarzam=-NEW.tel_ilosc;
       NEW.tel_ilosc=0; --Ilosc bedzie rowna 0
      ELSE
       NEW.tel_nadmiarzam=0; -- Nadmiar zamowienia bedzie rowna 0
      END IF;
     END IF;
    END IF; --- (OF IF4)
    --- ENDOF: Oblicz realizacje zamowienia lub PZAM
   END IF; --- (OF IF3)

   --- Oblicz ilosc faktyczna
   NEW.tel_iloscf=round((NEW.tel_ilosc+NEW.tel_iloscpotr)*NEW.tel_przelnilosci/1000,4); 
   NEW.tel_iloscop=gm.filterIloscOp(round(NEW.tel_ilosc*NEW.tel_przelnilosci/NEW.tel_przelnopakow,4),NEW.tel_new2flaga);
   
   --- Oblicz ilosci ex
   IF (NEW.tel_new2flaga&3=2) THEN
    IF (TG_OP='UPDATE') THEN
     NEW.tel_iloscfresttoex=NEW.tel_iloscfresttoex+(NEW.tel_iloscf-OLD.tel_iloscf);
    END IF;
    IF (TG_OP='INSERT') THEN
     NEW.tel_iloscfresttoex=NEW.tel_iloscfresttoex+NEW.tel_iloscf;
    END IF;
   END IF;

   --- Zaokraglij cene w walucie
   NEW.tel_cenawal=round(NEW.tel_cenawal,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
   NEW.tel_cenabwal=round(NEW.tel_cenabwal,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));

   --- Pobierz dane z naglowka transakcji
   SELECT INTO tg_transakcja tr_zamknieta,tr_sprzedaz,tr_rodzaj,wl_idwaluty,tr_przelicznik,k_idklienta,tr_kosztkraj,tr_kosztzag,tr_wartosc,tr_datasprzedaz::date,tr_datawystaw::date,tr_oidklienta,tr_flaga, zl_idzlecenia, fm_idcentrali 
   FROM tg_transakcje WHERE tr_idtrans=NEW.tr_idtrans;
   
   --- Pobierz elementy z towmag
   SELECT INTO towmag ttw_idtowaru,tmg_idmagazynu, tmg_flaga 
   FROM tg_towmag JOIN tg_magazyny USING (tmg_idmagazynu) WHERE ttm_idtowmag=NEW.ttm_idtowmag;

   --- Pobierz elementy z towaru
   SELECT INTO towar ttw_flaga,ttw_usluga,ttw_sww
   FROM tg_towary WHERE ttw_idtowaru=towmag.ttw_idtowaru;
   
   --- STARTOF: Przepisz flage zamkniecia z naglowka transakcji
   IF ((tg_transakcja.tr_zamknieta&1)<>0) THEN  ----Zamknieta
    NEW.tel_flaga=NEW.tel_flaga|16;
   ELSE
    NEW.tel_flaga=NEW.tel_flaga&(~16);
   END IF;
   --- ENDOF: Przepisz flage zamkniecia z naglowka transakcji

   --- STARTOF: Synchronizuj kursy
   IF ((NEW.tel_new2flaga&(1<<3))=0) THEN
    NEW.tel_kursdok=tg_transakcja.tr_przelicznik;
   END IF;
   IF (tg_transakcja.wl_idwaluty=NEW.tel_walutawal) THEN
    NEW.tel_kurswal=NEW.tel_kursdok;
   END IF;
   IF (TG_OP='UPDATE') THEN
    IF (NEW.tel_kursdok<>OLD.tel_kursdok) OR (NEW.tel_kurswal<>OLD.tel_kurswal) THEN
     PERFORM vat.markneedvalidhead(NEW.tr_idtrans);
    END IF;
   END IF;
   --- ENDOF: Synchronizuj kursy
   
   --- Pobierz kierunek sprzedazy
   IF (NEW.tel_sprzedaz = -2) THEN
    NEW.tel_sprzedaz=tg_transakcja.tr_sprzedaz;
   END IF;
   --- ENDOF: Synchronizuj kierunek 

   --- Pobierz id towaru i czy jest usluga
   NEW.ttw_idtowaru=towmag.ttw_idtowaru;

   --- STARTOF: Liczenie cen
   IF (NEW.tel_flaga&(1<<26)!=0) THEN
   ---pozycjie z zaogklagleniem liczyczmy tylko podsumowanie
    NEW.tel_cenadok=cenaWal2Dok(NEW.tel_cenawal,NEW.tel_kurswal,NEW.tel_kursdok,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
    NEW.tel_cenabdok=cenaWal2Dok(NEW.tel_cenabwal,NEW.tel_kurswal,NEW.tel_kursdok,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
    NEW.tel_wnettodok=round(NEW.tel_cenadok*NEW.tel_ilosc,2);
    NEW.tel_wnettowal=round(NEW.tel_cenawal*NEW.tel_ilosc,2);
    _nettopln=cenaWal2Dok(NEW.tel_wnettodok,NEW.tel_kursdok,1,2);
   ELSE 
    ---normalna pozycja 
    --- STARTOF: Liczenie cen netto/brutto dok/wal
    IF (NEW.tel_newflaga&(1<<23)=0) THEN ------ Wartosc liczona z ceny*ilosc
     IF ((tg_transakcja.tr_zamknieta&128)=0) THEN  --- Dokument od netto
      NEW.tel_cenabwal=round(Net2Brt(NEW.tel_cenawal,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_cenadok=cenaWal2Dok(NEW.tel_cenawal,NEW.tel_kurswal,NEW.tel_kursdok,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_cenabdok=round(Net2Brt(NEW.tel_cenadok,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_wnettodok=round(NEW.tel_cenadok*NEW.tel_ilosc,2);
      NEW.tel_wnettowal=round(NEW.tel_cenawal*NEW.tel_ilosc,2);
      _nettopln=cenaWal2Dok(NEW.tel_wnettodok,NEW.tel_kursdok,1,2);
      NEW.tel_flaga=NEW.tel_flaga&(~32);
     ELSE
    _isodnetto=FALSE;
      NEW.tel_cenawal=round(Brt2Net(NEW.tel_cenabwal,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_cenabdok=cenaWal2Dok(NEW.tel_cenabwal,NEW.tel_kurswal,NEW.tel_kursdok,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_cenadok=round(Brt2Net(NEW.tel_cenabdok,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_wnettodok=round(NEW.tel_cenabdok*NEW.tel_ilosc, 2);
      NEW.tel_wnettodok=NEW.tel_wnettodok-round(vatfrombrt(NEW.tel_wnettodok, NEW.tel_stvat::numeric), 2);
      NEW.tel_wnettowal=round(NEW.tel_cenabwal*NEW.tel_ilosc, 2);
      _nettopln=cenaWal2Dok(NEW.tel_wnettowal,NEW.tel_kursdok,1,2);                     --- Wartosc brutto w PLN
      NEW.tel_wnettowal=NEW.tel_wnettowal-round(vatfrombrt(NEW.tel_wnettowal, NEW.tel_stvat::numeric), 2);
      _nettopln=_nettopln-round(vatfrombrt(_nettopln, NEW.tel_stvat::numeric),2);              --- Wartosc netto=brutto-vat w PLN
      NEW.tel_flaga=NEW.tel_flaga|32;
     END IF;
    ELSE ---- Ceny liczone z wartosci
     NEW.tel_wnettodok=cenaWal2Dok(NEW.tel_wnettowal,NEW.tel_kurswal,NEW.tel_kursdok,2);

     --- Obliczenie wartosci faktyczniej
     IF (NEW.tel_ilosc<>0) THEN
      NEW.tel_cenawal=round(NEW.tel_wnettowal/NEW.tel_ilosc,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_cenadok=round(NEW.tel_wnettodok/NEW.tel_ilosc,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
     ELSE
      NEW.tel_cenawal=0;
      NEW.tel_cenadok=0;
     END IF;
     --- Obliczenie ceny jednostkowej
     NEW.tel_cenabdok=round(Net2Brt(NEW.tel_cenadok,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
     NEW.tel_cenabwal=round(Net2Brt(NEW.tel_cenawal,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
     IF ((tg_transakcja.tr_zamknieta&128)=0) THEN  --- Dokument od netto
      _nettopln=cenaWal2Dok(NEW.tel_wnettodok,NEW.tel_kursdok,1,2);
      NEW.tel_flaga=NEW.tel_flaga&(~32);
     ELSE
      _isodnetto=FALSE;
      tmp=round(NEW.tel_cenabwal*NEW.tel_ilosc, 2);
      _nettopln=cenaWal2Dok(tmp,NEW.tel_kursdok,1,2);                                     --- Wartosc brutto w PLN
      tmp=tmp-round(vatfrombrt(tmp, NEW.tel_stvat::numeric), 2);
      _nettopln=_nettopln-round(vatfrombrt(_nettopln, NEW.tel_stvat::numeric),2);              --- Wartosc netto=brutto-vat w PLN
      NEW.tel_flaga=NEW.tel_flaga|32;
     END IF;
    END IF;
    --- ENDOF: Liczenie cen netto/brutto dok/wal
   END IF;
   ---ENDOF: Liczenie cen

   --- STARTOF: Przenoszenie bitow netto/brutto
   NEW.tel_flaga=NEW.tel_flaga&(~2097184); --- Wyczysc bity netto/brutto
   NEW.tel_flaga=NEW.tel_flaga|(((tg_transakcja.tr_zamknieta>>7)&1)<<5); --- Bit brutto
   NEW.tel_flaga=NEW.tel_flaga|(((tg_transakcja.tr_zamknieta>>17)&1)<<21); --- Bit sumy
   --- ENDOF: Przenoszenie bitow netto/brutto

   --- STARTOF: Przeniesienie id klienta
   NEW.tel_idklienta=tg_transakcja.k_idklienta;
   NEW.tel_oidklienta=tg_transakcja.tr_oidklienta;
   --- ENDOF: Przeniesienie id klienta

   _ismmp=((NEW.tel_newflaga&(1<<27))<>0);
   _ismmpf=_ismmp AND ((NEW.tel_flaga&(1<<17))<>0);
  END IF; --- (OF IF1)

 IF (TG_OP = 'INSERT') THEN
  IF (NEW.tel_flaga&4096)<>0 THEN RETURN NEW; END IF;
 END IF;

  --- STARTOF: Sprawdzanie przy update niedozwolonych zmian
 IF (TG_OP = 'UPDATE') THEN

  IF (OLD.ttm_idtowmag<>NEW.ttm_idtowmag) THEN
   RAISE EXCEPTION 'Nie mozna w ten sposob zmieniac towaru lub magazynu';
  END IF;
  IF ((OLD.tel_flaga&2048)<>(NEW.tel_flaga&2048)) THEN
   RAISE EXCEPTION 'Nie mozna wykonac tej operacji - zmiany TK<->inny rodzaj';
  END IF;

  --- STARTOF: Element powstal przez skopiowanie - pomin go zawsze
  IF (NEW.tel_flaga&4096)<>0 THEN RETURN NEW; END IF;
  --- ENDOF: Eelemnt powstal przez skopiowanie - pomin go zawsze

  --- STARTOF: Blokada PZ - inicjacja
  IF (NEW.tel_sprzedaz=1) AND (OLD.tel_sprzedaz=0) AND (NEW.tel_flaga&256=256) THEN
   NEW.tel_iloscdorezerwacji=NEW.tel_iloscf;
  END IF;
   --- ENDOF: Blokada PZ - inicjacja

 END IF;
 --- ENDOF: Sprawdzanie przy update niedozwolonych zmian


  --- Operacja DELETE
 IF (TG_OP = 'DELETE') THEN -- (IF6)

  --- STARTOF: Kopia lub NULL lub naglowek sekcji
  IF ((OLD.tel_flaga&4096)<>0) OR (OLD.tr_idtrans=NULL) OR (OLD.tel_flaga&128<>0) THEN 
   RETURN OLD; 
  END IF;
  --- ENDOF: Kopia lub NULL lub naglowek sekcji

  --- STARTOF: Pobierz dane z naglowka transakcji
  SELECT INTO tg_transakcja tr_zamknieta,tr_sprzedaz,tr_rodzaj,wl_idwaluty,tr_przelicznik,k_idklienta,tr_kosztkraj,tr_kosztzag,tr_wartosc,tr_datasprzedaz::date
  FROM tg_transakcje WHERE tr_idtrans=OLD.tr_idtrans;
  --- Pobierz elementy z towmag
  SELECT INTO towmag ttw_idtowaru,tmg_idmagazynu, tmg_flaga 
  FROM tg_towmag JOIN tg_magazyny USING (tmg_idmagazynu) WHERE ttm_idtowmag=OLD.ttm_idtowmag;
  --- Pobierz elementy z towaru
  SELECT INTO towar ttw_flaga,ttw_usluga,ttw_sww
  FROM tg_towary WHERE ttw_idtowaru=towmag.ttw_idtowaru;
  --- ENDOF: Pobierz dane z naglowka transakcji

  _ismmp=((OLD.tel_newflaga&(1<<27))<>0);
  _ismmpf=_ismmp AND ((OLD.tel_flaga&(1<<17))<>0);
 END IF; --- (OF IF6)

  --- STARTOF: Pobierz rodzaj transakcji
  rodzaj=tg_transakcja.tr_rodzaj;
  _ismmp=_ismmp OR (rodzaj=8);
  _ismmpf=_ismmpf OR (rodzaj=8);
  --- ENDOF: Pobierz rodzaj transakcji

  --- STARTOF: Operacja INSERT po podstawowych sprawdzeniach
  IF (TG_OP = 'INSERT') THEN --- (IF7)
   --- Przenies informacje o tym czy towar jest kosztem czy nie
   NEW.tel_flaga=NEW.tel_flaga|(((towar.ttw_flaga&4)<<1)|((towar.ttw_flaga&16)<<7));
   --- Dla TK ustaw VAT na zwolniony
   -- Oznacz czy to usluga (lub koszt posrednio) czy nie 
   IF (towar.ttw_usluga = TRUE) THEN
    NEW.tel_flaga=NEW.tel_flaga|4;
   ELSE 
    NEW.tel_flaga=NEW.tel_flaga&(~4);
   END IF;
  END IF; --- (OF IF7)
  --- ENDOF: Operacja INSERT po podstawowych sprawdzeniach

  --------------------------------------------------------------------------------------------------------------------------------------------------
  --- STARTOF: Liczenie wartosci netto PLN dla OLD
  --------------------------------------------------------------------------------------------------------------------------------------------------
  IF (TG_OP<>'INSERT') THEN
   IF ((OLD.tel_flaga&32)=0) THEN  --- Dokument od netto
    _nettoplno=cenaWal2Dok(OLD.tel_wnettodok,OLD.tel_kursdok,1,2);
   ELSE
    tmp=round(OLD.tel_cenabwal*OLD.tel_ilosc, 2);
    _nettoplno=cenaWal2Dok(tmp,OLD.tel_kursdok,1,2);                                     --- Wartosc brutto w PLN
    tmp=tmp-round(vatfrombrt(tmp, OLD.tel_stvat::numeric), 2);
    _nettoplno=_nettoplno-round(vatfrombrt(_nettoplno, OLD.tel_stvat::numeric),2);              --- Wartosc netto=brutto-vat w PLN
   END IF;
  END IF;
  --------------------------------------------------------------------------------------------------------------------------------------------------
  --- ENDOF: Liczenie wartosci netto PLN dla OLD
  --------------------------------------------------------------------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------------------------------------------------------------------------
  --- STARTOF: Liczenie cen DS
  --------------------------------------------------------------------------------------------------------------------------------------------------
  IF (TG_OP!='DELETE') THEN
   
   CASE ((NEW.tel_new2flaga>>6)&7)
    WHEN 0 THEN
 CASE NEW.tel_walutads
  WHEN NULL THEN
  WHEN NEW.tel_walutawal THEN
    _wnettoplnds=cenaWal2Dok(round((NEW.tel_ilosc-NEW.tel_iloscpkor)*NEW.tel_cenanettods,2),NEW.tel_kurswal,1,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
  WHEN tg_transakcja.wl_idwaluty THEN
    _wnettoplnds=cenaWal2Dok(round((NEW.tel_ilosc-NEW.tel_iloscpkor)*NEW.tel_cenanettods,2),NEW.tel_kurswal,1,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));  
  ELSE
    _wnettoplnds=cenaWal2Dok(round((NEW.tel_ilosc-NEW.tel_iloscpkor)*NEW.tel_cenanettods,2),getkursdladokumentu(NEW.tr_idtrans,NEW.tel_walutads),1,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));    
  END CASE;
    WHEN 1 THEN  --- Cena WAL
 NEW.tel_cenanettods=NEW.tel_cenawal;
 NEW.tel_walutads=NEW.tel_walutawal;
 _wnettoplnds=cenaWal2Dok(round((NEW.tel_ilosc-NEW.tel_iloscpkor)*NEW.tel_cenanettods,2),NEW.tel_kurswal,1,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
    WHEN 2 THEN  --- Cena DOK
 NEW.tel_cenanettods=NEW.tel_cenadok;
 NEW.tel_walutads=tg_transakcja.wl_idwaluty;
 _wnettoplnds=cenaWal2Dok(round((NEW.tel_ilosc-NEW.tel_iloscpkor)*NEW.tel_cenanettods,2),NEW.tel_kursdok,1,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
    WHEN 3 THEN  --- Cena 0
     NEW.tel_cenanettods=(CASE WHEN (_isodnetto=TRUE) THEN NEW.tel_cena0 ELSE round(Brt2Net(NEW.tel_cena0,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags)) END);
 NEW.tel_walutads=NEW.tel_walutawal;
 _wnettoplnds=cenaWal2Dok(round((NEW.tel_ilosc-NEW.tel_iloscpkor)*NEW.tel_cenanettods,2),NEW.tel_kurswal,1,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
   END CASE;
   
   CASE ((NEW.tel_new3flaga>>0)&7)
    WHEN 0 THEN
    WHEN 1 THEN  --- Cena WAL
     NEW.tel_cenanettoto=NEW.tel_cenawal;
     NEW.tel_walutato=NEW.tel_walutawal;
    WHEN 2 THEN  --- Cena DOK
     NEW.tel_cenanettoto=NEW.tel_cenadok;
     NEW.tel_walutato=tg_transakcja.wl_idwaluty;
    WHEN 3 THEN  --- Cena 0
     NEW.tel_cenanettoto=(CASE WHEN (_isodnetto=TRUE) THEN NEW.tel_cena0 ELSE round(Brt2Net(NEW.tel_cena0,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags)) END);
     NEW.tel_walutato=NEW.tel_walutato;
   END CASE;
  END IF;
  --------------------------------------------------------------------------------------------------------------------------------------------------
  --- ENDOF: Liczenie cen DS
  --------------------------------------------------------------------------------------------------------------------------------------------------

  -----Operacje na transakcjach --- zostawimy to na pozniej
 IF (TG_OP<>'INSERT') THEN --- (IFUD)

  IF (TEisOpHandel(OLD.tel_newflaga) AND NOT TEisOpMagazyn(OLD.tel_newflaga)) THEN
   OLD.tel_iloscwyd=OLD.tel_iloscwyd-OLD.tel_ilosckomp;
   OLD.tel_ilosckomp=0;
  END IF;

  IF (TEisOpMagazyn(OLD.tel_newflaga)) AND NOT (TEisUsluga(OLD.tel_flaga) AND ((OLD.tel_flaga&1024)=0)) THEN --- (IFPZO) Operacja magazynowa czyli rodzaj WZ
   IF (TEisPrzychod(OLD.tel_newflaga)) THEN
    IF (OLD.tel_ilosc<0) THEN  --- KPZ
     IF (TG_OP='DELETE') THEN
      PERFORM gm.dodaj_kpz(0,OLD.tel_idelem,OLD.tr_idtrans,OLD.ttw_idtowaru,OLD.ttm_idtowmag,towmag.tmg_idmagazynu,tg_transakcja.k_idklienta,NULL,OLD.tel_skojarzony,0,OLD.prt_idpartii);
      UPDATE tg_ruchy SET rc_flaga=rc_flaga&(~2048) WHERE tel_idelem=OLD.tel_skojarzony AND isBlockedPZ(rc_flaga);
      DELETE FROM tg_ruchy WHERE RCisRezerwacjaA(rc_flaga) AND tel_idelem=OLD.tel_idelem;
     END IF;
    ELSE
     IF ((OLD.tel_flaga&65536)<>0) AND (TG_OP='DELETE') THEN --3 KPZPlus
      PERFORM gm.clear_kpzplus(OLD.tel_idelem);
     ELSE --3
      IF (NOT TEisUsluga(OLD.tel_flaga&4) AND (TG_OP='DELETE')) THEN --2
       IF (_ismmp=TRUE) THEN --1
       ELSE
        PERFORM gm.clear_pz(OLD.tel_idelem);
       END IF; --1
      END IF; --2
     END IF;
    END IF;
   ELSE ---Rozchod (czyli operacje dla WZ)    
    IF (TG_OP='DELETE') THEN
     IF (OLD.tel_iloscf>OLD.tel_iloscpkor) THEN
      PERFORM gm.clear_wz(OLD.tel_idelem);
     ELSE
      IF (nullZero(OLD.tel_skojarzony)<0) THEN ---Korekta do nieistniejacego dokumentu
       PERFORM gm.clear_pz(OLD.tel_idelem);
      ELSE
       PERFORM gm.dodaj_nkwz(0,OLD.tel_idelem,OLD.tr_idtrans,OLD.ttw_idtowaru,OLD.ttm_idtowmag,towmag.tmg_idmagazynu,tg_transakcja.k_idklienta,tg_transakcja.tr_datasprzedaz,OLD.tel_skojarzony);
      END IF;
      --- Nowy rodzaj korekty
     END IF;
    ELSE ---Operacja update
     --- Sprawdz czy wczesniej nie bylo to korekta na minus
     IF (OLD.tel_iloscf<=OLD.tel_iloscpkor) AND (NEW.tel_iloscf>NEW.tel_iloscpkor) THEN
      --- Bylo, w takim razie usun wszystkie ruchy korekty na minus
      IF (nullZero(OLD.tel_skojarzony)<0) THEN ---Korekta do nieistniejacego dokumentu
       PERFORM gm.clear_pz(OLD.tel_idelem);
      ELSE
       PERFORM gm.dodaj_nkwz(0,OLD.tel_idelem,OLD.tr_idtrans,OLD.ttw_idtowaru,OLD.ttm_idtowmag,towmag.tmg_idmagazynu,tg_transakcja.k_idklienta,tg_transakcja.tr_datasprzedaz,OLD.tel_skojarzony);
      END IF;
     END IF;
    END IF;
   END IF;

  ELSE ---- Dla operacji handlowej
   
  END IF; --- (OF IFPZO)

  dkosztplno=-OLD.tel_koszt;

  IF (NOT TEisUsluga(OLD.tel_flaga) ) THEN
   IF (TEisOpHandel(OLD.tel_newflaga)) AND (TEisOpMagazyn(OLD.tel_newflaga)) THEN
    dmarzaplno=-(_nettoplno-OLD.tel_koszt);
   ELSE
    --Jesli jest operacja handlowa lub (magazynowa i nie ma skojarzenia to przenies marze z przeniesienia
    IF (COALESCE(OLD.tel_skojlog,0)=0) AND (COALESCE(OLD.tel_skojarzony,0)=0) OR (TEisOpHandel(OLD.tel_newflaga)) THEN
     dmarzaplno=-(_nettoplno-OLD.tel_koszt);
    END IF;
   END IF;
  ELSE
   IF (TEisOpHandel(OLD.tel_newflaga)) THEN
    dmarzaplno=-(_nettoplno-OLD.tel_kosztnabycia);
   END IF;
  END IF;

  IF (TG_OP='DELETE') AND (_ismmp=FALSE) THEN
---   PERFORM updateKosztiIlosc(OLD.tel_skojarzony,NULL,OLD.tel_skojlog,NULL,OLD.tel_iloscwyd,0,OLD.tel_kosztnabycia,0,OLD.tel_newflaga);
   IF (TEisOpHandel(OLD.tel_newflaga)) AND (NOT TEisOpMagazyn(OLD.tel_newflaga)) AND (NOT TEisUsluga(OLD.tel_flaga)) AND (TG_OP='DELETE') THEN
    IF (abs(OLD.tel_iloscwyd+OLD.tel_ilosckomp)<>abs(OLD.tel_iloscf-OLD.tel_iloscpkor)) AND (OLD.tel_iloscf>0) THEN
     RAISE EXCEPTION 'Nie mozna usuwac tranelemu czesciowo wydanego';
    END IF;
   END IF;
   IF TEisRozchod(OLD.tel_newflaga) AND (NOT TEisUsluga(OLD.tel_flaga)) AND ((OLD.tel_newflaga&8)=0) THEN --- (IFPR) Rozchod
    PERFORM gm.clear_rezerwacje(OLD.tel_idelem,OLD.ttm_idtowmag);
   END IF;
  END IF;

 END IF; --- (OF IFUD)


---Operacja INSERT lub UPDATE

IF (TG_OP='INSERT') OR (TG_OP='UPDATE') THEN --- (IFIU)

 IF (TEisOpMagazyn(NEW.tel_newflaga) AND TEisPseudoTowar(NEW.tel_new2flaga) AND (NEW.tel_flaga&1024=0)) THEN
  IF (TEisPrzychod(NEW.tel_newflaga)) THEN --- (IFPR) Przychod
   NEW.tel_wartosczakupu=_nettopln;   
  END IF; 
  IF (TEisRozchod(NEW.tel_newflaga)) THEN
   IF (TG_OP='UPDATE') THEN
    NEW.tel_wartosczakupu=gm.ptowar_dodajwz(NEW.ttm_idtowmag,OLD.tel_iloscf,OLD.tel_wartosczakupu,OLD.tel_sprzedaz,NEW.tel_iloscf,NEW.tel_sprzedaz,(CASE WHEN NEW.tel_new3flaga&(1<<3)!=0 THEN NEW.tel_wartosczakupu ELSE NULL END));
   ELSE
    NEW.tel_wartosczakupu=gm.ptowar_dodajwz(NEW.ttm_idtowmag,NULL,NULL,0,NEW.tel_iloscf,NEW.tel_sprzedaz,NULL);
   END IF;
   NEW.tel_new3flaga=NEW.tel_new3flaga&(~(1<<3));
  END IF;
 ELSIF (TEisOpMagazyn(NEW.tel_newflaga)) AND NOT (TEisUsluga(NEW.tel_flaga) AND ((NEW.tel_flaga&1024)=0)) THEN --- (IFPZ) Operacja magazynowa czyli rodzaj WZ

  IF (TEisPrzychod(NEW.tel_newflaga)) THEN --- (IFPR) Przychod

   NEW.tel_wartosczakupu=_nettopln;
   
   ----Wartosc zakupu z ceny CRZ
   IF ((NEW.tel_new2flaga&(1<<28))!=0) THEN
    IF (COALESCE(NEW.tel_walutato,1)!=1) THEN
     RAISE EXCEPTION 'Cena TO moze byc tylko w PLN!';
    END IF;
    NEW.tel_wartosczakupu=COALESCE(NEW.tel_cenanettoto,0)*NEW.tel_ilosc;
   END IF;
   
    -- Licz narzut
   IF ((tg_transakcja.tr_flaga&(512|128))=128) AND (NEW.tel_flaga&1028=0) THEN --- (IFNRZ)
    z=round(tg_transakcja.tr_kosztzag,2);
    k=round(tg_transakcja.tr_kosztkraj,2);
    IF (z=0) AND (k=0) AND ((NEW.tel_clo=0) OR (NEW.tel_skojarzony IS NOT NULL)) THEN
     IF (NEW.tel_skojarzony IS NULL) THEN
      NEW.tel_narzut=0;
     ELSE
      NEW.tel_narzut=nullZero(NEW.tel_narzut);
     END IF;
     IF (NEW.tel_clo=0) THEN
      NEW.tel_wartoscclo=0;
     END IF;
    ELSE
     IF (NEW.tel_skojarzony IS NOT NULL) THEN
      NEW.tel_narzut=nullZero((SELECT -tel_narzut FROM tg_transelem WHERE (tel_idelem<>NEW.tel_idelem) AND (tel_idelem=NEW.tel_skojarzony OR (tel_flaga&65536=65536 AND tel_skojarzony=NEW.tel_skojarzony)) AND tel_ilosc>0 ORDER BY tel_idelem DESC LIMIT 1));
     ELSE
      IF ((tg_transakcja.tr_zamknieta&(1<<24))<>0) THEN
       transpwgwagi=TRUE;
      END IF;
      IF (transpwgwagi=FALSE) THEN
       wagaelem=NEW.tel_wnettowal;
       w=wagaelem+nullZero((SELECT sum(tel_wnettowal) FROM tg_transelem WHERE tr_idtrans=NEW.tr_idtrans AND tel_flaga&1028=0 AND tel_idelem<>NEW.tel_idelem));
      ELSE
       --Wg wagi
       wagaelem=(SELECT round(NEW.tel_iloscf*ttw_waga,2) FROM tg_towary WHERE ttw_idtowaru=NEW.ttw_idtowaru);
       w=wagaelem+nullZero((SELECT sum(round(tel_iloscf*ttw_waga,2)) FROM tg_transelem JOIN tg_towary USING (ttw_idtowaru) WHERE tr_idtrans=NEW.tr_idtrans AND tel_flaga&1028=0 AND tel_idelem<>NEW.tel_idelem));
      END IF;
      ---Oblicz proporcje
      IF (w=0) THEN
       NEW.tel_narzut=0;
      ELSE
       NEW.tel_narzut=round(round(wagaelem/w,4)*z*NEW.tel_kursdok,6);
      END IF;
      IF ((NEW.tel_newflaga&(1<<25))=0) THEN
       NEW.tel_wartoscclo=round((NEW.tel_wnettowal*NEW.tel_kursdok+NEW.tel_narzut)*NEW.tel_clo/100,1);
      ELSE
       NEW.tel_wartoscclo=round(NEW.tel_kursdok*NEW.tel_clo,1);
      END IF;
      NEW.tel_narzut=round(NEW.tel_narzut+NEW.tel_wartoscclo,2);
      IF (w<>0) THEN
       NEW.tel_narzut=round(NEW.tel_narzut+(wagaelem/w)*k*NEW.tel_kursdok,2);
      END IF;
      END IF;
    END IF;
   ELSE
   --- NEW.tel_narzut=0; 
    NEW.tel_wartoscclo=0;
   END IF; --- (OF IFNRZ)
   
   IF (gm.isTEOdwrocona(NEW.tel_new2flaga)=TRUE) THEN
    NEW.tel_wartosczakupu=-NEW.tel_wartosczakupu;
   END IF;
   
   IF (NEW.tel_iloscf<>0) THEN
    NEW.tel_zaokraglenia=getZaokraglenia(NEW.tel_iloscf,NEW.tel_wartosczakupu,NEW.tel_narzut);
    NEW.tel_narzut=NEW.tel_narzut-NEW.tel_zaokraglenia;
   ELSE
    NEW.tel_wartosczakupu=0;
    NEW.tel_zaokraglenia=0;
   END IF;

   IF (NEW.tel_sprzedaz>0) THEN -- (IFTSWO)
    IF (NEW.tel_iloscpkor=0 AND NEW.tel_iloscf>=0) THEN
     IF (_ismmp=TRUE) THEN --1
      NEW.tel_wartosczakupu=gm.dodaj_mm(NEW.tel_idelem,
                                        NEW.tr_idtrans,
                                        NEW.ttm_idtowmag,
                                        towmag.tmg_idmagazynu,
                                        tg_transakcja.tr_datasprzedaz,
                                        NEW.tel_skojarzony,
                                        FALSE,
                                        (CASE WHEN _ismmpf=FALSE THEN round(NEW.tel_wnettodok*NEW.tel_kursdok,2) ELSE NULL END)::numeric,
                                        (CASE WHEN NEW.tel_new2flaga&4=4 THEN NEW.prt_idpartii ELSE NULL END));
                                        ---RAISE NOTICE 'Jest % %',NEW.tel_wartosczakupu,NEW.tel_skojarzony;
     ELSE
      IF (NOT TEisBlockedRuchy(NEW.tel_newflaga)) THEN
       pznew=NULL;
       pznew.tel_iloscf=NEW.tel_iloscf;
       pznew.tel_idelem=NEW.tel_idelem;
       pznew.tr_idtrans=NEW.tr_idtrans;
       pznew.ttw_idtowaru=NEW.ttw_idtowaru;
       pznew.ttm_idtowmag=NEW.ttm_idtowmag;
       pznew.tmg_idmagazynu=towmag.tmg_idmagazynu;
       pznew.k_idklienta=tg_transakcja.k_idklienta;
       pznew.rc_data=tg_transakcja.tr_datasprzedaz;
       pznew.tel_wartosc=NEW.tel_wartosczakupu+NEW.tel_narzut;
       pznew.tel_iloscrez=NEW.tel_iloscdorezerwacji;
       pznew._isapz=FALSE; 
       pznew.prt_idpartii=NEW.prt_idpartii; 
       pznew.rc_cenajmcrs=vendo.safeDiv(_wnettoplnds,NEW.tel_iloscf,NULL,4);
       pznew._iskonsygnata=gm.isTEKonsygnaty(NEW.tel_new2flaga);
       pznew._istransodwrocona=gm.isTEOdwrocona(NEW.tel_new2flaga);
       PERFORM gm.dodaj_pz(pznew,FALSE);
      END IF;
     END IF;
    ELSE
     IF ((NEW.tel_flaga&16)=16) THEN --4
      IF (NEW.tel_iloscf<0) THEN
       PERFORM gm.dodaj_kpz(-NEW.tel_iloscf,NEW.tel_idelem,NEW.tr_idtrans,NEW.ttw_idtowaru,NEW.ttm_idtowmag,towmag.tmg_idmagazynu,tg_transakcja.k_idklienta,tg_transakcja.tr_datasprzedaz,NEW.tel_skojarzony,-(NEW.tel_wartosczakupu+NEW.tel_narzut),NEW.prt_idpartii);
      ELSE
       NEW.tel_wartosczakupu=gm.dodaj_kpzplus(NEW.tel_iloscf,NEW.tel_idelem,NEW.tr_idtrans,NEW.ttw_idtowaru,NEW.ttm_idtowmag,towmag.tmg_idmagazynu,tg_transakcja.k_idklienta,tg_transakcja.tr_datasprzedaz,NEW.tel_skojarzony,NEW.tel_flaga&16,NEW.tel_wartosczakupu+NEW.tel_narzut,NEW.prt_idpartii)-NEW.tel_narzut;
      END IF;
      NEW.tel_zaokraglenia=0;
     END IF; --4
    END IF;
   END IF; --- (OF IFTSWO)

   --- STARTOF: Zablokuj partie dla korekt plusowych
   IF (NEW.tel_ilosc<0) THEN  
    IF (((NEW.tel_flaga&16)<>0)) THEN -- Dokument zamkniety
     UPDATE tg_ruchy SET rc_flaga=rc_flaga&(~2048) WHERE tel_idelem=NEW.tel_skojarzony AND isBlockedPZ(rc_flaga);
     DELETE FROM tg_ruchy WHERE RCisRezerwacjaA(rc_flaga) AND tel_idelem=NEW.tel_idelem;
    ELSE --- Dokument otwarty
     UPDATE tg_ruchy SET rc_flaga=rc_flaga|2048 WHERE tel_idelem=NEW.tel_skojarzony AND NOT isBlockedPZ(rc_flaga) AND isPZet(rc_flaga);
     PERFORM dodaj_rezerwacjeA_partia(NEW.tel_idelem,NEW.tel_skojarzony,NEW.tr_idtrans,NEW.ttm_idtowmag);
    END IF;
   END IF;
   --- ENDOF: Zablokuj partie dla korekt plusowych

  ELSE

   IF (TEisRozchod(NEW.tel_newflaga) AND (NEW.tel_sprzedaz<>0)) THEN --- (IFPR) Rozchod
    --Normalny dokument rozchodu magazynowego
    IF (NEW.tel_iloscf>NEW.tel_iloscpkor) THEN
     --Wartosc zakupu
     NEW.tel_wartosczakupu=gm.dodaj_wz(NEW.tel_iloscf-NEW.tel_iloscpkor,NEW.tel_idelem,NEW.tr_idtrans,NEW.ttw_idtowaru,NEW.ttm_idtowmag,towmag.tmg_idmagazynu,tg_transakcja.k_idklienta,tg_transakcja.tr_datasprzedaz,NEW.tel_skojlog,NEW.tel_oidklienta,(NEW.tel_newflaga&16)=16,NEW.tel_skojzam,NEW.prt_idpartii,(NEW.tel_new2flaga&3)|(NEW.tel_flaga&16));
    ELSE
     ---Dodaj nowy rodzaj KWZ
     IF (NEW.tel_flaga&65536=65536) THEN
      IF (nullZero(NEW.tel_skojarzony)<0) THEN ---Korekta do nieistniejacego dokumentu
       NEW.tel_zaokraglenia=getZaokraglenia(NEW.tel_iloscf-NEW.tel_iloscpkor,NEW.tel_wartosczakupu,NEW.tel_narzut);
       NEW.tel_wartosczakupu=NEW.tel_wartosczakupu-NEW.tel_zaokraglenia;
       IF (NOT TEisBlockedRuchy(NEW.tel_newflaga)) THEN
      pznew=NULL;
        pznew.tel_iloscf=-(NEW.tel_iloscf-NEW.tel_iloscpkor);
        pznew.tel_idelem=NEW.tel_idelem;
        pznew.tr_idtrans=NEW.tr_idtrans;
        pznew.ttw_idtowaru=NEW.ttw_idtowaru;
        pznew.ttm_idtowmag=NEW.ttm_idtowmag;
        pznew.tmg_idmagazynu=towmag.tmg_idmagazynu;
        pznew.k_idklienta=tg_transakcja.k_idklienta;
        pznew.rc_data=tg_transakcja.tr_datasprzedaz;
        pznew.tel_wartosc=-NEW.tel_wartosczakupu;
        pznew.tel_iloscrez=0;
        pznew._isapz=FALSE; 
        pznew.prt_idpartii=NULL; 
        pznew.rc_cenajmcrs=NULL;
        pznew._istransodwrocona=gm.isTEOdwrocona(NEW.tel_new2flaga);
        PERFORM gm.dodaj_pz(pznew,FALSE);
       END IF;
      ELSE
       NEW.tel_wartosczakupu=gm.dodaj_nkwz(NEW.tel_iloscf-NEW.tel_iloscpkor,NEW.tel_idelem,NEW.tr_idtrans,NEW.ttw_idtowaru,NEW.ttm_idtowmag,towmag.tmg_idmagazynu,tg_transakcja.k_idklienta,tg_transakcja.tr_datasprzedaz,NEW.tel_skojarzony);
      END IF;
     END IF;
    END IF; 
   END IF;
  END IF; --- (OF IFPR)
   
 ELSE --- Tutaj bedzie operacja handlowa

 END IF; --- (OF IFPZ)

 -----Koniec operacji na transakcjach --- zostawimy to na pozniej

 IF ((NEW.tel_newflaga&3)=0) OR TEisUsluga(NEW.tel_flaga) THEN ---- Po prostu jakas ilosc
  IF ((NEW.tel_newflaga&6)=6 AND (NEW.tel_newflaga&4194304)=0) THEN
  ----uaktualniamy koszt uslug !!!!!!!!!!!!
   IF (TG_OP='INSERT') THEN
    NEW.tel_kosztnabycia=gm.wyliczKosztUslugi(NEW.ttw_idtowaru,NEW.tel_iloscf,round(1000*_nettopln/NEW.tel_przelnilosci,6),NEW.tel_newflaga,NEW.tel_kosztnabycia);
   END IF;
   IF (TG_OP='UPDATE') THEN
    IF (
       ((OLD.tel_iloscf*OLD.tel_cenadok*OLD.tel_kursdok*1000/OLD.tel_przelnilosci)<>(NEW.tel_iloscf*NEW.tel_cenadok*NEW.tel_kursdok*1000/NEW.tel_przelnilosci)) OR 
       (OLD.tel_newflaga&4194304)!=(NEW.tel_newflaga&4194304)
    ) 
    THEN
     NEW.tel_kosztnabycia=gm.wyliczKosztUslugi(NEW.ttw_idtowaru,NEW.tel_iloscf,round(_nettopln*1000/NEW.tel_przelnilosci,6),NEW.tel_newflaga,NEW.tel_kosztnabycia);
    END IF;
   END IF;
  ELSE 
   NEW.tel_iloscwyd=0; 
   IF ((NEW.tel_newflaga&4194304)=0) THEN
    NEW.tel_kosztnabycia=gm.wyliczKosztUslugi(NULL,0,0,NEW.tel_newflaga,NEW.tel_kosztnabycia);
   END IF;
  END IF;

 ELSE
  IF (TG_OP='INSERT') THEN
   NEW.tel_iloscwyd=(NEW.tel_iloscf-NEW.tel_iloscpkor)*TEwspIlosci(NEW.tel_newflaga);
   NEW.tel_kosztnabycia=NEW.tel_wartosczakupu;
  ELSE 
   NEW.tel_iloscwyd=NEW.tel_iloscwyd+(NEW.tel_iloscf-OLD.tel_iloscf-(NEW.tel_iloscpkor-OLD.tel_iloscpkor))*TEwspIlosci(NEW.tel_newflaga);
   NEW.tel_kosztnabycia=NEW.tel_kosztnabycia+(NEW.tel_wartosczakupu-OLD.tel_wartosczakupu);
  END IF;
  IF (NEW.tel_iloscf<0) THEN
   NEW.tel_iloscwyd=0;
  END IF;


  --- STARTOF: Kompensata dokumentow handlowych
  IF (TEisOpHandel(NEW.tel_newflaga)) AND (NOT TEisOpMagazyn(NEW.tel_newflaga)) THEN
   NEW.tel_ilosckomp=KompensujHand(NEW.tel_idelem,NEW.tel_skojarzony,NEW.tel_iloscwyd,NEW.tel_newflaga);
   NEW.tel_iloscwyd=NEW.tel_iloscwyd+NEW.tel_ilosckomp;

   IF TEisRozchod(NEW.tel_newflaga) AND (NOT TEisUsluga(NEW.tel_flaga)) AND ((NEW.tel_newflaga&8)=0) THEN --- (IFPR) Rozchod
    rnew=NULL;
    rnew.rc_ilosc=NEW.tel_iloscwyd;
    rnew.tel_idelem_for=NEW.tel_idelem;
    rnew.tr_idtrans_for=NEW.tr_idtrans;
    rnew.k_idklienta_for=NEW.tel_oidklienta;
    rnew.data_rezerwacji=tg_transakcja.tr_datasprzedaz;
    rnew.ttw_idtowaru=NEW.ttw_idtowaru;
    rnew.ttm_idtowmag=NEW.ttm_idtowmag;
    rnew.tmg_idmagazynu=towmag.tmg_idmagazynu;
    rnew._zewskazaniem=((NEW.tel_newflaga&16)=16);
    rnew._idpzam=NEW.tel_skojzam;
    rnew._onlywskazane=FALSE;
    rnew.prt_idpartii=NEW.prt_idpartii;
    rnew._rezerwacjalekka=((NEW.tel_newflaga&(1<<31))<>0);
    rnew._nonewrezerwacja=(gm.isTriggerFunctionActive('AUTOREZERWACJEDOTE')=FALSE);
    PERFORM gm.dodaj_rezerwacje(rnew,FALSE);
   END IF;
  END IF;
  --- ENDOF: Kompensata dokumentow handlowych

 END IF;

 IF (_ismmp=FALSE) THEN
  IF (TG_OP='INSERT') THEN
   PERFORM updateKosztiIlosc(NULL,NEW.tel_skojarzony,NULL,NEW.tel_skojlog,0,NEW.tel_iloscwyd,0,NEW.tel_kosztnabycia,NEW.tel_newflaga);
  ELSE
   PERFORM updateKosztiIlosc(OLD.tel_skojarzony,NEW.tel_skojarzony,OLD.tel_skojlog,NEW.tel_skojlog,OLD.tel_iloscwyd,NEW.tel_iloscwyd,OLD.tel_kosztnabycia,NEW.tel_kosztnabycia,NEW.tel_newflaga);
   
   ---Zmiana odbiorcy na rezerwacjach
   IF (NEW.tel_oidklienta<>OLD.tel_oidklienta AND TEisOpMagazyn(NEW.tel_newflaga) AND NOT TEisOpHandel(NEW.tel_newflaga)) THEN
    FOR _record IN SELECT rez.tel_idelem FROM tg_ruchy AS r JOIN tg_ruchy AS rez ON (rez.rc_idruchu=r.rc_rezerwacja) WHERE rez.tel_idelem IS NOT NULL AND isRezerwacja(rez.rc_flaga) AND r.tel_idelem=NEW.tel_idelem AND NOT r.rc_rezerwacja=NULL AND NEW.tel_oidklienta<>(SELECT k_idklienta FROM tg_ruchy AS a WHERE a.rc_idruchu=r.rc_rezerwacja)
    LOOP
     UPDATE tg_ruchy SET rc_rezerwacja=NULL WHERE tel_idelem=NEW.tel_idelem AND NOT rc_rezerwacja=NULL AND NEW.tel_oidklienta<>(SELECT k_idklienta FROM tg_ruchy AS a WHERE a.rc_idruchu=tg_ruchy.rc_rezerwacja);
     UPDATE tg_transelem SET tel_idelem=tel_idelem WHERE tel_idelem=_record.tel_idelem;
    END LOOP;
   END IF;

  END IF;
 END IF;

 ---- STARTOF: Warunki sprawdzenia
 IF (abs(NEW.tel_iloscwyd)>abs(NEW.tel_iloscf-NEW.tel_iloscpkor)) AND (TEisOpHandel(NEW.tel_newflaga)) AND (NOT TEisOpMagazyn(NEW.tel_newflaga)) THEN
  RAISE EXCEPTION 'Przekroczenie ilosci';
 END IF;
 IF (sign(NEW.tel_iloscf-NEW.tel_iloscpkor)*sign(NEW.tel_iloscwyd)*TEwspIlosci(NEW.tel_newflaga)<0) AND (TEisOpHandel(NEW.tel_newflaga)) THEN
  IF (NEW.tel_newflaga&(1<<26)=0) THEN
   RAISE EXCEPTION '5|%:%|Zle znaki na operacji handlowej',NEW.tr_idtrans,NEW.tel_idelem;
  END IF;
 ELSEIF (sign(NEW.tel_iloscf-NEW.tel_iloscpkor)*sign(NEW.tel_iloscwyd)*TEwspIlosci(NEW.tel_newflaga)<0) AND NOT (TEisOpMagazyn(NEW.tel_newflaga)) THEN
  RAISE EXCEPTION 'Zle znaki na operacji niehandlowej';
 END IF;
 ---- ENDOF: Warunki sprawdzenia

 --- STARTOF: Przenies ostatnia cene zakupu na karte towaru
 IF (TG_OP='UPDATE') THEN
  IF  ((NEW.tel_flaga&16)<>(OLD.tel_flaga&16)) AND (NEW.tel_cenawal<>0 ) AND ((NEW.tel_flaga&4)=0) AND ((NEW.tel_new2flaga&(1<<3))=0) THEN 
   ---RAISE EXCEPTION 'Aktualizacja';
   IF (gm.checkRozneValue(2,rodzaj,84,'1')=TRUE) THEN
    IF (NEW.tel_skojarzony IS NOT NULL) THEN
 IF (gm.isOstatniaDostawaTowaru(NEW.ttw_idtowaru,(SELECT tr_idtrans FROM tg_transelem WHERE tel_idelem=NEW.tel_skojarzony),TRUE)=FALSE) THEN
  _doupdate=FALSE;
 END IF;  
END IF;
IF (_doupdate=TRUE) THEN
     ---zmieniamy ostatnia cene zakupu na towmagu 
     UPDATE tg_towmag SET ttm_ostcena=round((1000*NEW.tel_cenadok)/NEW.tel_przelnilosci,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags)),
                        ttm_ostcenanab=(CASE WHEN NEW.tel_iloscf=0 THEN ttm_ostcenanab ELSE round((NEW.tel_wartosczakupu+NEW.tel_narzut)/NEW.tel_iloscf,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags)) END),
                        ttm_idostwaluty=tg_transakcja.wl_idwaluty 
       WHERE ttm_idtowmag=NEW.ttm_idtowmag;
     ---jezeli to nie jest mmenka i magazy uaktualnia ostatnia cene na towarze to rowniez tam to zmieniamy
     IF (towmag.tmg_flaga&8=0 AND (_ismmp=FALSE)) THEN
      fm_idind=gm.getIndexTab(tg_transakcja.fm_idcentrali);
      UPDATE tg_towary SET ttw_ostcena[fm_idind]=round((1000*NEW.tel_cenadok)/NEW.tel_przelnilosci,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags)),
                          ttw_ostcenanab[fm_idind]=(CASE WHEN NEW.tel_newflaga&1=1 THEN 
                             (CASE WHEN NEW.tel_iloscf=0 THEN ttw_ostcenanab[fm_idind] ELSE round((NEW.tel_wartosczakupu+NEW.tel_narzut)/NEW.tel_iloscf,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags)) END)
      ELSE
        round(((1000*NEW.tel_cenadok)/NEW.tel_przelnilosci)*NEW.tel_kursdok,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags))
      END),
                          ttw_ostatniadostawa[fm_idind]=NEW.tr_idtrans,
                          ttw_idostwaluty[fm_idind]=tg_transakcja.wl_idwaluty 
        WHERE ttw_idtowaru=NEW.ttw_idtowaru AND ttw_usluga=false;
      END IF;
 END IF;
    END IF;
   END IF; --8
  END IF;
   --- ENDOF: Przenies ostatnia cene zakupu na karte towaru

END IF; --- (OF IFIU)
  ---- Operacje triggerowe

--- STARTOF: Przenoszenie marzy
IF (TG_OP='DELETE') THEN --- (IF11)
 IF (_ismmp=FALSE) THEN
  PERFORM updateKosztiIlosc(OLD.tel_skojarzony,NULL,OLD.tel_skojlog,NULL,OLD.tel_iloscwyd,0,OLD.tel_kosztnabycia,0,OLD.tel_newflaga);
 END IF;
 PERFORM gm.clearBackOrderFull(OLD.tel_idelem,OLD.ttm_idtowmag);
 IF (OLD.tel_skojzam IS NOT NULL) THEN
  PERFORM gm.RealizujPZAM(OLD.tel_idelem,OLD.tel_skojzam,OLD.tel_skojzamtex,-OLD.tel_ilosc*OLD.tel_przelnilosci/1000,1,gm.getDefaultPZAMPowod(OLD.tel_new2flaga));
 END IF;
END IF; --- (OF IF11)
--- ENDOF: Przenoszenie marzy

IF (TG_OP<>'DELETE') THEN ---- (IF13)

 ---Tutaj licz jesli dokument ma skojarzona wartosc zakupu
 IF ((NEW.tel_flaga&131072)<>0) THEN --- (IF14)
  tmp=cenaWal2Dok(NEW.tel_wartosczakupu,1,NEW.tel_kursdok,2);
  IF ((NEW.tel_flaga&65536)<>0) AND (NEW.tel_skojarzony IS NOT NULL) THEN
   tmp=tmp-nullZero((SELECT tel_wnettodok FROM tg_transelem WHERE tel_flaga&65536=0 AND tel_skojarzony=NEW.tel_skojarzony AND tr_idtrans=NEW.tr_idtrans));
  END IF;
  NEW.tel_wnettodok=tmp;
  NEW.tel_wnettowal=cenaWal2Dok(tmp,NEW.tel_kursdok,NEW.tel_kurswal,2);

  --- Obliczenie wartosci faktyczniej
  IF (NEW.tel_ilosc=0) THEN
   NEW.tel_cenawal=0;
   NEW.tel_cenadok=0;
  ELSE
   NEW.tel_cenadok=round(NEW.tel_wnettodok/NEW.tel_ilosc,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
   NEW.tel_cenawal=round(NEW.tel_wnettowal/NEW.tel_ilosc,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
  END IF;
  --- Obliczenie ceny jednostkowej
  NEW.tel_cenabdok=round(Net2Brt(NEW.tel_cenadok,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
  NEW.tel_cenabwal=round(Net2Brt(NEW.tel_cenawal,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
  IF ((tg_transakcja.tr_zamknieta&128)=0) THEN  --- Dokument od netto
   NEW.tel_cenabwal=round(Net2Brt(NEW.tel_cenawal,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
   NEW.tel_cenadok=cenaWal2Dok(NEW.tel_cenawal,NEW.tel_kurswal,NEW.tel_kursdok,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
   NEW.tel_cenabdok=round(Net2Brt(NEW.tel_cenadok,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
   NEW.tel_flaga=NEW.tel_flaga&(~32);
  ELSE
   NEW.tel_cenawal=round(Brt2Net(NEW.tel_cenabwal,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
   NEW.tel_cenabdok=cenaWal2Dok(NEW.tel_cenabwal,NEW.tel_kurswal,NEW.tel_kursdok,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
   NEW.tel_cenadok=round(Brt2Net(NEW.tel_cenabdok,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
   _isodnetto=FALSE;
   NEW.tel_flaga=NEW.tel_flaga|32;
  END IF;

  _nettopln=cenaWal2Dok(NEW.tel_wnettodok,NEW.tel_kursdok,1,2);
 END IF; ---(OF IF14)
END IF; --- (OF IF13)

--------------------------------------------------------------------------------------------------------------------------------------------------
--- STARTOF: BackOrder
--------------------------------------------------------------------------------------------------------------------------------------------------
IF (TG_OP<>'DELETE') THEN
 ----zarzadzanie backorderem dla dokumentow przychodowych (tylko w buforze)
 IF ((NEW.tel_newflaga&1)=1 AND (NEW.tel_newflaga&4)=0 AND (NEW.tel_flaga&(1024|8192))=0) THEN
  IF ((NEW.tel_flaga&16)=16) OR (NEW.tel_sprzedaz!=0) THEN
  ---transakcja zamknieta (zerujemy backorder)
   PERFORM gm.dodajBackOrderFull(NEW.tel_idelem,NEW.ttm_idtowmag,0,NOT TEisRozchod(NEW.tel_newflaga),2,((NEW.tel_flaga&(4096+256)=256) AND NOT TEisUsluga(NEW.tel_flaga)),NEW.tr_idtrans,TRUE,tg_transakcja.tr_datasprzedaz,tg_transakcja.zl_idzlecenia,NULL,NULL,NULL,NEW.tel_new2flaga,FALSE);
  ELSE
  ---transakcja otwarta dodajemy do backorderu
   PERFORM gm.dodajBackOrderFull(NEW.tel_idelem,NEW.ttm_idtowmag,max(0,NEW.tel_iloscf-NEW.tel_iloscpkor),NOT TEisRozchod(NEW.tel_newflaga),2,((NEW.tel_flaga&(4096+256)=256) AND NOT TEisUsluga(NEW.tel_flaga)),NEW.tr_idtrans,TRUE,tg_transakcja.tr_datasprzedaz,tg_transakcja.zl_idzlecenia,NULL,NEW.prt_idpartii,NEW.tel_skojzam,NEW.tel_new2flaga,(NEW.tel_newflaga&(1<<31))<>0);
  END IF;
 END IF;
 --- BackOrder dla dokumentow o zachowaniu z robieniem backordera (DIZW_ISBACKORDERSOURCE)
 IF ((NEW.tel_flaga&524288)=524288) THEN             
  IF (NEW.tel_flaga&1024=0) OR ((NEW.tel_skojzestaw IS NOT NULL) AND (gmr.gettypzestawu(NEW.tel_new2flaga) IN (0,1,2,3))) THEN   
   ---pobieramy date, gdy nie wypelniona data waznosci (np proforma) to data wystawienia z naglowka
   IF (NEW.tel_datazam IS NOT NULL) THEN
    _data=NEW.tel_datazam;
   ELSE
    _data=tg_transakcja.tr_datawystaw;
   END IF;
   PERFORM gm.dodajBackOrderFull(NEW.tel_idelem,NEW.ttm_idtowmag,
                                 max(0,NEW.tel_iloscf-NEW.tel_iloscpkor),NOT TEisRozchod(NEW.tel_newflaga),2,
 ((NEW.tel_flaga&(4096+256)=256) AND NOT TEisUsluga(NEW.tel_flaga)),
 NEW.tr_idtrans,NOT TEisUsluga(NEW.tel_flaga) AND (NEW.tel_skojzestaw IS NULL OR (gmr.getTypZestawu(NEW.tel_new2flaga) IN (1,3))),
 _data,tg_transakcja.zl_idzlecenia,NEW.tel_iloscdorezerwacji,NEW.prt_idpartii,
 NEW.tel_skojzam,
 NEW.tel_new2flaga,
 (NEW.tel_newflaga&(1<<31))<>0
);
  ELSE
   PERFORM gm.dodajBackOrderFull(NEW.tel_idelem,NEW.ttm_idtowmag,
                                 0,NOT TEisRozchod(NEW.tel_newflaga),2,
 ((NEW.tel_flaga&(4096+256)=256) AND NOT TEisUsluga(NEW.tel_flaga)),
 NEW.tr_idtrans,TRUE,
 NEW.tel_datazam,tg_transakcja.zl_idzlecenia,0,NULL,
 NULL,
 NEW.tel_new2flaga,
 (NEW.tel_newflaga&(1<<31))<>0);
  END IF;
 END IF;
END IF;
--------------------------------------------------------------------------------------------------------------------------------------------------
--- ENDOF: BackOrder
--------------------------------------------------------------------------------------------------------------------------------------------------


IF (TG_OP='INSERT') THEN

 IF (NEW.tel_skojzam IS NOT NULL) THEN
  dstanm=-NEW.tel_ilosc*NEW.tel_przelnilosci/1000;
  PERFORM gm.RealizujPZAM(NEW.tel_idelem,NEW.tel_skojzam,NEW.tel_skojzamtex,NEW.tel_ilosc*NEW.tel_przelnilosci/1000,1,gm.getDefaultPZAMPowod(NEW.tel_new2flaga));
 END IF;

END IF;

IF (TG_OP='UPDATE') THEN --- (IF15)
 dstanm=0;
 IF (OLD.tel_skojzam IS NOT NULL) THEN
  dstanm=dstanm+(OLD.tel_ilosc*OLD.tel_przelnilosci/1000);
  IF (NEW.tel_skojzam!=OLD.tel_skojzam) THEN
   PERFORM gm.RealizujPZAM(OLD.tel_idelem,OLD.tel_skojzam,OLD.tel_skojzamtex,-dstanm,1,gm.getDefaultPZAMPowod(OLD.tel_new2flaga));
   dstanm=0;
  END IF;
 END IF;
 IF (NEW.tel_skojzam IS NOT NULL) THEN
  dstanm=dstanm-NEW.tel_ilosc*NEW.tel_przelnilosci/1000;
  IF (dstanm<>0) THEN 
   PERFORM gm.RealizujPZAM(NEW.tel_idelem,NEW.tel_skojzam,OLD.tel_skojzamtex,-dstanm,1,gm.getDefaultPZAMPowod(NEW.tel_new2flaga));
  END IF;
 END IF;

 IF ((NEW.tel_newflaga&(1<<24))<>0) AND (NEW.tel_sprzedaz=0) THEN
  IF (NEW.prt_idpartii IS NULL) THEN NEW.prt_idpartii=gm.getIDNullPartii(NEW.ttw_idtowaru,TRUE,1); END IF;
  PERFORM gm.sync_apz(NEW.tel_iloscf,NEW.tel_idelem,tg_transakcja.k_idklienta,NEW.prt_idpartii);
 END IF;

 IF ((NEW.tel_flaga&8192)<>0) THEN
  NEW.tel_flaga=NEW.tel_flaga&(~8192);
  IF (NEW.tel_ilosc<=0) THEN
   NEW.tel_flaga=NEW.tel_flaga|1024;
  END IF;
  IF (NEW.tel_ilosc<>OLD.tel_ilosc) THEN
   dstanm=(SELECT tel_iloscop/tel_ilosc FROM tg_transelem WHERE tel_skojzam=NEW.tel_idelem AND tel_flaga&4096<>0 LIMIT 1 OFFSET 0);
   NEW.tel_iloscop=gm.filterIloscOp(round(NEW.tel_ilosc*NEW.tel_przelnilosci/NEW.tel_przelnopakow,4),NEW.tel_new2flaga);
  END IF;
 END IF;

 END IF; --- (OF IF15)


  --------------------------------------------------------------------------------------------------------------------------------------------------
  --- STARTOF: gdy pozycja realizuje plan produkcji to ma uaktualnic ten plan przy zmianie ilosci
  --------------------------------------------------------------------------------------------------------------------------------------------------
  IF (TG_OP='UPDATE') THEN
    IF (NEW.tel_flaga&262144=262144 AND NEW.tel_iloscf<>OLD.tel_iloscf) THEN
      UPDATE tg_realizacjaplanuprod SET rpp_ilosc=NEW.tel_iloscf WHERE tel_idelem=NEW.tel_idelem;
    END IF;
  END IF;
  --------------------------------------------------------------------------------------------------------------------------------------------------
  --- ENDOF: koniec dla realizacji planu produkcji
  --------------------------------------------------------------------------------------------------------------------------------------------------


  --------------------------------------------------------------------------------------------------------------------------------------------------
  ---- STARTOF: PACZKI wystawiane z dokumentow
  --------------------------------------------------------------------------------------------------------------------------------------------------
  IF (TG_OP<>'DELETE') THEN 
   IF ((NEW.tel_newflaga&(1<<21))=(1<<21) ) THEN
   ---uaktualniamy elementy paczki zalezne od tego rekordu
    FOR _record IN SELECT pe_idelemu FROM tg_packelem WHERE tel_idelem_fv=NEW.tel_idelem AND pe_iloscf<>NEW.tel_iloscf
    LOOP
     PERFORM checkpackelemchange(_record.pe_idelemu); ----sprawdzamy czy paczka nie jest zamknieta
     UPDATE tg_packelem SET pe_iloscf=NEW.tel_iloscf WHERE pe_idelemu=_record.pe_idelemu;
    END LOOP;
   END IF;
  ELSE
   IF ((OLD.tel_newflaga&(1<<21))=(1<<21)) THEN
   ---kasujemy elementy paczki zalezne od tego rekordu
    FOR _record IN SELECT pe_idelemu FROM tg_packelem WHERE tel_idelem_fv=OLD.tel_idelem 
    LOOP
     PERFORM checkpackelemchange(_record.pe_idelemu); ----sprawdzamy czy paczka nie jest zamknieta
     --oznaczamy paczke do skasowania
     UPDATE tg_packelem SET pe_flaga=pe_flaga|2 WHERE pe_idelemu=_record.pe_idelemu;
     --kasujemy paczke
     DELETE FROM tg_packelem  WHERE pe_idelemu=_record.pe_idelemu;
    END LOOP;
   END IF;
  END IF;
  --------------------------------------------------------------------------------------------------------------------------------------------------
  ---- ENDOF: PACZKI wystawiane z dokumentow
  --------------------------------------------------------------------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------------------------------------------------------------------------
  ---- STARTOF: Dla swiadectw
  --------------------------------------------------------------------------------------------------------------------------------------------------
  IF (TG_OP='UPDATE') THEN
   IF (NEW.tel_flaga&8388608=8388608) THEN
    UPDATE tg_swiadruchy SET sr_ilosc=NEW.tel_iloscf WHERE tel_idelem=NEW.tel_idelem;
   END IF;
  END IF;
  --------------------------------------------------------------------------------------------------------------------------------------------------
  ---- ENDOF: Dla swiadectw
  --------------------------------------------------------------------------------------------------------------------------------------------------


  --------------------------------------------------------------------------------------------------------------------------------------------------
  ---- STARTOF: Liczenie wartosci
  --------------------------------------------------------------------------------------------------------------------------------------------------
  IF (TG_OP<>'DELETE') THEN

   --- STARTOF: Liczenie cen
   IF (NEW.tel_flaga&(1<<26)!=0) THEN
   ---pozycjie z zaogklagleniem liczyczmy tylko podsumowanie
    NEW.tel_cenadok=cenaWal2Dok(NEW.tel_cenawal,NEW.tel_kurswal,NEW.tel_kursdok,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
    NEW.tel_cenabdok=cenaWal2Dok(NEW.tel_cenabwal,NEW.tel_kurswal,NEW.tel_kursdok,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
    NEW.tel_wnettodok=round(NEW.tel_cenadok*NEW.tel_ilosc,2);
    NEW.tel_wnettowal=round(NEW.tel_cenawal*NEW.tel_ilosc,2);
   ELSE
    ----STARTOF: Normalne pozycje
    IF (NEW.tel_newflaga&(1<<23)=0) THEN ------ Wartosc liczona z ceny*ilosc
     IF ((tg_transakcja.tr_zamknieta&128)=0) THEN  --- Dokument od netto
      NEW.tel_cenabwal=round(Net2Brt(NEW.tel_cenawal,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_cenadok=cenaWal2Dok(NEW.tel_cenawal,NEW.tel_kurswal,NEW.tel_kursdok,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_cenabdok=round(Net2Brt(NEW.tel_cenadok,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_wnettodok=round(NEW.tel_cenadok*NEW.tel_ilosc,2);
      NEW.tel_wnettowal=round(NEW.tel_cenawal*NEW.tel_ilosc,2);
      NEW.tel_flaga=NEW.tel_flaga&(~32);
     ELSE
      NEW.tel_cenawal=round(Brt2Net(NEW.tel_cenabwal,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_cenabdok=cenaWal2Dok(NEW.tel_cenabwal,NEW.tel_kurswal,NEW.tel_kursdok,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_cenadok=round(Brt2Net(NEW.tel_cenabdok,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_wnettodok=round(NEW.tel_cenabdok*NEW.tel_ilosc, 2);
      NEW.tel_wnettodok=NEW.tel_wnettodok-round(vatfrombrt(NEW.tel_wnettodok, NEW.tel_stvat::numeric), 2);
      NEW.tel_wnettowal=round(NEW.tel_cenabwal*NEW.tel_ilosc, 2);
      NEW.tel_wnettowal=NEW.tel_wnettowal-round(vatfrombrt(NEW.tel_wnettowal, NEW.tel_stvat::numeric), 2);
      NEW.tel_flaga=NEW.tel_flaga|32;
     END IF;
    ELSE ---- Ceny liczone z wartosci
     NEW.tel_wnettodok=cenaWal2Dok(NEW.tel_wnettowal,NEW.tel_kurswal,NEW.tel_kursdok,2);

     --- Obliczenie wartosci faktyczniej
     IF (NEW.tel_ilosc=0) THEN
      NEW.tel_cenadok=0;
      NEW.tel_cenawal=0;
     ELSE
      NEW.tel_cenadok=round(NEW.tel_wnettodok/NEW.tel_ilosc,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
      NEW.tel_cenawal=round(NEW.tel_wnettowal/NEW.tel_ilosc,gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
     END IF;
     --- Obliczenie ceny jednostkowej
     NEW.tel_cenabdok=round(Net2Brt(NEW.tel_cenadok,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
     NEW.tel_cenabwal=round(Net2Brt(NEW.tel_cenawal,NEW.tel_stvat),gm.getTEDokladnoscCen(NEW.tel_dokladnoscflags));
     IF ((tg_transakcja.tr_zamknieta&128)=0) THEN  --- Dokument od netto
      NEW.tel_flaga=NEW.tel_flaga&(~32);
     ELSE
      NEW.tel_flaga=NEW.tel_flaga|32;
     END IF;
    END IF;

   END IF;
   ----ENDOF: Normalne pozycje
  END IF;
  --------------------------------------------------------------------------------------------------------------------------------------------------
  ---- ENDOF: Liczenie wartosci
  --------------------------------------------------------------------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------------------------------------------------------------------------
  --- STARTOF: Marza
  --------------------------------------------------------------------------------------------------------------------------------------------------
  IF (TG_OP<>'DELETE') THEN

   --- STARTOF: Liczenie kosztow
   IF ((NEW.tel_newflaga&3)<>0) AND NOT TEisUsluga(NEW.tel_flaga) THEN ---- Po prostu jakas ilosc
    ---Jesli jest operacja handlowa i magazynowa to przenies bezposrednio koszty
    IF (TEisOpHandel(NEW.tel_newflaga)) AND (TEisOpMagazyn(NEW.tel_newflaga)) THEN
     dkosztpln=dkosztpln+NEW.tel_wartosczakupu;
     dmarzapln=dmarzapln+(_nettopln-NEW.tel_wartosczakupu);
    ELSE
     --Jesli jest operacja handlowa lub (magazynowa i nie ma skojarzenia to przenies marze z przeniesienia
     IF (COALESCE(NEW.tel_skojlog,0)=0) AND (COALESCE(NEW.tel_skojarzony,0)=0) OR (TEisOpHandel(NEW.tel_newflaga)) THEN
      dkosztpln=dkosztpln+NEW.tel_kosztnabycia;
      dmarzapln=dmarzapln+(_nettopln-NEW.tel_kosztnabycia);
     END IF;
    END IF;
   ELSE 
    ----- dla uslug dla dokumentow hanlowych przenosimy z przeniesienia
    IF (TEisUsluga(NEW.tel_flaga) AND TEisOpHandel(NEW.tel_newflaga)) THEN
     dkosztpln=dkosztpln+NEW.tel_kosztnabycia;
     dmarzapln=dmarzapln+(_nettopln-NEW.tel_kosztnabycia);
    END IF;
   END IF;
   --- ENDOF: Liczenie kosztow

   IF ((NEW.tel_flaga&8)<>0) THEN
    dkosztpln=_nettopln;
    dmarzapln=0;
   END IF;
   NEW.tel_koszt=dkosztpln;
  END IF;
  --------------------------------------------------------------------------------------------------------------------------------------------------
  --- ENDOF: Marza
  --------------------------------------------------------------------------------------------------------------------------------------------------

  --------------------------------------------------------------------------------------------------------------------------------------------------
  --- STARTOF: Przenoszenie marzy - wykonanie
  --------------------------------------------------------------------------------------------------------------------------------------------------
  IF (TG_OP='UPDATE') THEN --- (IF12)
   IF ((NEW.tr_idtrans=OLD.tr_idtrans) AND (COALESCE(NEW.tel_skojlog,0)=COALESCE(OLD.tel_skojlog,0)) AND (COALESCE(NEW.tel_skojarzony,0)=COALESCE(OLD.tel_skojarzony,0))) THEN
    dkosztpln=dkosztpln+dkosztplno;
    dmarzapln=dmarzapln+dmarzaplno;
    dkosztplno=0;
    dmarzaplno=0;
   END IF;
  END IF; --- (OF IF12)
  --- ENDOF: Przenoszenie marzy - wykonanie

  IF (dmarzaplno<>0) OR (dkosztplno<>0) THEN
    ---Tutaj beda obliczenia dla delete (wlasciwie tylko zerowanie funkcji z towmagow i zmniejszanie wartosci)
   UPDATE tg_transakcje SET tr_marza=round(tr_marza+dmarzaplno,2),tr_koszt=round(tr_koszt+dkosztplno,2) WHERE tr_idtrans=OLD.tr_idtrans;
   dmarzaplno=0; dkosztplno=0;
  END IF;

  IF (dmarzapln<>0) OR (dkosztpln<>0) THEN
    ---Tutaj beda obliczenia dla delete (wlasciwie tylko zerowanie funkcji z towmagow i zmniejszanie wartosci)
   UPDATE tg_transakcje SET tr_marza=round(tr_marza+dmarzapln,2),tr_koszt=round(tr_koszt+dkosztpln,2) WHERE tr_idtrans=NEW.tr_idtrans;
   dmarzapln=0; dkosztpln=0;
  END IF;
  --------------------------------------------------------------------------------------------------------------------------------------------------
  --- ENDOF: Przenoszenie marzy - wykonanie
  --------------------------------------------------------------------------------------------------------------------------------------------------

  ----------------------------------------------------------
  ----Koniec dla swiadectw
  ----------------------------------------------------------
  
 ------------------------------------------------------------------------------------------
 ---liczenie calkowitej sprzedazy i zakupu dla towaru
 ------------------------------------------------------------------------------------------
 IF (TG_OP='INSERT') THEN
  IF (NEW.tel_newflaga&(2+4)=(2+4) AND tg_transakcja.tr_rodzaj!=21) THEN
   sprzedaz_delta_ilosci=NEW.tel_iloscf;
  END IF;

  IF (NEW.tel_newflaga&(2+4)=(2) AND tg_transakcja.tr_rodzaj!=21) THEN
   zakup_delta_ilosci=NEW.tel_iloscf;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.tel_newflaga&(2+4)=(2+4) AND tg_transakcja.tr_rodzaj!=21) THEN
   sprzedaz_delta_ilosci=NEW.tel_iloscf-OLD.tel_iloscf;
  END IF;

  IF (NEW.tel_newflaga&(2+4)=(2) AND tg_transakcja.tr_rodzaj!=21) THEN
   zakup_delta_ilosci=NEW.tel_iloscf-OLD.tel_iloscf;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  SELECT INTO tg_transakcja tr_rodzaj, fm_idcentrali FROM tg_transakcje WHERE tr_idtrans=OLD.tr_idtrans;
 
  IF (OLD.tel_newflaga&(2+4)=(2+4) AND tg_transakcja.tr_rodzaj!=21) THEN
   sprzedaz_delta_ilosci=-OLD.tel_iloscf;
  END IF;

  IF (OLD.tel_newflaga&(2+4)=(2) AND tg_transakcja.tr_rodzaj!=21) THEN
   zakup_delta_ilosci=-OLD.tel_iloscf;
  END IF;
 END IF;

 IF (sprzedaz_delta_ilosci!=0) THEN
  fm_idind=gm.getIndexTab(tg_transakcja.fm_idcentrali);

  IF (TG_OP='DELETE') THEN
   UPDATE tg_towary SET ttw_sprzedazall[fm_idind]=nullzero(ttw_sprzedazall[fm_idind])+sprzedaz_delta_ilosci WHERE ttw_idtowaru=OLD.ttw_idtowaru;
  ELSE
   UPDATE tg_towary SET ttw_sprzedazall[fm_idind]=nullzero(ttw_sprzedazall[fm_idind])+sprzedaz_delta_ilosci WHERE ttw_idtowaru=NEW.ttw_idtowaru;
  END IF;
 END IF;

 IF (zakup_delta_ilosci!=0) THEN
  fm_idind=gm.getIndexTab(tg_transakcja.fm_idcentrali);

  IF (TG_OP='DELETE') THEN
   UPDATE tg_towary SET ttw_zakupall[fm_idind]=nullzero(ttw_zakupall[fm_idind])+zakup_delta_ilosci WHERE ttw_idtowaru=OLD.ttw_idtowaru;
  ELSE
   UPDATE tg_towary SET ttw_zakupall[fm_idind]=nullzero(ttw_zakupall[fm_idind])+zakup_delta_ilosci WHERE ttw_idtowaru=NEW.ttw_idtowaru;
  END IF;
 END IF;
 ------------------------------------------------------------------------------------------
 ---koniec liczenia calkowitej sprzedazy i zakupu dla towaru
 ------------------------------------------------------------------------------------------

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  NEW.tel_newflaga=NEW.tel_newflaga&(~(8+16));
  RETURN NEW;
 END IF;

END;
$$;
