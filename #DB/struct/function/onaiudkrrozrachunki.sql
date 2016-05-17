CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 dwartoscroz  v.delta;  --OK
 dzadluzenie  v.delta;  --OK
 dzadluzeniez v.delta;  --OK
 dzaliczka    v.delta;  --OK
 updatetrans INT:=0;
 fm_idind INT:=0;
 tmp  INT:=0;
BEGIN
   
 ---------------------------------------------------------
 ---Pobieranie identyfikatora dla typow tablicowych
 ---------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  fm_idind=(SELECT fm_idindextab FROM tb_firma  WHERE fm_index=NEW.fm_idcentrali);
 ELSE
  fm_idind=(SELECT fm_idindextab FROM tb_firma  WHERE fm_index=OLD.fm_idcentrali);
 END IF;

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Obliczenie delty
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'INSERT') THEN
  dwartoscroz.id_old=COALESCE(-OLD.pl_idplatnosc,OLD.tr_idtrans);
  IF (OLD.rr_flaga&7 IN (0,4)) THEN
   dwartoscroz.value_old=floorRoundMax((OLD.rr_kwotawal-OLD.rr_wartoscpozwal)*gm.calcKursSafe(OLD.rr_kwotawalfornorm,OLD.rr_kwotawal)*sign(OLD.rr_kwotawal),OLD.rr_kwotawal*sign(OLD.rr_kwotawal))*sign(OLD.rr_kwotawal);
   IF (OLD.rr_isnormal=TRUE AND ((OLD.rr_flaga>>7)&3<>0) AND (OLD.rr_flaga&7=0) AND ((OLD.rr_flaga>>28)&1=0)) THEN
	dzadluzenie.value_old=OLD.rr_wartoscpozpln;
	dzadluzenie.id_old=OLD.k_idklienta;
    IF (OLD.rr_isbufor=FALSE) THEN
	 dzadluzeniez.value_old=OLD.rr_wartoscpozpln;
	 dzadluzeniez.id_old=OLD.k_idklienta;
    END IF;
   END IF;
  END IF;
  IF (OLD.rr_flaga&7 IN (1,2)) THEN
   updatetrans=updatetrans|1;
  END IF;
  IF (OLD.rr_isnormal=TRUE AND OLD.rr_isbufor=FALSE AND (((OLD.rr_flaga>>7)&12<>0) OR (OLD.rr_flaga&7=1))) THEN
   ---dzaliczkao=dzaliczkao+OLD.rr_wartoscpozpln;
   dzaliczka.value_old=OLD.rr_wartoscpozpln;
   dzaliczka.id_old=OLD.k_idklienta;
  END IF;
 END IF;
 
 IF (TG_OP<>'DELETE') THEN
  dwartoscroz.id_new=COALESCE(-NEW.pl_idplatnosc,NEW.tr_idtrans);
  IF (NEW.rr_flaga&7 IN (0,4)) THEN
   dwartoscroz.value_new=floorRoundMax((NEW.rr_kwotawal-NEW.rr_wartoscpozwal)*gm.calcKursSafe(NEW.rr_kwotawalfornorm,NEW.rr_kwotawal)*sign(NEW.rr_kwotawal),NEW.rr_kwotawal*sign(NEW.rr_kwotawal))*sign(NEW.rr_kwotawal);
   IF (NEW.rr_isnormal=TRUE AND ((NEW.rr_flaga>>7)&3<>0) AND (NEW.rr_flaga&7=0) AND ((NEW.rr_flaga>>28)&1=0)) THEN
	dzadluzenie.value_new=NEW.rr_wartoscpozpln;
	dzadluzenie.id_new=NEW.k_idklienta;
    IF (NEW.rr_isbufor=FALSE) THEN
	 dzadluzeniez.value_new=NEW.rr_wartoscpozpln;
	 dzadluzeniez.id_new=NEW.k_idklienta;
    END IF;
   END IF;
  END IF;
  IF (NEW.rr_flaga&7 IN (1,2)) THEN
   updatetrans=updatetrans|2;
  END IF;
  IF (NEW.rr_isnormal=TRUE AND NEW.rr_isbufor=FALSE AND (((NEW.rr_flaga>>7)&12<>0) OR (NEW.rr_flaga&7=1))) THEN
   ----dzaliczkan=dzaliczkan-NEW.rr_wartoscpozpln;
   dzaliczka.value_new=NEW.rr_wartoscpozpln;
   dzaliczka.id_new=NEW.k_idklienta;
  END IF;
 END IF;
 IF (TG_OP='UPDATE') THEN
  updatetrans=updatetrans&(~1);
 END IF;
 
 IF (v.deltavalueold(dwartoscroz)<>0) OR (updatetrans&1=1) THEN
  IF (dwartoscroz.id_old<0) THEN
   UPDATE kh_platnosci SET pl_pozostalo=(CASE WHEN pl_wplyw=-1 THEN pl_pozostalo+v.deltavalueold(dwartoscroz) ELSE pl_pozostalo-v.deltavalueold(dwartoscroz) END) WHERE pl_idplatnosc=-dwartoscroz.id_old;
  END IF;
  IF (dwartoscroz.id_old>0) OR (OLD.tr_idtrans IS NOT NULL AND updatetrans&1=1) THEN
   UPDATE tg_transakcje SET 
    tr_zaplacono=tr_zaplacono-(-gm.getKierunekRozrachunku(tr_flaga,tr_newflaga)*v.deltavalueold(dwartoscroz)),
    tr_flaga=(tr_flaga&(~(1<<17)))|(CASE WHEN (SELECT rr_idrozrachunku FROM kr_rozrachunki AS rr WHERE rr.tr_idtrans=tg_transakcje.tr_idtrans AND rr_wartoscpozwal<>0 AND rr_flaga&7=1 LIMIT 1) IS NOT NULL THEN 1<<17 ELSE 0 END)
    WHERE tr_idtrans=dwartoscroz.id_old;
  END IF;
 END IF;
 
 
 IF ((v.deltavaluenew(dwartoscroz)<>0) AND dwartoscroz.id_new IS NOT NULL) OR (updatetrans&2=2) THEN
  
  IF (dwartoscroz.id_new<0) THEN
   UPDATE kh_platnosci SET pl_pozostalo=(CASE WHEN pl_wplyw=-1 THEN pl_pozostalo-v.deltavaluenew(dwartoscroz) ELSE pl_pozostalo+v.deltavaluenew(dwartoscroz) END) WHERE pl_idplatnosc=-dwartoscroz.id_new;
  END IF;
  IF (dwartoscroz.id_new>0) OR (NEW.tr_idtrans IS NOT NULL AND updatetrans&2=2) THEN
   UPDATE tg_transakcje SET 
    tr_zaplacono=tr_zaplacono+(-gm.getKierunekRozrachunku(tr_flaga,tr_newflaga)*v.deltavaluenew(dwartoscroz)),
    tr_flaga=(tr_flaga&(~(1<<17)))|(CASE WHEN (SELECT rr_idrozrachunku FROM kr_rozrachunki AS rr WHERE rr.tr_idtrans=tg_transakcje.tr_idtrans AND rr_wartoscpozwal<>0 AND rr_flaga&7=1 LIMIT 1) IS NOT NULL THEN 1<<17 ELSE 0 END)
    WHERE tr_idtrans=dwartoscroz.id_new;
  END IF;
 END IF;
 
 IF (v.deltavalueold(dzadluzenie)<>0 OR v.deltavalueold(dzadluzeniez)<>0 OR v.deltavalueold(dzaliczka)<>0) THEN
  UPDATE tb_klient SET 
   k_zadluzenie[fm_idind]=NullZero(k_zadluzenie[fm_idind])-v.deltavalueold(dzadluzeniez),
   k_zadluzenieniezamk[fm_idind]=NullZero(k_zadluzenieniezamk[fm_idind])-v.deltavalueold(dzadluzenie),
   k_zaliczka[fm_idind]=NullZero(k_zaliczka[fm_idind])+v.deltavalueold(dzaliczka) 
  WHERE k_idklienta=COALESCE(dzadluzenie.id_old,dzadluzeniez.id_old,dzaliczka.id_old);
  PERFORM UpdateRecChange(1,COALESCE(dzadluzenie.id_old,dzadluzeniez.id_old,dzaliczka.id_old));
 END IF;
 IF (v.deltavaluenew(dzadluzenie)<>0 OR v.deltavaluenew(dzadluzeniez)<>0 OR v.deltavaluenew(dzaliczka)<>0) THEN
  UPDATE tb_klient SET 
   k_zadluzenie[fm_idind]=NullZero(k_zadluzenie[fm_idind])+v.deltavaluenew(dzadluzeniez),
   k_zadluzenieniezamk[fm_idind]=NullZero(k_zadluzenieniezamk[fm_idind])+v.deltavaluenew(dzadluzenie),
   k_zaliczka[fm_idind]=NullZero(k_zaliczka[fm_idind])-v.deltavaluenew(dzaliczka) 
  WHERE k_idklienta=COALESCE(dzadluzenie.id_new,dzadluzeniez.id_new,dzaliczka.id_new);
  PERFORM UpdateRecChange(1,COALESCE(dzadluzenie.id_new,dzadluzeniez.id_new,dzaliczka.id_new));
---  RAISE NOTICE ':INVO: 1,%',NEW.k_idklienta;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Obliczenie delty
 -------------------------------------------------------------------------------------------------------------

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Faktury zaliczkowe
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  IF (NEW.rr_flaga&7=1) THEN
   IF (NEW.rr_no=1) THEN
    PERFORM gm.createVatZal(NEW.tr_idtrans,NULL::int,NEW.rr_idrozrachunku);
   ELSE
    PERFORM gm.createVatZal(NEW.tr_idtrans,NEW.rr_idrozrachunku,NULL::int);
   END IF;
  END IF;
  --- Skasuj te rozrachunki ktore nie sa do niczego podczepione i nie sa roznicami kursowymi
  IF (NEW.rr_flaga&8064=0) AND (NEW.rr_flaga&7 NOT IN (3)) THEN
   DELETE FROM kr_rozrachunki WHERE rr_idrozrachunku=NEW.rr_idrozrachunku;
  END IF;
 END IF;
 IF (TG_OP='INSERT') THEN
  IF (NEW.rr_flaga&7=4) THEN
   UPDATE tg_transakcje SET tr_idtrans=tr_idtrans WHERE tr_idtrans=NEW.tr_idtrans;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  IF (OLD.rr_flaga&7=4) THEN
   IF ((SELECT tr_zamknieta&1 FROM tg_transakcje WHERE tr_idtrans=OLD.tr_idtrans)=1) THEN
    RAISE EXCEPTION '15|%|Dokument rozliczajacy jest juz zamkniety ',OLD.tr_idtrans;
   END IF;
   UPDATE tg_transakcje SET tr_idtrans=tr_idtrans WHERE tr_idtrans=OLD.tr_idtrans;
  END IF;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Faktury zaliczkowe
 -------------------------------------------------------------------------------------------------------------

 -----------------------------------------------------------------------------------------
 --- STARTOF: Sprawdzanie dla roznic kursowych
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP='DELETE') THEN

  IF (OLD.rr_flaga&7=3) AND (OLD.zp_idelzapisu IS NOT NULL) THEN
   RAISE EXCEPTION '19|%|Roznice kursowe sa juz w KH ',OLD.rr_idrozrachunku;
  END IF;

  IF (OLD.st_idstatusu IS NOT NULL) THEN
   RAISE EXCEPTION '42|219:%|Rozrachunek ma status',OLD.rr_idrozrachunku;
  END IF;

 END IF;
 IF (TG_OP='UPDATE') THEN
  IF (NEW.rr_flaga&7=3) AND (OLD.rr_kwotawal<>NEW.rr_kwotawal) AND (OLD.zp_idelzapisu IS NOT NULL) THEN
   RAISE EXCEPTION '19|%|Roznice kursowe sa juz w KH ',OLD.rr_idrozrachunku;
  END IF;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Sprawdzanie dla roznic kursowych
 -------------------------------------------------------------------------------------------------------------

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Sprawdzanie dla komepnsat
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  IF ((NEW.rr_flaga&7)=5) AND ((NEW.rr_flaga&(1<<21))<>0) AND (NEW.rr_wartoscpozpln<>0) THEN
   RAISE EXCEPTION '30|%:%|Blad rozrachunku kompensaty %',NEW.rr_idrozrachunku,NEW.pl_idplatnosc,NEW.rr_wartoscpozpln;
  END IF;
  IF (NEW.zp_idelzapisu IS NOT NULL) THEN
   UPDATE kh_zapisyelem SET zp_dataplatnosci=NEW.rr_dataplatnosci WHERE zp_idelzapisu=NEW.zp_idelzapisu AND (zp_dataplatnosci<>NEW.rr_dataplatnosci OR zp_dataplatnosci IS NULL);   
  END IF;
 END IF;

 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Sprawdzanie dla komepnsat
 -------------------------------------------------------------------------------------------------------------

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Sprawdzanie dat
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP='UPDATE') THEN
  IF (NEW.rr_datadokumentu<>OLD.rr_datadokumentu) THEN
   UPDATE kr_rozliczenia SET rl_idrozliczenia=rl_idrozliczenia WHERE rr_idrozrachunkul=NEW.rr_idrozrachunku OR rr_idrozrachunkur=NEW.rr_idrozrachunku;
  END IF;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Sprawdzanie dat
 -------------------------------------------------------------------------------------------------------------

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Sprawdzanie informacji o zdarzeniach windykacyjnych
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP='UPDATE') THEN
  IF ((NEW.rr_flaga&(1<<23))<>(OLD.rr_flaga&(1<<23))) THEN
   ---zmieniala sie informacja o zdarzeniach windykacyjnych
   IF ((NEW.rr_flaga&(1<<23))!=0 AND NEW.tr_idtrans>0) THEN 
   ---nadajemy informacja na transakcje
    UPDATE tg_transakcje SET tr_zamknieta=tr_zamknieta|16384, tr_newflaga=tr_newflaga|16 WHERE tr_idtrans=NEW.tr_idtrans;
   END IF;
   IF ((NEW.rr_flaga&(1<<23))=0 AND NEW.tr_idtrans>0) THEN 
   ---jesli nie ma innych zdarzen windykacyjnych do dokumentu to zdejmujemy informacje
    tmp=(SELECT count(*) FROM kr_rozrachunki WHERE tr_idtrans=NEW.tr_idtrans AND rr_flaga&(1<<23)=(1<<23)  AND  rr_idrozrachunku<>OLD.rr_idrozrachunku);

    IF (tmp=0) THEN ---zdejmujemy informacje o zdarzeniu windykacyjnym
     UPDATE tg_transakcje SET tr_zamknieta=tr_zamknieta|16384, tr_newflaga=tr_newflaga&(~16)  WHERE tr_idtrans=NEW.tr_idtrans;
    END IF;
   END IF;
  END IF;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Sprawdzanie informacji o zdarzeniach windykacyjnych
 -------------------------------------------------------------------------------------------------------------


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END
$$;
