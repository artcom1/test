CREATE FUNCTION onauelzapisu() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 ile INT;
 idzk INT;
BEGIN

 IF (TG_OP='UPDATE') THEN

  IF (NEW.zp_flaga&8=8) THEN
   IF (NEW.tr_idtrans IS NOT NULL OR NEW.pl_idplatnosc IS NOT NULL) THEN
    RAISE EXCEPTION '18|%|Nie mozna BO gdyz jest skojarzenie z platnoscia lub dokumentem',NEW.zp_idelzapisu;
   END IF;
  END IF;

  IF (OLD.zp_flaga&2=2 AND NEW.zp_flaga&2=0) THEN           --- Usun z rozrachunkow
   PERFORM clearRozrachunkiKH(NEW.zp_idelzapisu,TRUE);
  END IF;
  IF (OLD.zp_flaga&4=4 AND NEW.zp_flaga&4=0) THEN           --- Usun z rozrachunkow
   PERFORM clearRozrachunkiKH(NEW.zp_idelzapisu,FALSE);
  END IF;

  IF ((OLD.zp_flaga&(3<<15))<>(NEW.zp_flaga&(3<<15))) THEN
   IF ((NEW.zp_flaga&(3<<15))<>0) THEN
    ile=1;
   ELSE
    ile=(SELECT count(*) FROM kh_zapisyelem WHERE zk_idzapisu=NEW.zk_idzapisu AND (zp_flaga&(3<<15))<>0 AND zp_idelzapisu<>NEW.zp_idelzapisu);
   END IF;
  END IF;

 END IF;

 IF (TG_OP<>'DELETE') THEN
  idzk=NEW.zk_idzapisu;

  IF (NEW.zp_flaga&6<>0) THEN    --Tylko jesli ktoras ze stron jest rozrachunkowa
   IF (NEW.zp_flaga&2=2) THEN    --- Strona Wn rozrachunkowa
    IF (NEW.zp_flaga&(8|64|1024)=(8|64)) THEN                  --- Strona Wn jest kontem rozrachunkow wspolnych i BO (BO/z kontrahentem/wchodzi do RR mimo BO)
     PERFORM clearRozrachunkiKH(NEW.zp_idelzapisu,TRUE);
    ELSE
     PERFORM updateRozrachunkiKH(NEW.zp_idelzapisu,NEW.kt_idkontawn,(SELECT k_idklienta FROM kh_konta WHERE kt_idkonta=NEW.kt_idkontawn AND NEW.zp_flaga&64=64),NEW.zp_kwotawal,TRUE,NEW.zp_datadok,NEW.zp_dataplatnosci,NEW.wl_idwaluty,NEW.wl_przelicznik,NEW.zp_kwota);
    END IF;
   END IF;
   IF (NEW.zp_flaga&4=4) THEN
    IF (NEW.zp_flaga&(8|128|1024)=(8|128)) THEN                --- Strona Ma jest kontem rozrachunkow wspolnych i BO
     PERFORM clearRozrachunkiKH(NEW.zp_idelzapisu,FALSE);
    ELSE
     PERFORM updateRozrachunkiKH(NEW.zp_idelzapisu,NEW.kt_idkontama,(SELECT k_idklienta FROM kh_konta WHERE kt_idkonta=NEW.kt_idkontama AND NEW.zp_flaga&128=128),NEW.zp_kwotawal,FALSE,NEW.zp_datadok,NEW.zp_dataplatnosci,NEW.wl_idwaluty,NEW.wl_przelicznik,NEW.zp_kwota);
    END IF;
   END IF;
  END IF;

 END IF;

 IF (TG_OP='INSERT') THEN
  IF ((NEW.zp_flaga&(3<<15))<>0) THEN
   ile=1;
  END IF;
 END IF;

 IF (TG_OP = 'DELETE') THEN
  idzk=OLD.zk_idzapisu;

  UPDATE kh_zapisyelem SET zp_numer=zp_numer-1 WHERE zp_numer>OLD.zp_numer AND zk_idzapisu=OLD.zk_idzapisu;

  IF ((OLD.zp_flaga&(3<<15))<>0) THEN
   ile=(SELECT count(*) FROM kh_zapisyelem WHERE zk_idzapisu=OLD.zk_idzapisu AND (zp_flaga&(3<<15))<>0 AND zp_idelzapisu<>OLD.zp_idelzapisu);
  END IF;

 END IF;

 RAISE NOTICE 'Ile % %',ile,idzk;

 IF (ile IS NOT NULL) THEN
  UPDATE kh_zapisyhead SET zk_flaga=zk_flaga&(~(1<<5))|((CASE WHEN ile=0 THEN 0 ELSE 1<<5 END)) 
  WHERE zk_idzapisu=idzk AND
        zk_flaga&(1<<5)<>((CASE WHEN ile=0 THEN 0 ELSE 1<<5 END));
 END IF;

 IF (TG_OP <> 'DELETE') THEN
  RETURN NEW;
 ELSE
  RETURN OLD;
 END IF;

END;
$$;
