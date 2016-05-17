CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 idz boolean;
 sfx TEXT:='';
 _pzidref INT;
BEGIN 
 idz = FALSE;

 IF ((TG_OP!='DELETE') AND (shouldEscapeZdarzeniaTriggers()=TRUE)) THEN
  RETURN NEW;
 END IF;
     
 IF (TG_OP='INSERT') THEN 
  idz=TRUE; 
 END IF;

 IF (TG_OP='UPDATE') THEN
  IF (NEW.zd_rodzaj!=OLD.zd_rodzaj) THEN 
   idz=TRUE; 
  END IF; 
 END IF;

 IF (idz=TRUE) THEN
  --Numeracja korespondencji
  IF (NEW.zd_rodzaj = 2) THEN
   
   IF (NEW.zd_prefix IS NULL) THEN
    
    IF (isMail(NEW.zd_flaga)=TRUE) THEN
     NEW.zd_prefix='M';
    END IF;
    
    IF (isFax(NEW.zd_flaga)=TRUE) THEN
     NEW.zd_prefix='F';
    END IF;

    IF (isList(NEW.zd_flaga)=TRUE) THEN
     NEW.zd_prefix='L';
    END IF;

    IF (isListPolecony(NEW.zd_flaga)=TRUE) THEN
     NEW.zd_prefix='LP';
    END IF;

    IF (COALESCE((SELECT cf_defvalue FROM tc_config WHERE cf_tabela='SEKROsobnaNumeracja'),'0')='1') THEN
     IF (((NEW.zd_flaga>>4)&1)=0) THEN 
      sfx='/OUT';
     ELSE
      sfx='/IN';
     END IF;
    END IF;

    NEW.zd_prefix=NEW.zd_prefix||'/'||date_part('year',NEW.zd_datazakonczenia)||sfx;

   END IF;

   IF (NEW.zd_numer IS NULL) THEN
    NEW.zd_numer=(SELECT NullZero(max(zd_numer))+1 AS numer FROM tb_zdarzenia WHERE zd_prefix=NEW.zd_prefix AND zd_rodzaj = 2);
   END IF;

  END IF;
 
 END IF;

 --kwestie polaczenia zdarzenia z planem zdarzenia - synchronizacja pol
 IF (TG_OP = 'UPDATE') THEN
  IF (NEW.zd_rodzaj= 10 OR NEw.zd_rodzaj = 11 OR NEw.zd_rodzaj = 12) THEN --tylko dla zdarzen produkcyjnych lub turystycznych lub serwisowych
   IF (NullZero(NEW.zd_idparent)!=NullZero(OLD.zd_idparent)) THEN
    ---zmienil sie struktura drzewa planu
	_pzidref=(SELECT pz_idplanu FROM tb_zdarzenia WHERE zd_idzdarzenia=NEW.zd_idparent);
	
	IF (_pzidref IS NOT NULL) THEN -- Ma rodzica 
	 UPDATE tg_planzlecenia SET pz_idref=_pzidref, pz_idroot=(SELECT COALESCE(pz_idroot,pz_idplanu) FROM tg_planzlecenia WHERE pz_idplanu=_pzidref) WHERE pz_idplanu=NEW.pz_idplanu;
	ELSE
	 UPDATE tg_planzlecenia SET pz_idref=NULL, pz_idroot=NULL WHERE pz_idplanu=NEW.pz_idplanu;	 
	END IF;
	
	PERFORM updatepzidroot(NEW.pz_idplanu);
	
    --UPDATE tg_planzlecenia SET pz_idref=(SELECT pz_idplanu FROM tb_zdarzenia WHERE zd_idzdarzenia=NEW.zd_idparent) WHERE pz_idplanu=NEW.pz_idplanu;
   END IF;
  END IF;
 END IF;
 --koniec czesc dla polaczenia zdarzenia z planem zdarzenia

	-- Zmiana priorytet??w	
	IF (TG_OP='UPDATE') THEN 
		IF ((NEW.zd_flaga&12)<>(OLD.zd_flaga&12)) THEN   
			IF ((NEW.zd_flaga&12)<>0) THEN
				IF (NEW.zd_priority IS NOT NULL) THEN
					DELETE FROM tb_zdarzenia_priority WHERE zpr_zd_idzdarzenia=NEW.zd_idzdarzenia;	
					INSERT INTO tb_zdarzenia_priority(zpr_zd_idzdarzenia, zpr_oldpriority) VALUES(NEW.zd_idzdarzenia, NEW.zd_priority);
					NEW.zd_priority = NULL;
				END IF;
			ELSE
				NEW.zd_priority = (SELECT public.zdarzenia_priority_pop(NEW.zd_idzdarzenia, true));
			END IF;   
		END IF;
	END IF; 
	
	-- Ustawienie dzia??u
	IF (TG_OP='UPDATE') THEN 
		IF ((NEW.zd_flaga>>19)&1)=0 THEN
			IF (NEW.p_idpracownika IS NULL) OR (NEW.p_idpracownika = 0) THEN
				NEW.dz_iddzialu =0;
			ELSE
				NEW.dz_iddzialu = (SELECT p.dz_iddzialu FROM tb_pracownicy AS p WHERE p.p_idpracownika=NEW.p_idpracownika);
			END IF;				
		END IF;
	END IF; 
 
	RETURN NEW;
END;
$$;
