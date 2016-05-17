CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 wartoscwallo    NUMERIC:=0;
 wartoscwalln    NUMERIC:=0;
 wartoscwalro    NUMERIC:=0;
 wartoscwalrn    NUMERIC:=0;
 wartoscplnlo    NUMERIC:=0;
 wartoscplnln    NUMERIC:=0;
 wartoscplnro    NUMERIC:=0;
 wartoscplnrn    NUMERIC:=0;
 saldokmwno      NUMERIC:=0;
 saldokmmao      NUMERIC:=0;
 saldokmwnn      NUMERIC:=0;
 saldokmman      NUMERIC:=0;
BEGIN

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Obliczanie OLDow
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'INSERT') THEN
  wartoscwallo=-OLD.rl_wartoscwall;
  wartoscplnlo=-OLD.rl_wartoscplnl;
  wartoscwalro=-OLD.rl_wartoscwalr;
  wartoscplnro=-OLD.rl_wartoscplnr;
  IF (OLD.km_idkompensaty IS NOT NULL) THEN
   IF (OLD.rl_flaga&16=16) THEN saldokmwno=saldokmwno-OLD.rl_wartoscplnl; ELSE saldokmmao=saldokmmao-(-OLD.rl_wartoscplnl); END IF;
   IF (OLD.rl_flaga&32=32) THEN saldokmwno=saldokmwno-OLD.rl_wartoscplnr; ELSE saldokmmao=saldokmmao-(-OLD.rl_wartoscplnr); END IF;
  END IF;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Obliczanie OLDow
 -------------------------------------------------------------------------------------------------------------

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Update zaleznych
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  --- Oblicz roznice kursowe (+ znaczy zysk, - strata)
  wartoscwalln=NEW.rl_wartoscwall;
  wartoscplnln=NEW.rl_wartoscplnl;
  wartoscwalrn=NEW.rl_wartoscwalr;
  wartoscplnrn=NEW.rl_wartoscplnr;
  IF (NEW.km_idkompensaty IS NOT NULL) THEN
   IF (NEW.rl_flaga&16=16) THEN saldokmwnn=saldokmwnn+NEW.rl_wartoscplnl; ELSE saldokmman=saldokmman+(-NEW.rl_wartoscplnl); END IF;
   IF (NEW.rl_flaga&32=32) THEN saldokmwnn=saldokmwnn+NEW.rl_wartoscplnr; ELSE saldokmman=saldokmman+(-NEW.rl_wartoscplnr); END IF;
  END IF;
 END IF;
 IF (TG_OP='UPDATE') THEN
  IF (NEW.rr_idrozrachunkul=OLD.rr_idrozrachunkul) THEN
   wartoscwalln=wartoscwalln+wartoscwallo;
   wartoscplnln=wartoscplnln+wartoscplnlo;
   wartoscwallo=0;
   wartoscplnlo=0;
  END IF;
  IF (NEW.rr_idrozrachunkur=OLD.rr_idrozrachunkur) THEN
   wartoscwalrn=wartoscwalrn+wartoscwalro;
   wartoscplnrn=wartoscplnrn+wartoscplnro;
   wartoscwalro=0;
   wartoscplnro=0;
  END IF;
  IF (NEW.km_idkompensaty=OLD.km_idkompensaty) THEN
   saldokmwnn=saldokmwnn+saldokmwno;
   saldokmman=saldokmman+saldokmmao;
   saldokmwno=0;
   saldokmmao=0;
  END IF;
 END IF;
 IF (wartoscwallo<>0) OR (wartoscplnlo<>0) THEN
  UPDATE kr_rozrachunki SET rr_wartoscpozwal=rr_wartoscpozwal-wartoscwallo,rr_wartoscpozpln=rr_wartoscpozpln-wartoscplnlo WHERE rr_idrozrachunku=OLD.rr_idrozrachunkul;
 END IF;
 IF (wartoscwalro<>0) OR (wartoscplnro<>0) THEN
  UPDATE kr_rozrachunki SET rr_wartoscpozwal=rr_wartoscpozwal-wartoscwalro,rr_wartoscpozpln=rr_wartoscpozpln-wartoscplnro WHERE rr_idrozrachunku=OLD.rr_idrozrachunkur;
 END IF;
 IF (wartoscwalln<>0) OR (wartoscplnln<>0) THEN
  UPDATE kr_rozrachunki SET rr_wartoscpozwal=rr_wartoscpozwal-wartoscwalln,rr_wartoscpozpln=rr_wartoscpozpln-wartoscplnln WHERE rr_idrozrachunku=NEW.rr_idrozrachunkul;
 END IF;
 IF (wartoscwalrn<>0) OR (wartoscplnrn<>0) THEN
  UPDATE kr_rozrachunki SET rr_wartoscpozwal=rr_wartoscpozwal-wartoscwalrn,rr_wartoscpozpln=rr_wartoscpozpln-wartoscplnrn WHERE rr_idrozrachunku=NEW.rr_idrozrachunkur;
 END IF;
 IF (saldokmwno<>0 OR saldokmmao<>0) THEN
  UPDATE kr_kompensaty SET km_saldown=km_saldown+saldokmwno,km_saldoma=km_saldoma+saldokmmao WHERE km_idkompensaty=OLD.km_idkompensaty;
 END IF;
 IF (saldokmwnn<>0 OR saldokmman<>0) THEN
  UPDATE kr_kompensaty SET km_saldown=km_saldown+saldokmwnn,km_saldoma=km_saldoma+saldokmman WHERE km_idkompensaty=NEW.km_idkompensaty;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Update zaleznych
 -------------------------------------------------------------------------------------------------------------

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Utworzenie rekordu roznic kursowych
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  IF (NEW.rl_roznicekursowel<>0) THEN
   PERFORM dodajRozniceKursowe(NEW.rl_idrozliczenia,NEW.rr_idrozrachunkul,NEW.rl_roznicekursowel);
  ELSE
   PERFORM dodajRozniceKursowe(NEW.rl_idrozliczenia,NEW.rr_idrozrachunkur,NEW.rl_roznicekursower);
  END IF;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Utworzenie rekordu roznic kursowych
 -------------------------------------------------------------------------------------------------------------

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Kasowanie rekordu rozrachunkow roznic kursowych
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP='DELETE') THEN
  IF (OLD.km_idkompensaty IS NOT NULL) THEN
   IF (OLD.rl_flaga&64=0) THEN
    RAISE EXCEPTION '23|%:%|Nie mozna usunac rozliczenia z kompensaty',OLD.rl_idrozliczenia,OLD.km_idkompensaty;
   END IF;
   RAISE NOTICE ':INVO: 225,%',OLD.km_idkompensaty;
  END IF;
  IF (OLD.rl_idrozliczenia_rk IS NOT NULL) THEN
   DELETE FROM kr_rozrachunki WHERE rr_idrozrachunku=OLD.rr_idrozrachunkul AND rr_flaga&64=64;
  END IF;
  DELETE FROM kr_rozrachunki WHERE (rr_idrozrachunku=OLD.rr_idrozrachunkul OR rr_idrozrachunku=OLD.rr_idrozrachunkur) AND rr_flaga&7=4;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Kasowanie rekordu rozrachunkow roznic kursowych
 -------------------------------------------------------------------------------------------------------------

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Rozliczenie faktury zaliczkowej
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  IF (NEW.rl_flaga&1=1) THEN
   PERFORM rozliczVatZalU(COALESCE(NEW.rl_idrozliczenia_netto,NEW.rl_idrozliczenia),NEW.rr_idrozrachunkul,COALESCE(NEW.rl_sumanettovat,NEW.rl_wartoscwall),TRUE,((NEW.rl_flaga&128)<>0));
  END IF;
  IF (NEW.rl_flaga&2=2) THEN
   PERFORM rozliczVatZalU(COALESCE(NEW.rl_idrozliczenia_netto,NEW.rl_idrozliczenia),NEW.rr_idrozrachunkur,COALESCE(NEW.rl_sumanettovat,NEW.rl_wartoscwalr),FALSE,((NEW.rl_flaga&128)<>0));
  END IF;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Rozliczenie faktury zaliczkowej
 -------------------------------------------------------------------------------------------------------------

 -------------------------------------------------------------------------------------------------------------
 --- STARTOF: Zmiana daty zaplacenia
 -------------------------------------------------------------------------------------------------------------
 IF (TG_OP<>'DELETE') THEN
  UPDATE kr_rozrachunki SET rr_datazaplacenia=(CASE WHEN rr_wartoscpozwal<>0 THEN NULL ELSE (SELECT max(rl_datamax) FROM krv_rozliczenia WHERE rr_idrozrachunkusrc=kr_rozrachunki.rr_idrozrachunku) END)
                        WHERE (rr_idrozrachunku=NEW.rr_idrozrachunkul OR rr_idrozrachunku=NEW.rr_idrozrachunkur) AND
		              COALESCE(rr_datazaplacenia,'1970-01-01')<>COALESCE((CASE WHEN rr_wartoscpozwal<>0 THEN NULL ELSE (SELECT max(rl_datamax) FROM krv_rozliczenia WHERE rr_idrozrachunkusrc=kr_rozrachunki.rr_idrozrachunku) END),'1970-01-01');
 ELSE
  UPDATE kr_rozrachunki SET rr_datazaplacenia=(CASE WHEN rr_wartoscpozwal<>0 THEN NULL ELSE (SELECT max(rl_datamax) FROM krv_rozliczenia WHERE rr_idrozrachunkusrc=kr_rozrachunki.rr_idrozrachunku) END)
                        WHERE (rr_idrozrachunku=OLD.rr_idrozrachunkul OR rr_idrozrachunku=OLD.rr_idrozrachunkur) AND
		              COALESCE(rr_datazaplacenia,'1970-01-01')<>COALESCE((CASE WHEN rr_wartoscpozwal<>0 THEN NULL ELSE (SELECT max(rl_datamax) FROM krv_rozliczenia WHERE rr_idrozrachunkusrc=kr_rozrachunki.rr_idrozrachunku) END),'1970-01-01');
  IF (OLD.rl_idrozliczenia_netto IS NOT NULL) THEN
   DELETE FROM kr_rozliczenia WHERE rl_idrozliczenia=OLD.rl_idrozliczenia_netto; 
  END IF;
 END IF;
 -------------------------------------------------------------------------------------------------------------
 --- ENDOF: Zmiana daty zaplacenia
 -------------------------------------------------------------------------------------------------------------

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END
$$;
