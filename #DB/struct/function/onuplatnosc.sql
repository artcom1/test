CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 delta_bank NUMERIC:=0;
 changed_bank BOOL:=FALSE;
BEGIN

 -- Dla operacji insert pozostalo=wartosc
 IF (TG_OP = 'INSERT') THEN
  NEW.pl_pozostalo=NEW.pl_wartosc;
  changed_bank=TRUE;
 END IF;

 IF (TG_OP = 'UPDATE') THEN

  IF ( 
       (COALESCE(NEW.k_idklienta,0)<>COALESCE(OLD.k_idklienta,0)) AND
       (COALESCE(NEW.br_idrelacji,0)=COALESCE(OLD.br_idrelacji,0))
     )
  THEN
   NEW.br_idrelacji=NULL;
  END IF;

  IF (NEW.bk_idbanku<>OLD.bk_idbanku) THEN
   changed_bank=TRUE;
  END IF;

  IF ((NEW.pl_flaga&6144)<>4096) AND ((OLD.pl_flaga&6144)=4096) THEN
   NEW.pl_pozostalo=NEW.pl_wartosc;
   IF ((NEW.pl_flaga&1024)<>0) THEN
    NEW.pl_wplyw=1;
   ELSE
    NEW.pl_wplyw=-1;
   END IF;
  END IF;

  IF (NEW.pl_flaga&(1<<22)<>0) THEN
   IF (NEW.pl_flaga&(1<<16)<>0) THEN
    RAISE EXCEPTION '27|%|Platnosc jest juz zaksiegowana',NEW.pl_idplatnosc;
   END IF;
   RAISE NOTICE ':INVO: 19,%',NEW.pl_idplatnosc;
   NEW.pl_flaga=NEW.pl_flaga&(~(1<<22));
  END IF;

 END IF;

 IF (TG_OP<>'DELETE') THEN
  ---Kantor walut
  IF (changed_bank=TRUE) THEN 
   NEW.pl_flaga=(NEW.pl_flaga&(~(getPlatFifoFlag(NULL,NULL)<<19)))|(getPlatFifoFlag(NEW.bk_idbanku,NEW.pl_wplyw)<<19);
  END IF;
  IF (NEW.pl_wplyw<0) THEN
   NEW.pl_wplnfifo=COALESCE(getMinusPlatFifo(NEW.pl_idplatnosc,NEW.bk_idbanku,NEW.pl_wartosc,NEW.wl_idwaluty,NEW.pl_datawplywu,NEW.pl_flaga),round(NEW.pl_wartosc*NEW.wl_przelicznik,2));
   IF (NEW.pl_wplnfifo<>round(NEW.pl_wartosc*NEW.wl_przelicznik,2)) AND (NEW.pl_flaga&(1<<21))<>0 THEN
    NEW.wl_przelicznik=calcKursWaluty(NEW.pl_wplnfifo,NEW.pl_wartosc,NEW.wl_idwaluty);
   END IF;
  ELSE
   NEW.pl_wplnfifo=round(NEW.pl_wartosc*NEW.wl_przelicznik,2);
  END IF;
 END IF;

 --Zmodyfikuj pozostalo jesli jest nierozliczalna lub niewiadoma z mCash
 IF (TG_OP <> 'DELETE') THEN

  NEW.pl_pozostalo=round(NEW.pl_pozostalo,2);

  IF ((NEW.pl_flaga&68)<>0) THEN
   NEW.pl_pozostalo=0;
  END IF;

  IF ((NEW.pl_flaga&384)<>0) THEN
   NEW.pl_pozostalo=0;
   NEW.pl_wplyw=0;
   RETURN NEW;
  END IF;

  IF ((NEW.pl_flaga&6144)=4096) THEN
   NEW.pl_wplyw=0;
   IF (TG_OP = 'UPDATE') THEN
    IF (NEW.pl_pozostalo<>NEW.pl_wartosc) AND ((OLD.pl_flaga&6144)<>(NEW.pl_flaga&6144)) AND ((NEW.pl_flaga&4)=0) THEN
     RAISE EXCEPTION 'Nie mozna anulowac gdyz istnieja platelemy';
     RETURN NEW;
    END IF;
   ELSE
    IF (NEW.pl_pozostalo<>NEW.pl_wartosc) AND ((NEW.pl_flaga&4)=0) THEN
     RAISE EXCEPTION 'Nie mozna anulowac gdyz istnieja platelemy';
     RETURN NEW;
    END IF;
   END IF;
   NEW.pl_pozostalo=0;
  END IF;

 END IF;

 -- Oblicz delta bank i delta zaliczka
 IF (TG_OP = 'INSERT') THEN
  delta_bank=NEW.pl_wartosc*NEW.pl_wplyw;
 END IF;

 IF (TG_OP = 'UPDATE') THEN

  IF ((NEW.pl_flaga&64)<>(OLD.pl_flaga&64)) AND ((NEW.pl_flaga&4)=0) THEN
   NEW.pl_pozostalo=NEW.pl_wartosc;
  END IF;

  IF ((NEW.pl_flaga&3)<>(OLD.pl_flaga&3)) THEN
   RAISE EXCEPTION 'Nie mozna zmieniac tych parametrow platnosci';
  END IF;

  IF ((NEW.pl_flaga&4)<>(OLD.pl_flaga&4)) AND NOT (((NEW.pl_flaga&64)=0) AND ((OLD.pl_flaga&64)<>0)) THEN
   IF ((NEW.pl_flaga&4)<>0) AND (round(OLD.pl_pozostalo,2)<>round(OLD.pl_wartosc,2)) THEN
    RAISE EXCEPTION 'Nie mozna uczynic nierozliczalna - sa jakies platelemy';
   END IF;
   IF ((NEW.pl_flaga&4)=0) AND (NEW.pl_pozostalo=0) THEN
    NEW.pl_pozostalo=NEW.pl_wartosc;
   ELSE
    NEW.pl_pozostalo=0;
   END IF;
  END IF;

  --- Nie mozna zmniejszyc wartosci ponizej pozostalo
  IF (NEW.pl_pozostalo>NEW.pl_wartosc) AND ((NEW.pl_flaga&8192)=0) THEN
   RAISE EXCEPTION 'Nie mozna wykonac operacji wrt dodatnia';
  END IF;

  -- Nie moze pozostac wartosc ujemna (?)
  IF (NEW.pl_pozostalo<0) AND ((NEW.pl_flaga&8192)=0)  THEN
   RAISE EXCEPTION 'Nie mozna wykonac operacji wrt ujemna % ',NEW.pl_pozostalo;
  END IF;

  --Oblicz old delty
  delta_bank=delta_bank-OLD.pl_wartosc*OLD.pl_wplyw;

  --Jesli zmienil sie bank przelicz wartosci
  IF (NEW.bk_idbanku<>OLD.bk_idbanku) THEN
   UPDATE ts_banki SET bk_bilans=bk_bilans+delta_bank WHERE bk_idbanku=OLD.bk_idbanku;
   delta_bank=0;
  END IF;

  delta_bank=delta_bank+NEW.pl_wartosc*NEW.pl_wplyw;
 END IF;

-------------czesc dotyczaca zlecen podczepionych do platnosci
 IF (TG_OP='DELETE' OR TG_OP='UPDATE') THEN
  IF (OLD.zl_idzlecenia>0) THEN
   ---wycofujemy dane platnosci ze starego zlecenia podpietego do platnosci
    IF (OLD.pl_wplyw>0) THEN
     UPDATE tg_zlecenia SET zl_sumawplat=zl_sumawplat-(OLD.pl_wartosc*OLD.wl_przelicznik) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
    END IF;
    IF (OLD.pl_wplyw<0) THEN
     UPDATE tg_zlecenia SET zl_wyplaty=zl_wyplaty-(OLD.pl_wartosc*OLD.wl_przelicznik) WHERE zl_idzlecenia=OLD.zl_idzlecenia;
    END IF;
  END IF;
 END IF;

 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
  IF (NEW.zl_idzlecenia>0) THEN
   ---dodajemy uaktualnienie dla nowego zlecenia podpietego do dokumentu
    IF (NEW.pl_wplyw>0) THEN
     UPDATE tg_zlecenia SET zl_sumawplat=zl_sumawplat+(NEW.pl_wartosc*NEW.wl_przelicznik) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
    END IF;
    IF (NEW.pl_wplyw<0) THEN
     UPDATE tg_zlecenia SET zl_wyplaty=zl_wyplaty+(NEW.pl_wartosc*NEW.wl_przelicznik) WHERE zl_idzlecenia=NEW.zl_idzlecenia;
    END IF;
  END IF;
 END IF;
 
 -------------koniec czesc dotyczasa zlecen podczepionych do platnosci
 
 -------------czesc dotyczaca transportow podczepionych do platnosci
 IF (TG_OP='DELETE' OR TG_OP='UPDATE') THEN
  IF (OLD.lt_idtransportu>0) THEN
   ---wycofujemy dane platnosci ze starego zlecenia podpietego do platnosci
    IF (OLD.pl_wplyw<0) THEN
     UPDATE tg_transport SET lt_wyplaty=lt_wyplaty-(OLD.pl_wartosc*OLD.wl_przelicznik), lt_nierozliczone=lt_nierozliczone-(OLD.pl_pozostalo*OLD.wl_przelicznik)  WHERE lt_idtransportu=OLD.lt_idtransportu;
    END IF;
  END IF;
 END IF;
 
 IF (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
  IF (NEW.lt_idtransportu>0) THEN
   ---dodajemy uaktualnienie dla nowego zlecenia podpietego do dokumentu
    IF (NEW.pl_wplyw<0) THEN
     UPDATE tg_transport SET lt_wyplaty=lt_wyplaty+(NEW.pl_wartosc*NEW.wl_przelicznik), lt_nierozliczone=lt_nierozliczone+(NEW.pl_pozostalo*NEW.wl_przelicznik) WHERE lt_idtransportu=NEW.lt_idtransportu;
    END IF;
  END IF;
 END IF;

 -------------koniec czesc dotyczasa transportow podczepionych do platnosci

 -- Przelicz na nowo wartosci powiazane
 IF (TG_OP <> 'DELETE') THEN

  IF (delta_bank<>0) THEN
   UPDATE ts_banki SET bk_bilans=bk_bilans+delta_bank WHERE bk_idbanku=NEW.bk_idbanku;
  END IF;

 ELSE
  ---Zmodyfikuj wartosc
  IF (OLD.pl_wartosc<>0) THEN
   UPDATE ts_banki SET bk_bilans=bk_bilans-OLD.pl_wartosc*OLD.pl_wplyw*OLD.wl_przelicznik WHERE bk_idbanku=OLD.bk_idbanku;
  END IF;
  IF (OLD.pl_flaga&(1<<18)<>0) AND (OLD.pl_idplatnoscskoj IS NOT NULL) THEN
   --Skasuj skojarzona platnosc
   DELETE FROM kh_platnosci WHERE pl_idplatnosc=OLD.pl_idplatnoscskoj AND pl_flaga&(1<<18)<>0;
  END IF;
  RETURN OLD;
 END IF;


 RETURN NEW;
END;
$$;
