CREATE FUNCTION onudpracownicyzlecenia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='UPDATE') THEN
  IF ((NEW.pzl_flaga&1)=1) THEN
   IF ((OLD.pzl_flaga&1)=0) THEN
    UPDATE tb_pracownicyzlecenia SET pzl_flaga=pzl_flaga-1 WHERE (pzl_flaga&1)=1 AND pzl_id!=NEW.pzl_id AND zl_idzlecenia=NEW.zl_idzlecenia;
   END IF;
   ---Wpada w rekurencje jesli ponizsza linia jest
   ---UPDATE tb_zdarzenia SET p_idpracownika=NEW.p_idpracownika WHERE zd_idzdarzenia=NEW.zd_idzdarzenia;
  END IF;
 END IF;
	
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE	
  RETURN NEW;
 END IF;
END;
$$;
