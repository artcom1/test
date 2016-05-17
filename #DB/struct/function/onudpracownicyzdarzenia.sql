CREATE FUNCTION onudpracownicyzdarzenia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 IF (TG_OP='UPDATE') THEN
  IF ((NEW.pzd_flaga&1)=1) THEN
	DELETE FROM tb_pracownicyzdarzenia WHERE pzd_idpracownika<>NEW.pzd_idpracownika AND p_idpracownika=NEW.p_idpracownika AND zd_idzdarzenia=NEW.zd_idzdarzenia;
		
   IF ((OLD.pzd_flaga&1)=0) THEN
    UPDATE tb_pracownicyzdarzenia SET pzd_flaga=pzd_flaga-1 WHERE (pzd_flaga&1)=1 AND pzd_idpracownika!=NEW.pzd_idpracownika AND zd_idzdarzenia=NEW.zd_idzdarzenia;
   END IF;
   ---NEW.pzd_flaga=NEW.pzd_flaga&(~(7<<2));
   ---NEW.pzd_flaga=NEW.pzd_flaga|(((pzd_flaga>>5)&7)<<2);
   IF ((NEW.pzd_flaga&(7<<2))<>(OLD.pzd_flaga&(7<<2))) THEN
    RAISE NOTICE ':INVO: 210,%',NEW.pzd_idpracownika; 
   END IF;
   ---Wpada w rekurencje jesli ponizsza linia jest
   ---UPDATE tb_zdarzenia SET p_idpracownika=NEW.p_idpracownika WHERE zd_idzdarzenia=NEW.zd_idzdarzenia;
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  DELETE FROM tb_pp WHERE ppm_type = 210 AND ppm_refid = OLD.pzd_idpracownika;
 END IF;
	
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE	
  RETURN NEW;
 END IF;
END;
$$;
