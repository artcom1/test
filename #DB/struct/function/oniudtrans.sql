CREATE FUNCTION oniudtrans() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 dkoszto numeric := 0;
 dkoszt numeric := 0;
 dprzychodo numeric := 0;
 dprzychod numeric := 0;
 rozliczenie_ko RECORD;
 rozliczajNOcfg TEXT;
 rozliczajNOold BOOL;
 rozliczajNOnew BOOL;
 rec RECORD;
BEGIN
 rozliczajNOold := false;
 rozliczajNOnew := false;
 IF ((TG_OP='UPDATE') OR (TG_OP='DELETE')) THEN
  IF (OLD.zl_idzlecenia>0) THEN
   SELECT zl_typ INTO rec FROM tg_zlecenia WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   rozliczajNOcfg :=  OLD.tr_flaga & (1 << 22);
   rozliczajNOold := (rozliczajNOcfg = '1');
  END IF;
 END IF;
 IF ((TG_OP='UPDATE') OR (TG_OP='INSERT')) THEN
  IF (NEW.zl_idzlecenia>0) THEN
   SELECT zl_typ INTO rec FROM tg_zlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   rozliczajNOcfg := (SELECT cf_defvalue FROM tc_config WHERE cf_tabela=('ZleceniaRozliczajNotyNO_'||rec.zl_typ));
   rozliczajNOnew := (rozliczajNOcfg = '1');
   IF rozliczajNOnew THEN
    NEW.tr_flaga = NEW.tr_flaga | (1 << 22);
   ELSE
    NEW.tr_flaga = NEW.tr_flaga & ~(1 << 22);
   END IF;
  END IF;
 END IF;


 IF (TG_OP='UPDATE') OR (TG_OP='DELETE') THEN
  IF NOT (OLD.zl_idzlecenia=NULL) THEN
   dkoszto=-OLD.tr_koszt;
  END IF;
  -- Oblicz przychod ze zlecenia
  IF (((OLD.tr_rodzaj=1) OR (OLD.tr_rodzaj=11) OR (OLD.tr_rodzaj=5) OR (OLD.tr_rodzaj=15) OR (rozliczajNOold AND ((OLD.tr_rodzaj=114) OR (OLD.tr_rodzaj=115)))) AND (NOT(OLD.zl_idzlecenia=NULL))) THEN -- FV, KFV, PW, KPW, NO, NOK
   dprzychodo=-round(OLD.tr_wartosc*OLD.tr_przelicznik,2);
  END IF;

 END IF;


 IF (TG_OP='UPDATE') OR (TG_OP='INSERT') THEN
  --- Sprawdzenie czy to nie jest reczna operacja
  IF ((NEW.tr_zamknieta&16384::int2)<>0) THEN
   NEW.tr_zamknieta=NEW.tr_zamknieta&(~16384::int2);
   RETURN NEW;
  END IF;

  IF (((NEW.tr_zamknieta&(1<<29))=0) OR (NEW.wl_idwaluty=1) OR ((NEW.tr_zamknieta&(1<<7))!=0)) THEN
   NEW.tr_zamknieta=NEW.tr_zamknieta&(~(1<<29)); 
   NEW.tr_kursvat=NEW.tr_przelicznik;
  END IF;

  --- PZet importowe o jego korekta nie moze byc od brutto
  IF ((NEW.tr_zamknieta&1536::int2=512) AND ((NEW.tr_rodzaj=0) OR (NEW.tr_rodzaj=10))) THEN
   NEW.tr_zamknieta=NEW.tr_zamknieta&(~128::int2); 
  END IF;

  NEW.tr_wartosc=round(NEW.tr_wartosc,2);
  NEW.tr_dozaplaty=round(NEW.tr_dozaplaty,2);
  NEW.tr_zaplacono=round(NEW.tr_zaplacono,2);
  NEW.tr_marza=round(NEW.tr_marza,2);

  --- Paragon zawsze od brutto
  IF (NEW.tr_rodzaj=7) THEN NEW.tr_zamknieta=NEW.tr_zamknieta|128::int2; END IF; -- Paragon

  IF ((NEW.tr_zamknieta&128)<>0) THEN --- Liczenie VAT od brutto
   NEW.tr_wartosc=NEW.tr_dozaplaty-NEW.tr_vat;
   NEW.tr_flaga=NEW.tr_flaga&(~(2048+4096));
  ELSE -- Od netto
   NEW.tr_dozaplaty=NEW.tr_wartosc+NEW.tr_vat;

   IF ((NEW.tr_flaga&2048)<>0) THEN
    NEW.tr_dozaplaty=NEW.tr_dozaplaty+NEW.tr_kosztkraj;
   END IF;
   IF ((NEW.tr_flaga&4096)<>0) THEN
    NEW.tr_dozaplaty=NEW.tr_dozaplaty+NEW.tr_kosztzag;
   END IF;

  END IF;

  IF NOT (NEW.zl_idzlecenia=NULL) THEN
   dkoszt=NEW.tr_koszt;
  END IF;
  -- Oblicz przychod ze zlecenia
  IF (((NEW.tr_rodzaj=1) OR (NEW.tr_rodzaj=11) OR (NEW.tr_rodzaj=5) OR (NEW.tr_rodzaj=15) OR (rozliczajNOnew AND ((NEW.tr_rodzaj=114) OR (NEW.tr_rodzaj=115)))) AND (NOT(NEW.zl_idzlecenia=NULL))) THEN -- FV, KFV, PW, KPW, NO, NOK
   dprzychod=round(NEW.tr_wartosc*NEW.tr_przelicznik,2);
  END IF;

  --Nie rozliczaj nigdy nie do konca zaplaconych dokumentow
  IF (NEW.tr_dozaplaty<>NEW.tr_zaplacono) THEN
   NEW.tr_zamknieta=NEW.tr_zamknieta&(~(2::int2));
  END IF;

  --Zrob update wydania
  IF ((NEW.tr_flaga&384)<>256) THEN
--   NEW.tr_flaga=NEW.tr_flaga&(~1024);
  END IF;

 END IF;


 IF (TG_OP='UPDATE') THEN

  IF ( 
       (COALESCE(NEW.k_idklienta,0)<>COALESCE(OLD.k_idklienta,0)) AND
       (COALESCE(NEW.br_idrelacji,0)=COALESCE(OLD.br_idrelacji,0))
     )
  THEN
   NEW.br_idrelacji=NULL;
  END IF;

  IF (NEW.zl_idzlecenia=OLD.zl_idzlecenia) THEN
   dkoszt=dkoszt+dkoszto;
   dprzychod=dprzychod+dprzychodo;
   dprzychodo=0;
   dkoszto=0;
  END IF;
  IF (NEW.tr_rodzaj=60) THEN
   IF ((NEW.tr_flaga&32)=0) THEN   --- TK bez kaucji
    NEW.k_idklienta=NEW.tr_oidklienta;
    NEW.tr_zamknieta=NEW.tr_zamknieta|2::int2;
   END IF;

   IF (NEW.k_idklienta<>OLD.k_idklienta) THEN
    NEW.tr_knazwa=(SELECT k_nazwa FROM tb_klient WHERE k_idklienta=NEW.k_idklienta);
   END IF;
   IF (NEW.tr_oidklienta<>OLD.tr_oidklienta) THEN
    NEW.tr_onazwa=(SELECT k_nazwa FROM tb_klient WHERE k_idklienta=NEW.tr_oidklienta);
   END IF;
  END IF;

 END IF;

 IF (TG_OP='INSERT') THEN
  -- Pobierz automatycznie nazwe klienta
  IF ( NEW.tr_knazwa = '' ) THEN
   NEW.tr_knazwa=(SELECT k_nazwa FROM tb_klient WHERE k_idklienta=NEW.k_idklienta);
  END IF;
  --- Zaznacz istnienie TK
  IF (NEW.tr_rodzaj=60) THEN
   UPDATE tg_transakcje SET tr_flaga=tr_flaga|2 WHERE tr_idtrans=NEW.tr_skojarzona;
  END IF;
  IF NOT (NEW.tr_skojlog=NULL) THEN
   UPDATE tg_transakcje SET tr_flaga=tr_flaga|64 WHERE tr_idtrans=NEW.tr_skojlog;
  END IF;
  IF NOT (NEW.tr_skojwyn=NULL) THEN
   UPDATE tg_transakcje SET tr_flaga=tr_flaga|(1<<25) WHERE tr_idtrans=NEW.tr_skojwyn;
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN

  IF (OLD.tr_rodzaj=60) THEN
   UPDATE tg_transakcje SET tr_flaga=tr_flaga&(~2) WHERE tr_idtrans=OLD.tr_skojarzona;
  END IF;

  ---Zapisz do tabeli wolnych numerow
  IF (COALESCE(OLD.tr_numer,0)!=0) AND (OLD.tr_wersja IS NULL) THEN
   INSERT INTO tg_wolnenumery 
    (tr_rodzaj,tr_seria,tr_rok,tr_numer,tr_datasprzedaz,fm_idcentrali,tr_infix) 
   VALUES 
   (OLD.tr_rodzaj,OLD.tr_seria,OLD.tr_rok,OLD.tr_numer,min(date(OLD.tr_datasprzedaz),date(now())),OLD.fm_idcentrali,COALESCE(OLD.tr_infix,''));
  END IF;



 END IF;

 IF (TG_OP='INSERT') THEN
  DELETE FROM tg_wolnenumery 
  WHERE fm_idcentrali=NEW.fm_idcentrali AND 
        tr_rodzaj=NEW.tr_rodzaj AND 
(tr_rok=NEW.tr_rok OR (vendo.getconfigvalue('NumBezRoku')='1')) AND 
tr_numer=NEW.tr_numer AND 
(tr_infix=COALESCE(NEW.tr_infix,'') OR (vendo.getconfigvalue('NumBezInfix')='1')) AND 
(tr_seria=NEW.tr_seria OR (vendo.getconfigvalue('NumBezSerii')='1'));
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (COALESCE(OLD.tr_numer,0)=0) AND (COALESCE(NEW.tr_numer,0)!=0) THEN
   DELETE FROM tg_wolnenumery 
   WHERE fm_idcentrali=NEW.fm_idcentrali AND 
         tr_rodzaj=NEW.tr_rodzaj AND 
 (tr_rok=NEW.tr_rok OR (vendo.getconfigvalue('NumBezRoku')='1')) AND 
 tr_numer=NEW.tr_numer AND 
 (tr_infix=COALESCE(NEW.tr_infix,'') OR (vendo.getconfigvalue('NumBezInfix')='1')) AND 
(tr_seria=NEW.tr_seria OR (vendo.getconfigvalue('NumBezSerii')='1'));
  END IF;
 END IF;

  -------------czesc dotyczaca zlecen podczepionych do dokumentu
 IF (TG_OP='DELETE' OR TG_OP='UPDATE') THEN

  IF (OLD.zl_idzlecenia>0 AND (OLD.tr_flaga&134217728)=0) THEN
   ---wycofujemy uaktualnienie dla starego zlecenia podpietego do dokumentu
   IF (OLD.tr_rodzaj=34) THEN
   ---oferty
    UPDATE tg_zlecenia SET zl_ofertabto=zl_ofertabto-round(OLD.tr_wartosc*OLD.tr_przelicznik,2)-round(OLD.tr_vat*OLD.tr_przelicznik,2), zl_ofertanto=zl_ofertanto-round(OLD.tr_wartosc*OLD.tr_przelicznik,2) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   END IF;
   IF (OLD.tr_rodzaj=102 OR OLD.tr_rodzaj=202) THEN
   ---dokumenty invoice  (FI, KFI)
    UPDATE tg_zlecenia SET zl_invoicebrutto=zl_invoicebrutto-round(OLD.tr_wartosc*OLD.tr_przelicznik,2)-round(OLD.tr_vat*OLD.tr_przelicznik,2), zl_invoicenetto=zl_invoicenetto-round(OLD.tr_wartosc*OLD.tr_przelicznik,2) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   END IF;
   IF (((OLD.tr_flaga&256=256) AND (gm.getKierunekRozrachunku(OLD.tr_flaga,OLD.tr_newflaga)<0)) OR (rozliczajNOold AND ((OLD.tr_rodzaj=114) OR (OLD.tr_rodzaj=115)))) THEN
   ---dokumenty handlowe rozchodowe (FV,PR) albo NO,NOK
    UPDATE tg_zlecenia SET zl_nzaplaconedok=zl_nzaplaconedok-round((OLD.tr_dozaplaty-OLD.tr_zaplacono)*OLD.tr_przelicznik,2),zl_wrtbrutto=zl_wrtbrutto-round(OLD.tr_wartosc*OLD.tr_przelicznik,2)-round(OLD.tr_vat*OLD.tr_przelicznik,2), zl_wrtnetto=zl_wrtnetto-round(OLD.tr_wartosc*OLD.tr_przelicznik,2) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   END IF;
   IF (OLD.tr_flaga&128=128 AND (gm.getKierunekRozrachunku(OLD.tr_flaga,OLD.tr_newflaga)<0) AND OLD.tr_rodzaj<>4 AND OLD.tr_rodzaj<>6 AND OLD.tr_rodzaj<>14 AND OLD.tr_rodzaj<>16 AND OLD.tr_rodzaj<>108 AND OLD.tr_rodzaj<>208) THEN
   ---dokumenty wydania z magazynu bez rw i mmek, wk, kwk
    UPDATE tg_zlecenia SET zl_wydanie=zl_wydanie-round(OLD.tr_wartosc*OLD.tr_przelicznik,2) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   END IF;
   IF (OLD.tr_flaga&(128+256)>0 AND (gm.getKierunekRozrachunku(OLD.tr_flaga,OLD.tr_newflaga)<0) AND OLD.tr_rodzaj<>4 AND OLD.tr_rodzaj<>6 AND OLD.tr_rodzaj<>14 AND OLD.tr_rodzaj<>16) THEN
   ---dokumenty rozchodowe z kosztem wydania z magazynu (WZ, FV, PR)
    UPDATE tg_zlecenia SET zl_kosztfv=zl_kosztfv-OLD.tr_koszt WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   END IF;
   IF (OLD.tr_rodzaj=4 OR OLD.tr_rodzaj=14) THEN
   ---dokumenty rozchodu RW z magazynu
    UPDATE tg_zlecenia SET zl_rozchodrw=zl_rozchodrw-round(OLD.tr_wartosc*OLD.tr_przelicznik,2) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   END IF;
   IF (OLD.tr_rodzaj=5 OR OLD.tr_rodzaj=15) THEN
   ---dokumenty rozchodu RW z magazynu
    UPDATE tg_zlecenia SET zl_przychod=zl_przychod-round(OLD.tr_wartosc*OLD.tr_przelicznik,2) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   END IF;
   IF (OLD.tr_rodzaj=45 OR  OLD.tr_rodzaj=245) THEN
    ---dokumenty kosztowe i korekty
    UPDATE tg_zlecenia SET zl_koszt=zl_koszt-round(OLD.tr_wartosc*OLD.tr_przelicznik,2),zl_kosztbrt=zl_kosztbrt-round(OLD.tr_wartosc*OLD.tr_przelicznik,2)-round(OLD.tr_vat*OLD.tr_przelicznik,2) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   END IF;
   IF (TG_OP='DELETE') THEN
   --tylko dla usuwania
    IF ((OLD.tr_rodzaj=145 OR  OLD.tr_rodzaj=345) AND OLD.tr_flaga&256=256) THEN
     ---dokumenty FZ i KFZ, tylko dla szczegolowych i czesc dotyczaca kosztow i uslug
     SELECT sum(tel_netto) AS tel_netto, sum(tel_vat) AS tel_vat, sum(tel_vat2) AS tel_vat2, sum(tel_vatb) AS tel_vatb, sum(tel_vatb2) AS tel_vatb2, sum(tel_brutto) AS tel_brutto  INTO rozliczenie_ko FROM (SELECT sum(tel_wnettodok) AS tel_netto, round(vatfromnet(sum(tel_wnettodok), tel_stvat::numeric), 2) AS tel_vat, sum(round(vatfromnet(tel_wnettodok, tel_stvat::numeric), 2)) AS tel_vat2, round(vatfrombrt(sum(round(tel_cenabdok * tel_ilosc, 2)), tel_stvat::numeric), 2) AS tel_vatb,sum(round(vatfrombrt(round(tel_cenabdok * tel_ilosc, 2), tel_stvat::numeric), 2)) AS tel_vatb2, sum(round(tel_cenabdok * tel_ilosc, 2)) AS tel_brutto  FROM tg_transelem WHERE (tel_flaga & 1024) = 0 AND tel_flaga&(4+8)!=0 AND tr_idtrans=OLD.tr_idtrans GROUP BY tel_stvat) AS t;

     UPDATE tg_zlecenia SET zl_koszt=zl_koszt-round(NullZero(( CASE WHEN (OLD.tr_zamknieta & (128 | (1 << 17))) = 128 THEN rozliczenie_ko.tel_brutto-rozliczenie_ko.tel_vatb WHEN (OLD.tr_zamknieta & (128 | (1 << 17))) = (128 | (1 << 17)) THEN rozliczenie_ko.tel_brutto - rozliczenie_ko.tel_vatb2 ELSE rozliczenie_ko.tel_netto END)*OLD.tr_przelicznik),2),zl_kosztbrt=zl_kosztbrt-round(NullZero(( CASE WHEN (OLD.tr_zamknieta & 128) = 128 THEN rozliczenie_ko.tel_brutto WHEN (OLD.tr_zamknieta & (1 << 17)) = (1 << 17) THEN rozliczenie_ko.tel_netto + rozliczenie_ko.tel_vat2 ELSE rozliczenie_ko.tel_netto + rozliczenie_ko.tel_vat END)*OLD.tr_przelicznik),2) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
    END IF;
   END IF;
   IF (OLD.tr_rodzaj=61  ) THEN
    ---dokumenty ZWP
    UPDATE tg_zlecenia SET zl_zwrot=zl_zwrot-round(OLD.tr_wartosc*OLD.tr_przelicznik,2) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
   END IF;
   IF (OLD.tr_rodzaj=30 AND (OLD.tr_zamknieta&1::int2)=0) THEN
    ---dokumenty PZAM zmieniamy tylko dla otwartych dokumentow
     IF (TG_OP='DELETE' ) THEN 
       UPDATE tg_zlecenia SET zl_planprzychod=zl_planprzychod-round(OLD.tr_wartosc*OLD.tr_przelicznik,2),zl_planprzychodbrt=zl_planprzychodbrt-round(OLD.tr_wartosc*OLD.tr_przelicznik,2)-round(OLD.tr_vat*OLD.tr_przelicznik,2) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
     ELSE
      IF (TG_OP='UPDATE' AND (NEW.tr_zamknieta&1::int2)=0) THEN
        UPDATE tg_zlecenia SET zl_planprzychod=zl_planprzychod-round(OLD.tr_wartosc*OLD.tr_przelicznik,2),zl_planprzychodbrt=zl_planprzychodbrt-round(OLD.tr_wartosc*OLD.tr_przelicznik,2)-round(OLD.tr_vat*OLD.tr_przelicznik,2) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
      END IF;
     END IF;
   END IF;
  END IF;
 END IF;



 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
  IF (NEW.zl_idzlecenia>0 AND (NEW.tr_flaga&134217728)=0) THEN
   ---dodajemy uaktualnienie dla nowego zlecenia podpietego do dokumentu
   IF (NEW.tr_rodzaj=34) THEN
   ---oferty
    UPDATE tg_zlecenia SET zl_ofertabto=zl_ofertabto+round(NEW.tr_wartosc*NEW.tr_przelicznik,2)+round(NEW.tr_vat*NEW.tr_przelicznik,2), zl_ofertanto=zl_ofertanto+round(NEW.tr_wartosc*NEW.tr_przelicznik,2) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
   IF (NEW.tr_rodzaj=102 OR NEW.tr_rodzaj=202) THEN
   ---dokumenty invoice  (FI, KFI)
    UPDATE tg_zlecenia SET zl_invoicebrutto=zl_invoicebrutto+round(NEW.tr_wartosc*NEW.tr_przelicznik,2)+round(NEW.tr_vat*NEW.tr_przelicznik,2), zl_invoicenetto=zl_invoicenetto+round(NEW.tr_wartosc*NEW.tr_przelicznik,2) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
   IF ((NEW.tr_flaga&256=256 AND (gm.getKierunekRozrachunku(NEW.tr_flaga,NEW.tr_newflaga)<0)) OR (rozliczajNOnew AND ((NEW.tr_rodzaj=114) OR (NEW.tr_rodzaj=115)))) THEN
    ---dokumenty handlowe rozchodowe (FV,PR) albo NO,NOK
    UPDATE tg_zlecenia SET zl_nzaplaconedok=zl_nzaplaconedok+round((NEW.tr_dozaplaty-NEW.tr_zaplacono)*NEW.tr_przelicznik,2),zl_wrtbrutto=zl_wrtbrutto+round(NEW.tr_wartosc*NEW.tr_przelicznik,2)+round(NEW.tr_vat*NEW.tr_przelicznik,2), zl_wrtnetto=zl_wrtnetto+round(NEW.tr_wartosc*NEW.tr_przelicznik,2) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
   IF (NEW.tr_flaga&128=128 AND (gm.getKierunekRozrachunku(NEW.tr_flaga,NEW.tr_newflaga)<0) AND NEW.tr_rodzaj<>4 AND NEW.tr_rodzaj<>6 AND NEW.tr_rodzaj<>14 AND NEW.tr_rodzaj<>16 AND NEW.tr_rodzaj<>108 AND NEW.tr_rodzaj<>208) THEN
    ---dokumenty wydania z magazynu bez rw i mmek, wk, kwk
    UPDATE tg_zlecenia SET zl_wydanie=zl_wydanie+round(NEW.tr_wartosc*NEW.tr_przelicznik,2) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
   IF (NEW.tr_flaga&(128+256)>0 AND (gm.getKierunekRozrachunku(NEW.tr_flaga,NEW.tr_newflaga)<0) AND NEW.tr_rodzaj<>4 AND NEW.tr_rodzaj<>6 AND NEW.tr_rodzaj<>14 AND NEW.tr_rodzaj<>16) THEN
    ---dokumenty rozchodowe na ktorym mamy koszt wydania z magazynu np (WZ, FV, PR)
    UPDATE tg_zlecenia SET zl_kosztfv=zl_kosztfv+NEW.tr_koszt WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
   IF (NEW.tr_rodzaj=4 OR NEW.tr_rodzaj=14) THEN
    ---dokumenty rozchodu RW z magazynu
    UPDATE tg_zlecenia SET zl_rozchodrw=zl_rozchodrw+round(NEW.tr_wartosc*NEW.tr_przelicznik,2) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
   IF (NEW.tr_rodzaj=5 OR NEW.tr_rodzaj=15) THEN
    ---dokumenty rozchodu RW z magazynu
    UPDATE tg_zlecenia SET zl_przychod=zl_przychod+round(NEW.tr_wartosc*NEW.tr_przelicznik,2) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
   IF (NEW.tr_rodzaj=45 OR  NEW.tr_rodzaj=245) THEN
    ---dokumenty kosztowe i korekty
    UPDATE tg_zlecenia SET zl_koszt=zl_koszt+round(NEW.tr_wartosc*NEW.tr_przelicznik,2),zl_kosztbrt=zl_kosztbrt+round(NEW.tr_wartosc*NEW.tr_przelicznik,2)+round(NEW.tr_vat*NEW.tr_przelicznik,2) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
   IF (NEW.tr_rodzaj=61) THEN
    ---dokumenty ZWP
    UPDATE tg_zlecenia SET zl_zwrot=zl_zwrot+round(NEW.tr_wartosc*NEW.tr_przelicznik,2) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
   IF (NEW.tr_rodzaj=30 ) THEN
       ---dokumenty PZAM tylko dla otwartych dokumentow
    IF (TG_OP='UPDATE') THEN
      IF ((NEW.tr_zamknieta&1::int2)=0 AND (OLD.tr_zamknieta&1::int2)=0) THEN
        UPDATE tg_zlecenia SET zl_planprzychod=zl_planprzychod+round(NEW.tr_wartosc*NEW.tr_przelicznik,2),zl_planprzychodbrt=zl_planprzychodbrt+round(NEW.tr_wartosc*NEW.tr_przelicznik,2)+round(NEW.tr_vat*NEW.tr_przelicznik,2) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
      END IF;
    ELSE
      UPDATE tg_zlecenia SET zl_planprzychod=zl_planprzychod+round(NEW.tr_wartosc*NEW.tr_przelicznik,2),zl_planprzychodbrt=zl_planprzychodbrt+round(NEW.tr_wartosc*NEW.tr_przelicznik,2)+round(NEW.tr_vat*NEW.tr_przelicznik,2) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
    END IF;
   END IF;
  END IF;
 END IF;
 
 -------------koniec czesc dotyczasa zlecen podczepionych do dokumentow
 

 -------------czesc dotyczaca transportow podczepionych do dokumentu

 IF (TG_OP='DELETE' OR TG_OP='UPDATE') THEN
  IF (OLD.lt_idtransportu>0) THEN
   ---wycofujemy uaktualnienie dla starego transportu podpietego do dokumentu 
   IF (((OLD.tr_zamknieta&64)>>6)=1 AND (gm.getKierunekRozrachunku(OLD.tr_flaga,OLD.tr_newflaga)>0)) THEN
    UPDATE tg_transport SET lt_dokkoszt=lt_dokkoszt-round(OLD.tr_wartosc*OLD.tr_przelicznik,2),lt_dokkosztbrt=lt_dokkosztbrt-round(OLD.tr_wartosc*OLD.tr_przelicznik,2)-round(OLD.tr_vat*OLD.tr_przelicznik,2) WHERE lt_idtransportu=OLD.lt_idtransportu;
   END IF;
  END IF; 
 END IF;


 
 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
  IF (NEW.lt_idtransportu>0) THEN
   ---dodajemy uaktualnienie dla nowego transportu podpietego do dokumentu
   IF (((NEW.tr_zamknieta&64)>>6)=1 AND (gm.getKierunekRozrachunku(NEW.tr_flaga,NEW.tr_newflaga)>0)) THEN
    UPDATE tg_transport SET lt_dokkoszt=lt_dokkoszt+round(NEW.tr_wartosc*NEW.tr_przelicznik,2),lt_dokkosztbrt=lt_dokkosztbrt+round(NEW.tr_wartosc*NEW.tr_przelicznik,2)+round(NEW.tr_vat*NEW.tr_przelicznik,2) WHERE lt_idtransportu=NEW.lt_idtransportu;
   END IF;
  END IF;
 END IF;
 
 -------------koniec czesc dotyczasa zlecen podczepionych do dokumentow

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
