CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 cnt integer;
 r RECORD;
 zlecenia_data_old BOOL:=FALSE;
 zlecenia_data_new BOOL:=FALSE;
 old_rbh  NUMERIC:=0;
 new_rbh  NUMERIC:=0;
BEGIN

 IF ((TG_OP!='DELETE') AND (shouldEscapeZdarzeniaTriggers()=TRUE)) THEN
  RETURN NEW;
 END IF;
 
 IF (TG_OP='INSERT') THEN
  IF (NullZero(NEW.zl_idzlecenia)>0) THEN
   --mamy zlecenie wiec trzeba uaktualnic date na tym zleceniu
   zlecenia_data_new=TRUE;
  END IF;

  -- Wstawiamy do list pracownikow i klientow powiazanych osoby domyslne
  IF (NEW.k_idklienta > 0) THEN
   INSERT INTO tb_kliencizdarzenia(k_idklienta, zd_idzdarzenia, lk_idczklienta, kzd_flaga) VALUES(NEW.k_idklienta, NEW.zd_idzdarzenia, NEW.lk_idczklienta, 1);
  END IF;

  IF ((NEW.zd_flaga&(1<<19))=0) THEN
   INSERT INTO tb_pracownicyzdarzenia(p_idpracownika, zd_idzdarzenia, pzd_flaga) VALUES (NEW.p_idpracownika, NEW.zd_idzdarzenia, 1|(1<<8)|(((NEW.zd_flaga&12)>>2)<<5 ) );
  END IF;
 END IF;

 IF (TG_OP='UPDATE')THEN
  --Jesli zmienil sie klient - uaktualniamy liste klientow powiazanych
  IF (NEW.k_idklienta!=OLD.k_idklienta) THEN
   IF (NEW.k_idklienta = 0) THEN
    DELETE FROM tb_kliencizdarzenia WHERE (kzd_flaga&1)=1 AND zd_idzdarzenia=NEW.zd_idzdarzenia;
   ELSE 
    IF (NEW.k_idklienta > 0) THEN
     IF((SELECT count(*) FROM tb_kliencizdarzenia WHERE zd_idzdarzenia=NEW.zd_idzdarzenia) > 0) THEN
      IF ((SELECT count(*) FROM tb_kliencizdarzenia WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND k_idklienta=NEW.k_idklienta AND lk_idczklienta=NEW.lk_idczklienta AND (kzd_flaga&1)=0) > 0) THEN
       UPDATE tb_kliencizdarzenia SET kzd_flaga=(kzd_flaga|1) WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND k_idklienta=NEW.k_idklienta AND lk_idczklienta=NEW.lk_idczklienta;
      ELSE
       UPDATE tb_kliencizdarzenia SET k_idklienta=NEW.k_idklienta, lk_idczklienta=NEW.lk_idczklienta WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND (kzd_flaga&1)=1;
      END IF;
     ELSE
      INSERT INTO tb_kliencizdarzenia(k_idklienta, zd_idzdarzenia, lk_idczklienta, kzd_flaga) VALUES(NEW.k_idklienta, NEW.zd_idzdarzenia, NEW.lk_idczklienta, 1);
     END IF;
    END IF;
   END IF;
  ELSE
   --Jesli zmienil sie czlowiek klienta - uaktualniamy liste klientow
   IF (NEW.lk_idczklienta!=OLD.lk_idczklienta) THEN
    SELECT count(*) INTO cnt FROM tb_kliencizdarzenia WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND k_idklienta=NEW.k_idklienta AND lk_idczklienta=NEW.lk_idczklienta AND (kzd_flaga&1)=0;
    IF (cnt > 0) THEN
     UPDATE tb_kliencizdarzenia SET kzd_flaga=(kzd_flaga|1) WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND k_idklienta=NEW.k_idklienta AND lk_idczklienta=NEW.lk_idczklienta;
    ELSE
     UPDATE tb_kliencizdarzenia SET k_idklienta=NEW.k_idklienta, lk_idczklienta=NEW.lk_idczklienta WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND (kzd_flaga&1)=1 AND (k_idklienta!=NEW.k_idklienta OR lk_idczklienta!=NEW.lk_idczklienta);
    END IF;
   END IF;
  END IF;

  --Jesli zmienil sie pracownik - uaktualniamy liste pracownikow powiazanych
  IF (NEW.p_idpracownika!=OLD.p_idpracownika) THEN
   IF(NEW.p_idpracownika <= 0) THEN
    DELETE FROM tb_pracownicyzdarzenia WHERE zd_idzdarzenia = NEW.zd_idzdarzenia;
   ELSE
    SELECT pzd_idpracownika,pzd_flaga INTO r FROM tb_pracownicyzdarzenia WHERE pzd_flaga&2=0 AND zd_idzdarzenia=NEW.zd_idzdarzenia AND p_idpracownika=NEW.p_idpracownika;
    IF (r.pzd_idpracownika IS NULL) THEN
     --Skasuj stare rekordy automatyczne
     DELETE FROM tb_pracownicyzdarzenia WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND pzd_flaga&(1<<8)<>0;
     --Odflaguj stare rekordy nieautomatyczne
     UPDATE tb_pracownicyzdarzenia SET pzd_flaga=pzd_flaga&(~1) WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND pzd_flaga&1=1;
     --Nie znaleziono - dodaj nowy rekord
     IF ((NEW.zd_flaga&(1<<19))=0) THEN
      INSERT INTO tb_pracownicyzdarzenia(p_idpracownika, zd_idzdarzenia, pzd_flaga) VALUES (NEW.p_idpracownika, NEW.zd_idzdarzenia, 1|(1<<8));
     END IF;
    ELSE
     --Skasuj stare rekordy automatyczne
     DELETE FROM tb_pracownicyzdarzenia WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND pzd_flaga&(1<<8)<>0 AND pzd_idpracownika<>r.pzd_idpracownika;
     --Odflaguj stare rekordy nieautomatyczne
     UPDATE tb_pracownicyzdarzenia SET pzd_flaga=pzd_flaga&(~1) WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND pzd_flaga&1=1 AND pzd_idpracownika<>r.pzd_idpracownika;
     --Oflaguj istniejacy rekord
     UPDATE tb_pracownicyzdarzenia SET pzd_flaga=pzd_flaga|1 WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND pzd_flaga&1=0;
    END IF;

    SELECT count(*) INTO cnt FROM tb_pracownicyzdarzenia WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND p_idpracownika=NEW.p_idpracownika AND (pzd_flaga&1)=0;
    IF (cnt > 0) THEN
     UPDATE tb_pracownicyzdarzenia SET pzd_flaga=(pzd_flaga|1) WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND p_idpracownika=NEW.p_idpracownika;
    ELSE
     IF((SELECT count(*) FROM tb_pracownicyzdarzenia WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND (pzd_flaga&1)=1) > 0) THEN
      UPDATE tb_pracownicyzdarzenia SET p_idpracownika=NEW.p_idpracownika WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND (pzd_flaga&1)=1 AND p_idpracownika!=NEW.p_idpracownika;
     ELSE
      IF ((NEW.zd_flaga&(1<<19))=0) THEN
       INSERT INTO tb_pracownicyzdarzenia(p_idpracownika, zd_idzdarzenia, pzd_flaga) VALUES (NEW.p_idpracownika, NEW.zd_idzdarzenia, 1|(1<<8));
      END IF;
     END IF;
    END IF;
   END IF;
  END IF;
  IF ((NEW.zd_flaga&12)<>(OLD.zd_flaga&12)) THEN
   UPDATE tb_pracownicyzdarzenia SET pzd_flaga=(pzd_flaga&(~(7<<5)))|(((NEW.zd_flaga>>2)&3)<<5) WHERE zd_idzdarzenia=NEW.zd_idzdarzenia;
      
   IF ((NEW.zd_flaga&12)<>0 AND NEW.zd_rodzaj=13) THEN
UPDATE tb_mail_data SET mail_flag=mail_flag|(1<<3) WHERE mail_id=NEW.zd_mail_id;
   END IF;
   
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NullZero(NEW.zl_idzlecenia)!=NullZero(OLD.zl_idzlecenia)) THEN
   --zmieniemy na pracach podpiecie pod zlecenie (zmienilo sie podpiecie pod zlecenie zdarzenia)      
   IF (NEW.zl_idzlecenia=NULL OR NEW.zl_idzlecenia<=0) THEN
    UPDATE tg_praceall SET zl_idzlecenia=NULL WHERE pra_typeref=206 AND pra_idref=NEW.zd_idzdarzenia;
   ELSE
    UPDATE tg_praceall SET zl_idzlecenia=NEW.zl_idzlecenia WHERE pra_typeref=206 AND pra_idref=NEW.zd_idzdarzenia;
   END IF;
   --zmienilo sie zlecenie - trzeba uaktualnic daty na zleceniach
   zlecenia_data_old=TRUE;
   zlecenia_data_new=TRUE;
  END IF;

  IF (NullZero(NEW.zl_idzlecenia)>0) THEN
   --mamy zlecenie wiec sprawdzamy czy daty darzenia nie ulegly zmianie, jesli tak to uaktualniamy daty na zleceniu
   IF (OLD.zd_datarozpoczecia!=NEW.zd_datarozpoczecia OR OLD.zd_datazakonczenia!=NEW.zd_datazakonczenia) THEN
    zlecenia_data_new=TRUE;
   END IF;
  END IF;

 END IF;
    
 IF (TG_OP='DELETE') THEN
  IF (NullZero(OLD.zl_idzlecenia)>0) THEN
   --mamy zlecenie wiec trzeba uaktualnic date na tym zleceniu
   zlecenia_data_old=TRUE;
  END IF;

  ----usuwamy rekordy powiazane ze zdarzeniem (prace, rezerwacja zasobow, przypominacze
  DELETE FROM tg_praceall WHERE pra_typeref = 206 AND pra_idref = OLD.zd_idzdarzenia;
  DELETE FROM tr_harmonogram WHERE hm_reftype = 206 AND  hm_refid = OLD.zd_idzdarzenia;
  DELETE FROM tb_pp WHERE ppm_type = 206 AND ppm_refid = OLD.zd_idzdarzenia;

  IF (((OLD.zd_flaga&1536)>>9)=2) THEN
   UPDATE tb_cyklwyjatki SET cw_newidzdarzenia=NULL WHERE cw_newidzdarzenia=OLD.zd_idzdarzenia;
  END IF;
 END IF;

 -------------------------------------
 ----UAKTU
 --------

 IF (zlecenia_data_old) THEN
  PERFORM PrzeliczDatyOkresZlecenia(OLD.zl_idzlecenia,OLD.zd_idzdarzenia, NULL);
 END IF;

 IF (zlecenia_data_new) THEN
  PERFORM PrzeliczDatyOkresZlecenia(NEW.zl_idzlecenia,NULL, NULL);
 END IF;
 ---------------------------
 ----KONIEC UAKTUALNIANIA DATY NA ZLECENIACH JESLI TAKA POTRZEBA
 ---------------------------------------------------------------------

 -----------------------------------------------------------------------------------
 --- AKUMULATOR RBH ZDARZEN
 ----------------------------------------------------------------------------------- 
 -- DELETE lub UPDATE
 IF (TG_OP<>'INSERT') THEN
  old_rbh=-OLD.zd_rbh;
  old_rbh=old_rbh-OLD.zd_rbhdzieci;
 END IF;
 
 -- INSERT lub UPDATE 
 IF (TG_OP<>'DELETE') THEN
  new_rbh=NEW.zd_rbh;
  new_rbh=new_rbh+NEW.zd_rbhdzieci;
 END IF;
 
  IF (TG_OP='UPDATE') THEN -- Czy nie zmienil sie rodzic
   IF (COALESCE(NEW.zd_idparent,0)=COALESCE(OLD.zd_idparent,0)) THEN
    new_rbh=new_rbh+old_rbh;
old_rbh=0;
   END IF;
  END IF;
  
  IF (old_rbh<>0) THEN
   UPDATE tb_zdarzenia SET zd_rbhdzieci=zd_rbhdzieci+old_rbh WHERE zd_idzdarzenia=OLD.zd_idparent;
   old_rbh=0;
  END IF;
  
  IF (new_rbh<>0) THEN
   UPDATE tb_zdarzenia SET zd_rbhdzieci=zd_rbhdzieci+new_rbh WHERE zd_idzdarzenia=NEW.zd_idparent;
   new_rbh=0;
  END IF;
 
 -----------------------------------------------------------------------------------
 --- KONIEC AKUMULATORA RBH ZDARZEN
 ----------------------------------------------------------------------------------- 
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
