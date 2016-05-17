CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 deltawn NUMERIC:=0;
 deltama NUMERIC:=0;
 deltawnbuf NUMERIC:=0;
 deltamabuf NUMERIC:=0;
 deltawnl NUMERIC:=0;
 deltamal NUMERIC:=0;
 deltawml NUMERIC:=0;
 deltawml_nn NUMERIC:=0;
 rec RECORD;
 chnowwn BOOL:=false;
 chnowma BOOL:=false;
 chnowwnob BOOL:=false;
 chnowmaob BOOL:=false;
 chnow BOOL:=false;
BEGIN

------------------------------------------------------------------------
--Przy delete zmieniamy zawsze
IF (TG_OP = 'DELETE') THEN
 chnowwn=TRUE;
 chnowma=TRUE;
 chnow=TRUE;
ELSE
 IF (round(NEW.zp_kwota/NEW.wl_przelicznik,2)<>NEW.zp_kwotawal) THEN
  NEW.zp_kwota=round(NEW.zp_kwotawal*NEW.wl_przelicznik,2);
 END IF;
END IF;
------------------------------------------------------------------------
IF (TG_OP = 'INSERT') THEN
 NEW.zp_numer=(SELECT (nullZero(max(zp_numer)))+1 FROM kh_zapisyelem WHERE zk_idzapisu=NEW.zk_idzapisu);
 NEW.zp_typ=(SELECT zk_typ FROM kh_zapisyhead WHERE zk_idzapisu=NEW.zk_idzapisu);
 NEW.zp_flaga=(NEW.zp_flaga&(~(3<<11)))|(SELECT ((zk_flaga>>1)&3)<<11 FROM kh_zapisyhead WHERE zk_idzapisu=NEW.zk_idzapisu);
 NEW.zp_flaga=(NEW.zp_flaga&(~(64|2|(1<<15))))|nullZero((SELECT 
    (((kt_flaga>>12)&1)<<6)|
    (((kt_flaga>>2)&1)<<1)|
    (((kt_flaga>>15)&1)<<15)
    FROM kh_konta WHERE kt_idkonta=NEW.kt_idkontawn));
 NEW.zp_flaga=(NEW.zp_flaga&(~(128|4|(1<<16))))|nullZero((SELECT 
              (((kt_flaga>>12)&1)<<7)|
              (((kt_flaga>>2)&1)<<2)|
              (((kt_flaga>>15)&1)<<16)
    FROM kh_konta WHERE kt_idkonta=NEW.kt_idkontama));
END IF;

------------------------------------------------------------------------
IF (TG_OP<>'DELETE') THEN

 IF ((NEW.zp_typ&8)<>0) THEN
  NEW.zp_flaga=NEW.zp_flaga|(1<<13);
 ELSE
  NEW.zp_flaga=NEW.zp_flaga&(~(1<<13));
 END IF;
 
 ---Wczesniej bylo nizej
 IF (((NEW.zp_flaga>>11)&3)=2) THEN   ---Czy to predekret  
  NEW.zp_flaga=NEW.zp_flaga|(1<<13);  ---Nie przenos wartosci
 ELSE
  NEW.zp_flaga=NEW.zp_flaga&(~(1<<13));
 END IF;

 ---Przepisz flage zatwierdzenia
 SELECT INTO rec zk_flaga,zk_fullnumer,mn_miesiac,ro_idroku,zk_datadok FROM kh_zapisyhead WHERE zk_idzapisu=NEW.zk_idzapisu;
 NEW.zp_flaga=(NEW.zp_flaga&(~9))|(rec.zk_flaga&9);
 NEW.zp_fullnumer=rec.zk_fullnumer||'/'||NEW.zp_numer;
 NEW.mc_miesiac=rec.mn_miesiac;
 NEW.r_idroku=rec.ro_idroku;
 NEW.zp_datadok=rec.zk_datadok;
 
 IF (NEW.zp_flaga&(1<<18))=0 THEN
  IF ((SELECT ro_borozrachunkowe FROM kh_lata WHERE ro_idroku=NEW.r_idroku)=FALSE) THEN
   --Rok ma flage - przepisz ja na zapis (nie reagujemy na zmiane flagi
   NEW.zp_flaga=NEW.zp_flaga|(1<<18);
  END IF;
 END IF;
 
END IF;
------------------------------------------------------------------------
IF (TG_OP = 'UPDATE') THEN

 IF ((NEW.zp_flaga&16384)<>0) THEN
  NEW.zp_flaga=NEW.zp_flaga&(~16384);
  RETURN NEW;
 END IF;

 IF (NEW.zp_typ<>OLD.zp_typ) THEN
  IF ((NEW.zp_flaga&(1<<17))=0) THEN
   RAISE EXCEPTION 'Nie mozna zmieniac typu zapisu';
  END IF;
  NEW.zp_typ=NEW.zp_typ&(~(1<<17));
 END IF;

 --Zmiana waluty, zaprotestuj
 IF ((NEW.zp_flaga&48)<>(OLD.zp_flaga&48)) THEN
  chnow=TRUE;
  chnowwn=TRUE;
  chnowma=TRUE;
  chnowwnob=TRUE;
  chnowmaob=TRUE;
 END IF;
 ---Zmiana konta Wn, zrob update Wn
 IF (nullZero(NEW.kt_idkontawn)<>nullZero(OLD.kt_idkontawn)) OR ((NEW.zp_flaga&8)!=(OLD.zp_flaga&8)) THEN
  chnowwn=TRUE;
  ---RAISE NOTICE 'Pobieram flage wn';
  NEW.zp_flaga=(NEW.zp_flaga&(~(64|2|(1<<15))))|nullZero((SELECT 
     (((kt_flaga>>12)&1)<<6)|
     (((kt_flaga>>2)&1)<<1)|
     (((kt_flaga>>15)&1)<<15)
     FROM kh_konta WHERE kt_idkonta=NEW.kt_idkontawn));
 END IF;
 ---Zmiana konta Ma, zrob update Ma
 IF (nullZero(NEW.kt_idkontama)<>nullZero(OLD.kt_idkontama)) OR ((NEW.zp_flaga&8)!=(OLD.zp_flaga&8)) THEN
  chnowma=TRUE;
  ----RAISE NOTICE 'Pobieram flage ma';
  NEW.zp_flaga=(NEW.zp_flaga&(~(128|4|(1<<16))))|nullZero((SELECT 
               (((kt_flaga>>12)&1)<<7)|
	           (((kt_flaga>>2)&1)<<2)|
               (((kt_flaga>>15)&1)<<16)
	       FROM kh_konta WHERE kt_idkonta=NEW.kt_idkontama));
 END IF;
 ---Zmiana naglowka, zrob update tego i tego
 IF (nullZero(NEW.zk_idzapisu)<>nullZero(OLD.zk_idzapisu)) THEN
  chnow=TRUE;
 END IF;
 IF (nullZero(NEW.mc_miesiac)<>nullZero(OLD.mc_miesiac)) THEN
  chnowwnob=TRUE;
  chnowmaob=TRUE;
 END IF;
END IF;
------------------------------------------------------------------------
IF (TG_OP<>'DELETE') THEN
 IF (((NEW.zp_flaga>>15)&3)=3) THEN
  RAISE EXCEPTION '41||Konto Wn i konto Ma nie moga miec jednoczesnie wymiarow';
 END IF;
 NEW.kt_idkontawkh=NULL;
 IF ((NEW.zp_flaga&(1<<15))<>0) THEN
  NEW.kt_idkontawkh=NEW.kt_idkontawn;
 END IF;
 IF ((NEW.zp_flaga&(1<<16))<>0) THEN
  NEW.kt_idkontawkh=NEW.kt_idkontama;
 END IF;
END IF;
------------------------------------------------------------------------
IF (TG_OP <> 'INSERT') THEN
 IF ((OLD.zp_flaga&(1<<13))=0) THEN
  deltawnbuf=-OLD.zp_kwota*min(nullZero(OLD.kt_idkontawn),1);
  deltamabuf=-OLD.zp_kwota*min(nullZero(OLD.kt_idkontama),1);
  IF ((OLD.zp_flaga&1)<>0) THEN
   ---Zmiana kwoty Wn na kontach
   deltawn=deltawnbuf;
   deltama=deltamabuf;
  END IF;
 END IF;
 deltawnl=-OLD.zp_kwota*min(nullZero(OLD.kt_idkontawn),1);
 deltamal=-OLD.zp_kwota*min(nullZero(OLD.kt_idkontama),1);
 deltawml=-COALESCE(OLD.zp_dorozpisaniaelemswkh,0);
 --NULL=>min(-1+1,1)=0
 --0=>min(0+1,1)=1
 --1=>min(1+1,1)=1
 deltawml_nn=-min(COALESCE(OLD.zp_dorozpisaniaelemswkh,-1)+1,1);
END IF;
------------------------------------------------------------------------
IF (chnowwn) OR (chnowwnob) THEN
 --Zrob update wartosci na koncie winien
 IF (deltawn<>0 OR deltawnbuf<>0) THEN
  IF (OLD.zp_typ&4=0) THEN
   UPDATE kh_konta SET kt_wn=kt_wn+deltawn,kt_wnbuf=kt_wnbuf+deltawnbuf,kt_flaga=kt_flaga|16 WHERE kt_idkonta=OLD.kt_idkontawn;
  END IF;
  IF (OLD.zp_typ&4=4) THEN
   UPDATE kh_konta SET kt_budzetwn=kt_budzetwn+deltawn,kt_budzetwnbuf=kt_budzetwnbuf+deltawnbuf,kt_flaga=kt_flaga|16 WHERE kt_idkonta=OLD.kt_idkontawn;
  END IF;
  PERFORM ObDodajObroty(OLD.r_idroku,OLD.mc_miesiac,OLD.kt_idkontawn,deltawn,0,deltawnbuf,0,-1,OLD.zp_typ);
  deltawn=0;
  deltawnbuf=0;
 END IF;
END IF;
------------------------------------------------------------------------
IF (chnowma) OR (chnowmaob) THEN
 ---Zrob update wartosci na koncie ma
 IF (deltama<>0 OR deltamabuf<>0) THEN
  IF (OLD.zp_typ&4=0) THEN
   UPDATE kh_konta SET kt_ma=kt_ma+deltama,kt_mabuf=kt_mabuf+deltamabuf,kt_flaga=kt_flaga|16 WHERE kt_idkonta=OLD.kt_idkontama;
  END IF;
  IF (OLD.zp_typ&4=4) THEN
   UPDATE kh_konta SET kt_budzetma=kt_budzetma+deltama,kt_budzetmabuf=kt_budzetmabuf+deltamabuf,kt_flaga=kt_flaga|16 WHERE kt_idkonta=OLD.kt_idkontama;
  END IF;
  PERFORM ObDodajObroty(OLD.r_idroku,OLD.mc_miesiac,OLD.kt_idkontama,0,deltama,0,deltamabuf,-1,OLD.zp_typ);
  deltama=0;
  deltamabuf=0;
 END IF;
END IF;
------------------------------------------------------------------------
IF (chnow) THEN
 --Zrob update na naglowku
 ----RAISE NOTICE 'Mam % %',deltawnl,deltamal;
 IF (deltawnl<>0) OR (deltamal<>0) OR (deltawml<>0) OR (deltawml_nn<>0) THEN
  IF ((OLD.zp_flaga&16)<>0) THEN
   deltawnl=0;
  END IF;
  IF ((OLD.zp_flaga&32)<>0) THEN
   deltamal=0;
  END IF;
  UPDATE kh_zapisyhead SET zk_wn=zk_wn+deltawnl,zk_ma=zk_ma+deltamal,
                           zk_dorozpisaniaelemswkh=zk_dorozpisaniaelemswkh+deltawml,
						   zk_dorozpisaniaelemswkh_nnull=zk_dorozpisaniaelemswkh_nnull+deltawml_nn 
					   WHERE zk_idzapisu=OLD.zk_idzapisu;
  deltawnl=0;
  deltamal=0;
  deltawml=0;
  deltawml_nn=0;
 END IF;
END IF;
------------------------------------------------------------------------
chnowwn:=FALSE;
chnowma:=FALSE;
------------------------------------------------------------------------
IF (TG_OP <> 'DELETE') THEN
 NEW.zp_kwota=round(NEW.zp_kwota,2);
 NEW.wl_przelicznik=NEW.wl_przelicznik;
 
 IF ((NEW.zp_flaga&(1<<18))!=0) THEN
  IF ((NEW.zp_flaga&(2|8|64))=2|8) THEN   ---- Rozrachunkowe/BO/Z klientem = Rozrachunkowe/BO
   NEW.zp_flaga=NEW.zp_flaga&(~2);
  END IF;  
  IF ((NEW.zp_flaga&(4|8|128))=4|8) THEN   ---- Rozrachunkowe/BO/Z klientem = Rozrachunkowe/BO
   NEW.zp_flaga=NEW.zp_flaga&(~4);
  END IF;  
 END IF;
 
 PERFORM vendo.setParam('DONTREVZAPISELEM','1');
 NEW.zp_dorozpisaniaelemswkh=rozpiszWymiaryKH(NEW.zp_idelzapisu,NEW.mc_miesiac,NEW.kt_idkontawkh,NEW.wl_idwaluty,NEW.zp_kwotawal,NEW.zp_kwota,COALESCE(NEW.kt_idkontawkh,0)=COALESCE(NEW.kt_idkontawn,0),(NEW.zp_flaga&1=0));
 PERFORM vendo.setParam('DONTREVZAPISELEM',''); ---''

 ---Przepisz wartosc zatwierdzenia
 IF ((NEW.zp_flaga&(1<<13))=0) THEN
  IF ((NEW.zp_flaga&1)<>0) THEN
   deltawn=deltawn+NEW.zp_kwota*min(nullZero(NEW.kt_idkontawn),1);
   deltama=deltama+NEW.zp_kwota*min(nullZero(NEW.kt_idkontama),1);
  END IF;
  deltawnbuf=deltawnbuf+NEW.zp_kwota*min(nullZero(NEW.kt_idkontawn),1);
  deltamabuf=deltamabuf+NEW.zp_kwota*min(nullZero(NEW.kt_idkontama),1);
 END IF;
 deltawnl=deltawnl+NEW.zp_kwota*min(nullZero(NEW.kt_idkontawn),1);
 deltamal=deltamal+NEW.zp_kwota*min(nullZero(NEW.kt_idkontama),1);  
 deltawml=deltawml+COALESCE(NEW.zp_dorozpisaniaelemswkh,0);
 deltawml_nn=deltawml_nn+min(COALESCE(NEW.zp_dorozpisaniaelemswkh,-1)+1,1);

 IF (TG_OP='INSERT') THEN
  chnowwn:=TRUE; chnowma:=TRUE;
 ELSE
  IF (NEW.wl_idwaluty<>OLD.wl_idwaluty) OR (NEW.wl_przelicznik<>OLD.wl_przelicznik) THEN
   chnowwn:=TRUE; chnowma:=TRUE;
  END IF;
 END IF;

 IF (deltawn<>0) OR (deltawnbuf<>0) OR (chnowwn) THEN
  IF (NEW.zp_typ&4=0) THEN
   UPDATE kh_konta SET kt_wn=kt_wn+deltawn,kt_wnbuf=kt_wnbuf+deltawnbuf,kt_flaga=kt_flaga|16 WHERE kt_idkonta=NEW.kt_idkontawn;
  END IF;
  IF (NEW.zp_typ&4=4) THEN
   UPDATE kh_konta SET kt_budzetwn=kt_budzetwn+deltawn,kt_budzetwnbuf=kt_budzetwnbuf+deltawnbuf,kt_flaga=kt_flaga|16 WHERE kt_idkonta=NEW.kt_idkontawn;
  END IF;
  PERFORM ObDodajObroty(NEW.r_idroku,NEW.mc_miesiac,NEW.kt_idkontawn,deltawn,0,deltawnbuf,0,1,NEW.zp_typ);
 END IF;
 IF (deltama<>0) OR (deltamabuf<>0) OR (chnowma) THEN
  IF (NEW.zp_typ&4=0) THEN
   UPDATE kh_konta SET kt_ma=kt_ma+deltama,kt_mabuf=kt_mabuf+deltamabuf,kt_flaga=kt_flaga|16 WHERE kt_idkonta=NEW.kt_idkontama;
  END IF;
  IF (NEW.zp_typ&4=4) THEN
   UPDATE kh_konta SET kt_budzetma=kt_budzetma+deltama,kt_budzetmabuf=kt_budzetmabuf+deltamabuf,kt_flaga=kt_flaga|16 WHERE kt_idkonta=NEW.kt_idkontama;
  END IF;
  PERFORM ObDodajObroty(NEW.r_idroku,NEW.mc_miesiac,NEW.kt_idkontama,0,deltama,0,deltamabuf,1,NEW.zp_typ);
 END IF;
 IF ((deltawnl<>0) OR (deltamal<>0) OR (deltawml<>0) OR (deltawml_nn!=0)) THEN
  IF ((NEW.zp_flaga&16)<>0) THEN
   deltawnl=0;
  END IF;
  IF ((NEW.zp_flaga&32)<>0) THEN
   deltamal=0;
  END IF;
  UPDATE kh_zapisyhead SET zk_ma=zk_ma+deltamal,
                           zk_wn=zk_wn+deltawnl,
						   zk_dorozpisaniaelemswkh=zk_dorozpisaniaelemswkh+deltawml,
						   zk_dorozpisaniaelemswkh_nnull=zk_dorozpisaniaelemswkh_nnull+deltawml_nn
					   WHERE zk_idzapisu=NEW.zk_idzapisu;
 END IF;
END IF;
------------------------------------------------------------------------
IF (TG_OP='DELETE') THEN
 PERFORM doSkojTransEx(OLD.tr_idtrans,-1,OLD.zp_flaga,OLD.zp_dorozpisaniaelemswkh,OLD.zp_dorozpisaniaelemswkh);
 PERFORM doSkojPlatnosciEx(OLD.pl_idplatnosc,-1,OLD.zp_flaga,OLD.zp_dorozpisaniaelemswkh,OLD.zp_dorozpisaniaelemswkh);
 PERFORM doSkojAmortyzacja(OLD.am_id,-1,OLD.zp_dorozpisaniaelemswkh,OLD.zp_dorozpisaniaelemswkh);
 PERFORM doSkojPlatElem(OLD.pp_idplatelem,-1,0);
END IF;
------------------------------------------------------------------------
IF (TG_OP='INSERT') THEN
 PERFORM doSkojTransEx(NEW.tr_idtrans,1,NEW.zp_flaga,NEW.zp_dorozpisaniaelemswkh,NEW.zp_dorozpisaniaelemswkh);
 PERFORM doSkojPlatnosciEx(NEW.pl_idplatnosc,1,NEW.zp_flaga,NEW.zp_dorozpisaniaelemswkh,NEW.zp_dorozpisaniaelemswkh);
 PERFORM doSkojAmortyzacja(NEW.am_id,1,NEW.zp_dorozpisaniaelemswkh,NEW.zp_dorozpisaniaelemswkh);
 PERFORM doSkojPlatElem(NEW.pp_idplatelem,1,0);
END IF;
------------------------------------------------------------------------
IF (TG_OP='UPDATE') THEN
 IF (
     (NEW.tr_idtrans IS DISTINCT FROM OLD.tr_idtrans) OR
     ((NEW.zp_flaga&(3<<11))!=(OLD.zp_flaga&(3<<11))) OR
     (abs(sign(COALESCE(NEW.zp_dorozpisaniaelemswkh,0)))!=abs(sign(COALESCE(OLD.zp_dorozpisaniaelemswkh,0)))) OR
     (COALESCE(NEW.kt_idkontawkh,0)<>COALESCE(OLD.kt_idkontawkh,0))
    ) 
 THEN
  PERFORM doSkojTransEx(OLD.tr_idtrans,-1,OLD.zp_flaga,OLD.zp_dorozpisaniaelemswkh,OLD.zp_dorozpisaniaelemswkh);
  PERFORM doSkojTransEx(NEW.tr_idtrans,1,NEW.zp_flaga,NEW.zp_dorozpisaniaelemswkh,NEW.zp_dorozpisaniaelemswkh);
 END IF;
 IF (
     (NEW.pl_idplatnosc IS DISTINCT FROM OLD.pl_idplatnosc) OR
     ((NEW.zp_flaga&(3<<11))!=(OLD.zp_flaga&(3<<11))) OR
     (abs(sign(COALESCE(NEW.zp_dorozpisaniaelemswkh,0)))!=abs(sign(COALESCE(OLD.zp_dorozpisaniaelemswkh,0)))) OR
     (COALESCE(NEW.kt_idkontawkh,0)<>COALESCE(OLD.kt_idkontawkh,0))
    )
 THEN
  PERFORM doSkojPlatnosciEx(OLD.pl_idplatnosc,-1,OLD.zp_flaga,OLD.zp_dorozpisaniaelemswkh,OLD.zp_dorozpisaniaelemswkh);
  PERFORM doSkojPlatnosciEx(NEW.pl_idplatnosc,1,NEW.zp_flaga,NEW.zp_dorozpisaniaelemswkh,NEW.zp_dorozpisaniaelemswkh);
 END IF;
 IF (nullZero(NEW.pp_idplatelem)!=nullZero(OLD.pp_idplatelem)) THEN
  PERFORM doSkojPlatelem(OLD.pp_idplatelem,-1,0);
  PERFORM doSkojPlatelem(NEW.pp_idplatelem,1,0);
 END IF;
 IF (nullZero(NEW.am_id)!=nullZero(OLD.am_id)) THEN
  PERFORM doSkojAmortyzacja(OLD.am_id,-1,OLD.zp_dorozpisaniaelemswkh,OLD.zp_dorozpisaniaelemswkh);
  PERFORM doSkojAmortyzacja(NEW.am_id,1,NEW.zp_dorozpisaniaelemswkh,NEW.zp_dorozpisaniaelemswkh);
 END IF;
END IF;


IF (TG_OP <> 'DELETE') THEN
 RETURN NEW;
ELSE
 RETURN OLD;
END IF;

END;$$;
