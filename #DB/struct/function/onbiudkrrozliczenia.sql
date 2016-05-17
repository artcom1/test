CREATE FUNCTION onbiudkrrozliczenia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 rl              RECORD;        --- Lewy rekord
 rr              RECORD;        --- Prawy rekord
 wsp             NUMERIC:=1;   --- Wspolczynnik
 kurs            MPQ;
 doprzeliczenie BOOL:=FALSE;
BEGIN

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Pobranie danych z rozrachunku
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  SELECT rr_kwotawal,rr_wartoscpln,rr_wartoscpozwal,rr_wartoscpozpln,rr_flaga,rr_idwaluty,rr_isbufor,rr_isnormal,rr_iswn,tr_idtrans,rr_datadokumentu INTO rl FROM kr_rozrachunki WHERE rr_idrozrachunku=NEW.rr_idrozrachunkul;
  SELECT rr_kwotawal,rr_wartoscpln,rr_wartoscpozwal,rr_wartoscpozpln,rr_flaga,rr_idwaluty,rr_isbufor,rr_isnormal,rr_iswn,tr_idtrans,rr_datadokumentu INTO rr FROM kr_rozrachunki WHERE rr_idrozrachunku=NEW.rr_idrozrachunkur;
 ELSE
  SELECT rr_kwotawal,rr_wartoscpln,rr_wartoscpozwal,rr_wartoscpozpln,rr_flaga,rr_idwaluty,tr_idtrans INTO rl FROM kr_rozrachunki WHERE rr_idrozrachunku=OLD.rr_idrozrachunkul;
  SELECT rr_kwotawal,rr_wartoscpln,rr_wartoscpozwal,rr_wartoscpozpln,rr_flaga,rr_idwaluty,tr_idtrans INTO rr FROM kr_rozrachunki WHERE rr_idrozrachunku=OLD.rr_idrozrachunkur;
  IF (OLD.rl_flaga&1=1) THEN
   PERFORM checkRozliczenieZaliczkowe(OLD.rr_idrozrachunkur);
  END IF;
  IF (OLD.rl_flaga&2=2) THEN
   PERFORM checkRozliczenieZaliczkowe(OLD.rr_idrozrachunkul);
  END IF;
  IF (OLD.rl_flaga&129=129) THEN
   PERFORM checkFlagaAlgorytmuVAT(rr.tr_idtrans,OLD.rl_idrozliczenia);
  END IF;
  IF (OLD.rl_flaga&130=130) THEN
   PERFORM checkFlagaAlgorytmuVAT(rl.tr_idtrans,OLD.rl_idrozliczenia);
  END IF;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Pobranie danych z rozrachunku
 -------------------------------------------------------------------------------------------------------------

 IF (TG_OP<>'DELETE') THEN
  IF (TG_OP='INSERT') THEN
   doprzeliczenie=TRUE;
  END IF;
  IF (NEW.rl_flaga&256=256) THEN
   doprzeliczenie=TRUE;
  END IF;
 END IF;

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Obliczanie kwoty rozliczenia
 -------------------------------------------------------------------------------------------------------------
 IF (doprzeliczenie=TRUE) THEN
  NEW.rl_flaga=NEW.rl_flaga&(~256);
  --- Faktury zaliczkowe
  IF (rl.rr_flaga&7=1) THEN
   NEW.rl_flaga=NEW.rl_flaga|1;
   PERFORM checkRozliczenieZaliczkowe(NEW.rr_idrozrachunkur);
  END IF;
  IF (rr.rr_flaga&7=1) THEN
   NEW.rl_flaga=NEW.rl_flaga|2;
   PERFORM checkRozliczenieZaliczkowe(NEW.rr_idrozrachunkul);
  END IF;
  IF (rl.rr_isbufor=true) THEN
   NEW.rl_flaga=NEW.rl_flaga|4;
  END IF;
  IF (rr.rr_isbufor=true) THEN
   NEW.rl_flaga=NEW.rl_flaga|8;
  END IF;
  IF (rl.rr_iswn=true) THEN
   NEW.rl_flaga=NEW.rl_flaga|16;
  END IF;
  IF (rr.rr_iswn=true) THEN
   NEW.rl_flaga=NEW.rl_flaga|32;
  END IF;
  IF (rl.rr_isnormal=false OR rr.rr_isnormal=false) THEN
   RAISE EXCEPTION '17|%:%|Blad rozliczenia',rl.tr_idtrans,rr.tr_idtrans;
  END IF;
  --- Obydwie strony rozliczaja faktury zaliczkowe (korekta faktury zaliczkowej)
  IF (NEW.rl_flaga&3=3) THEN
   NEW.rl_wartoscwall=min(abs(rl.rr_wartoscpozwal),abs(rr.rr_wartoscpozwal))*sign(rl.rr_wartoscpozwal);
   NEW.rl_wartoscwalr=min(abs(rl.rr_wartoscpozwal),abs(rr.rr_wartoscpozwal))*sign(rr.rr_wartoscpozwal);
  END IF;

  IF (NEW.rl_idrozliczenia_rk IS NULL) THEN
   IF (rl.rr_flaga&(1<<22)<>0) THEN
    NEW.rl_wartoscplnl=sign(NEW.rl_wartoscwall)*getminusplatfifoRL(NEW.rl_idrozliczenia,NEW.rr_idrozrachunkul,NEW.rl_wartoscwall*sign(NEW.rl_wartoscwall),rl.rr_idwaluty);
---    RAISE NOTICE 'Left % %',NEW.rl_wartoscwall,NEW.rl_wartoscplnl;
---    RAISE NOTICE 'Jest Lf %',NEW.rl_wartoscplnl;
   ELSE 
    IF (NEW.rl_wartoscwall=rl.rr_wartoscpozwal) THEN
     NEW.rl_wartoscplnl=rl.rr_wartoscpozpln;
    ELSE
     IF (rl.rr_kwotawal<>0) THEN
      kurs=calcKursWaluty(rl.rr_wartoscpln,rl.rr_kwotawal,rl.rr_idwaluty);
     ELSE
      kurs=1;
     END IF;
     IF (kurs=1) THEN
      NEW.rl_wartoscplnl=NEW.rl_wartoscwall;
     ELSE
      IF (TG_OP<>'INSERT') THEN
       rl.rr_wartoscpozpln=abs(rl.rr_wartoscpozpln)+abs(OLD.rl_wartoscplnl+OLD.rl_roznicekursowel);
---       RAISE NOTICE 'Jest L %',rl.rr_wartoscpozpln;
      END IF;
      NEW.rl_wartoscplnl=sign(NEW.rl_wartoscwall)*floorRoundMax(kurs*abs(NEW.rl_wartoscwall),abs(rl.rr_wartoscpozpln));
     END IF;
    END IF;
    NEW.rl_roznicekursowel=0;
   END IF;

---   RAISE NOTICE 'Tutaj % i %',NEW.rl_wartoscplnl,rl.rr_wartoscpozpln;

   IF (rr.rr_flaga&(1<<22)<>0) THEN
    NEW.rl_wartoscplnr=sign(NEW.rl_wartoscwalr)*getminusplatfifoRL(NEW.rl_idrozliczenia,NEW.rr_idrozrachunkur,NEW.rl_wartoscwalr*sign(NEW.rl_wartoscwalr),rr.rr_idwaluty);
---    RAISE NOTICE 'Right % %',NEW.rl_wartoscwalr,NEW.rl_wartoscplnr;
---      RAISE NOTICE 'Jest Rf %',NEW.rl_wartoscplnr;
   ELSE 
    IF (NEW.rl_wartoscwalr=rr.rr_wartoscpozwal) THEN
     NEW.rl_wartoscplnr=rr.rr_wartoscpozpln;
    ELSE
     IF (rr.rr_kwotawal<>0) THEN
      kurs=calcKursWaluty(rr.rr_wartoscpln,rr.rr_kwotawal,rr.rr_idwaluty);
     ELSE
      kurs=1;
     END IF;
     IF (kurs=1) THEN
      NEW.rl_wartoscplnr=NEW.rl_wartoscwalr;
     ELSE
      IF (TG_OP<>'INSERT') THEN
       rr.rr_wartoscpozpln=abs(rr.rr_wartoscpozpln)+abs(OLD.rl_wartoscplnr+OLD.rl_roznicekursower);
---       RAISE NOTICE 'Jest R %',rr.rr_wartoscpozpln;
      END IF;
      NEW.rl_wartoscplnr=sign(NEW.rl_wartoscwalr)*floorRoundMax(kurs*abs(NEW.rl_wartoscwalr),abs(rr.rr_wartoscpozpln));
     END IF;
    END IF;
   END IF;
   NEW.rl_roznicekursower=0;
  END IF;

  ----RAISE EXCEPTION 'ROzliczenie % i % ',NEW.rl_wartoscwall,NEW.rl_wartoscplnl;

 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Obliczanie kwoty rozliczenia
 -------------------------------------------------------------------------------------------------------------


 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Obliczenie roznic kursowych
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN

  IF (TG_OP='UPDATE') THEN
   NEW.rl_wartoscplnl=NEW.rl_wartoscplnl+NEW.rl_roznicekursowel;
   NEW.rl_wartoscplnr=NEW.rl_wartoscplnr+NEW.rl_roznicekursower;
  END IF;

  IF (NEW.km_idkompensaty IS NULL) THEN 
   NEW.rl_datamax=max(rl.rr_datadokumentu,rr.rr_datadokumentu);
  ELSE
   NEW.rl_datamax=(SELECT km_datakomp FROM kr_kompensaty AS km WHERE km.km_idkompensaty=NEW.km_idkompensaty);
  END IF;
 

  --- Oblicz roznice kursowe (+ znaczy zysk, - strata)
  NEW.rl_roznicekursowel=NEW.rl_wartoscplnl+NEW.rl_wartoscplnr;

  IF (sign(NEW.rl_roznicekursowel)=sign(NEW.rl_wartoscplnl)) THEN
   NEW.rl_wartoscplnl=NEW.rl_wartoscplnl-NEW.rl_roznicekursowel;
   NEW.rl_roznicekursower=0;
  ELSE
   NEW.rl_roznicekursower=NEW.rl_roznicekursowel;
   NEW.rl_roznicekursowel=0;
   NEW.rl_wartoscplnr=NEW.rl_wartoscplnr-NEW.rl_roznicekursower;
  END IF;

 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Obliczenie roznic kursowych
 -------------------------------------------------------------------------------------------------------------

 IF (TG_OP<>'DELETE') THEN
  --RAISE NOTICE '%: Rozrachunek % % % % ',NEW.rl_idrozliczenia,NEW.rl_wartoscwall,NEW.rl_wartoscwalr,NEW.rl_wartoscplnl,NEW.rl_wartoscplnr;
  IF (sign(NEW.rl_wartoscplnl*NEW.rl_wartoscplnr)>=0) THEN
   IF (NEW.rl_wartoscplnl<>0 OR NEW.rl_wartoscplnr<>0) THEN
    RAISE EXCEPTION 'Bledny rozrachunek % (% i %) % % % % kurs %',NEW.rl_idrozliczenia,NEW.rr_idrozrachunkul,NEW.rr_idrozrachunkur,NEW.rl_wartoscwall,NEW.rl_wartoscwalr,NEW.rl_wartoscplnl,NEW.rl_wartoscplnr,kurs;
   END IF;
  END IF;
 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END
$$;
