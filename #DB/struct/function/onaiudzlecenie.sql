CREATE FUNCTION onaiudzlecenie() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ 
DECLARE
 r RECORD;
 cnt INT;
BEGIN

 IF (TG_OP='INSERT') THEN
  INSERT INTO tb_pracownicyzlecenia(p_idpracownika, zl_idzlecenia, pzl_flaga) VALUES (NEW.p_odpowiedzialny, NEW.zl_idzlecenia, 1|(1<<8));
  IF (NEW.dz_iddzialu IS NOT NULL) THEN 
   INSERT INTO tb_pracownicyzlecenia(dz_iddzialu, zl_idzlecenia, pzl_flaga) VALUES (NEW.dz_iddzialu, NEW.zl_idzlecenia, 1|(1<<8));
  END IF;
 END IF;
 
 IF (TG_OP='UPDATE') THEN
  --Jesli zmienil sie pracownik - uaktualniamy liste pracownikow powiazanych
  IF (NEW.p_odpowiedzialny!=OLD.p_odpowiedzialny) THEN

   SELECT pzl_id,pzl_flaga INTO r FROM tb_pracownicyzlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia AND p_idpracownika=NEW.p_odpowiedzialny;
   IF (r.pzl_id IS NULL) THEN
    ---Skasuj stare rekordy automatyczne
    DELETE FROM tb_pracownicyzlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia AND pzl_flaga&(1<<8)<>0 AND p_idpracownika IS NOT NULL;
    ---Odflaguj stare rekordy nieautomatyczne
    UPDATE tb_pracownicyzlecenia SET pzl_flaga=pzl_flaga&(~1) WHERE zl_idzlecenia=NEW.zl_idzlecenia AND pzl_flaga&1=1 AND p_idpracownika IS NOT NULL;
    --Nie znaleziono - dodaj nowy rekord
    INSERT INTO tb_pracownicyzlecenia(p_idpracownika, zl_idzlecenia, pzl_flaga) VALUES (NEW.p_odpowiedzialny, NEW.zl_idzlecenia, 1|(1<<8));
   ELSE
    ---Skasuj stare rekordy automatyczne
    DELETE FROM tb_pracownicyzlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia AND pzl_flaga&(1<<8)<>0 AND pzl_id<>r.pzl_id AND p_idpracownika IS NOT NULL;
    ---Odflaguj stare rekordy nieautomatyczne
    UPDATE tb_pracownicyzlecenia SET pzl_flaga=pzl_flaga&(~1) WHERE zl_idzlecenia=NEW.zl_idzlecenia AND pzl_flaga&1=1 AND pzl_id<>r.pzl_id AND p_idpracownika IS NOT NULL;
    ---Oflaguj istniejacy rekord
    UPDATE tb_pracownicyzlecenia SET pzl_flaga=pzl_flaga|1 WHERE pzl_id=r.pzl_id AND pzl_flaga&1=0;
   END IF;

   SELECT count(*) INTO cnt FROM tb_pracownicyzlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia AND p_idpracownika=NEW.p_odpowiedzialny AND (pzl_flaga&1)=0;
   IF (cnt > 0) THEN
    UPDATE tb_pracownicyzlecenia SET pzl_flaga=(pzl_flaga|1) WHERE zl_idzlecenia=NEW.zl_idzlecenia AND p_idpracownika=NEW.p_odpowiedzialny;
   ELSE
    IF((SELECT count(*) FROM tb_pracownicyzlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia AND p_idpracownika=NEW.p_odpowiedzialny AND (pzl_flaga&1)=1) > 0) THEN
     UPDATE tb_pracownicyzlecenia SET p_idpracownika=NEW.p_odpowiedzialny WHERE zl_idzlecenia=NEW.zl_idzlecenia AND (pzl_flaga&1)=1 AND p_idpracownika!=NEW.p_odpowiedzialny AND p_idpracownika IS NOT NULL;
    ELSE
     INSERT INTO tb_pracownicyzlecenia(p_idpracownika, zl_idzlecenia, pzl_flaga) VALUES (NEW.p_odpowiedzialny, NEW.zl_idzlecenia, 1|(1<<8));
    END IF;
   END IF;
  END IF;

  -------------------------------------------------------------------------------------------------------------------------

  IF (COALESCE(NEW.dz_iddzialu,0)!=COALESCE(OLD.dz_iddzialu,0)) THEN
   SELECT pzl_id,pzl_flaga INTO r FROM tb_pracownicyzlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia AND dz_iddzialu=NEW.dz_iddzialu;
   IF (r.pzl_id IS NULL) THEN
    ---Skasuj stare rekordy automatyczne
    DELETE FROM tb_pracownicyzlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia AND pzl_flaga&(1<<8)<>0 AND dz_iddzialu IS NOT NULL;
    ---Odflaguj stare rekordy nieautomatyczne
    UPDATE tb_pracownicyzlecenia SET pzl_flaga=pzl_flaga&(~1) WHERE zl_idzlecenia=NEW.zl_idzlecenia AND pzl_flaga&1=1 AND dz_iddzialu IS NOT NULL;
    --Nie znaleziono - dodaj nowy rekord
    IF (NEW.dz_iddzialu IS NOT NULL) THEN 
     INSERT INTO tb_pracownicyzlecenia(dz_iddzialu, zl_idzlecenia, pzl_flaga) VALUES (NEW.dz_iddzialu, NEW.zl_idzlecenia, 1|(1<<8));
    END IF;
   ELSE
    ---Skasuj stare rekordy automatyczne
    DELETE FROM tb_pracownicyzlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia AND pzl_flaga&(1<<8)<>0 AND pzl_id<>r.pzl_id AND dz_iddzialu IS NOT NULL;
    ---Odflaguj stare rekordy nieautomatyczne
    UPDATE tb_pracownicyzlecenia SET pzl_flaga=pzl_flaga&(~1) WHERE zl_idzlecenia=NEW.zl_idzlecenia AND pzl_flaga&1=1 AND pzl_id<>r.pzl_id AND dz_iddzialu IS NOT NULL;
    ---Oflaguj istniejacy rekord
    UPDATE tb_pracownicyzlecenia SET pzl_flaga=pzl_flaga|1 WHERE pzl_id=r.pzl_id AND pzl_flaga&1=0;
   END IF;

   SELECT count(*) INTO cnt FROM tb_pracownicyzlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia AND dz_iddzialu=NEW.dz_iddzialu AND (pzl_flaga&1)=0;
   IF (cnt > 0) THEN
    UPDATE tb_pracownicyzlecenia SET pzl_flaga=(pzl_flaga|1) WHERE zl_idzlecenia=NEW.zl_idzlecenia AND dz_iddzialu=NEW.dz_iddzialu;
   ELSE
    IF((SELECT count(*) FROM tb_pracownicyzlecenia WHERE zl_idzlecenia=NEW.zl_idzlecenia AND dz_iddzialu=NEW.dz_iddzialu AND (pzl_flaga&1)=1) > 0) THEN
     UPDATE tb_pracownicyzlecenia SET dz_iddzialu=NEW.dz_iddzialu WHERE zl_idzlecenia=NEW.zl_idzlecenia AND (pzl_flaga&1)=1 AND dz_iddzialu!=NEW.dz_iddzialu AND dz_iddzialu IS NOT NULL;
    ELSE
     INSERT INTO tb_pracownicyzlecenia(dz_iddzialu, zl_idzlecenia, pzl_flaga) VALUES (NEW.dz_iddzialu, NEW.zl_idzlecenia, 1|(1<<8));
    END IF;
   END IF;
  END IF;

 END IF;


 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
