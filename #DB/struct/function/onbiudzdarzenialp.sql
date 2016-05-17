CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 _zd_wersja INT;
 zdrewizja RECORD;
BEGIN

 IF ((TG_OP!='DELETE') AND (shouldEscapeZdarzeniaTriggers()=TRUE)) THEN
  RETURN NEW;
 END IF;

 --- Ustal wartosci przy INSERcie
 IF (TG_OP='INSERT') THEN

  IF (NEW.zd_idrewizja IS NOT NULL) THEN
   SELECT  zd_lp, zd_lpprefix, COALESCE(zd_wersja,1) AS zd_wersja, zd_idparent INTO zdrewizja FROM tb_zdarzenia WHERE zd_idzdarzenia=NEW.zd_idrewizja;

   _zd_wersja=zdrewizja.zd_wersja+1;
   
   NEW.zd_lp=zdrewizja.zd_lp;
   NEW.zd_lpprefix=zdrewizja.zd_lpprefix;
   NEW.zd_wersja=zdrewizja.zd_wersja;
   NEW.zd_idparent=zdrewizja.zd_idparent;
      
   UPDATE tb_zdarzenia SET zd_wersja=_zd_wersja WHERE zd_idzdarzenia=NEW.zd_idrewizja;
   RETURN NEW;      
  ELSE
   IF (NEW.zd_idparent IS NOT NULL) THEN
    NEW.zd_lpprefix=(SELECT toZdarzenieLPFull(zd_lpprefix,zd_lp) FROM tb_zdarzenia WHERE zd_idzdarzenia=NEW.zd_idparent);
   END IF;
  END IF;  

  IF ((NEW.zl_idzlecenia IS NOT NULL) OR (NEW.zd_idparent IS NOT NULL)) THEN 
   IF (NEW.zd_lp IS NULL) THEN
    NEW.zd_lp=nullZero((SELECT max(zd_lp) FROM tb_zdarzenia 
                       WHERE zd_lp IS NOT NULL 
		       AND (
		            (NEW.zd_idparent IS NOT NULL AND zd_idparent=NEW.zd_idparent) OR
		            (NEW.zd_idparent IS NULL AND zd_idparent IS NULL)
			   )
		       AND (
		            (NEW.zl_idzlecenia IS NOT NULL AND zl_idzlecenia=NEW.zl_idzlecenia) OR
			    (NEW.zl_idzlecenia IS NULL AND zl_idzlecenia IS NULL)
			   )
		     ))+1;
   ELSE
    IF (NEW.zd_idrewizja IS NULL) THEN
     UPDATE tb_zdarzenia SET zd_lp=zd_lp+1 
                       WHERE zd_lp>=NEW.zd_lp
 		       AND (
		            (NEW.zd_idparent IS NOT NULL AND zd_idparent=NEW.zd_idparent) OR
		            (NEW.zd_idparent IS NULL AND zd_idparent IS NULL)
			   )
		       AND (
		            (NEW.zd_idparent IS NOT NULL) OR
		            (NEW.zl_idzlecenia IS NOT NULL AND zl_idzlecenia=NEW.zl_idzlecenia) OR
			    (NEW.zl_idzlecenia IS NULL AND zl_idzlecenia IS NULL)
			   );
	END IF;
   END IF;
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN

  IF ((NEW.zl_idzlecenia IS NULL) AND (NEW.zd_idparent IS NULL)) THEN 
   NEW.zd_lp=NULL;
   NEW.zd_lpprefix=NULL;
  END IF;

  IF (
      (COALESCE(NEW.zl_idzlecenia,0)<>COALESCE(OLD.zl_idzlecenia,0))
     ) AND 
     (NEW.zd_idparent IS NOT NULL) 
  THEN
   NEW.zd_idparent=(SELECT zd_idzdarzenia FROM tb_zdarzenia 
                    WHERE COALESCE(zl_idzlecenia,0)=COALESCE(NEW.zl_idzlecenia,0) AND 
		          zd_idzdarzenia=NEW.zd_idparent
	            );
   IF (NEW.zd_idparent IS NULL) THEN
    RAISE EXCEPTION 'Blad mainpulacji na drzewie zdarzen (projekt/ticket) % %',NEW.zd_idzdarzenia,NEW.zl_idzlecenia;
   END IF;
  END IF;

  IF (((NEW.zl_idzlecenia IS NOT NULL) OR (NEW.zd_idparent IS NOT NULL)) AND NEW.zd_idrewizja IS NULL) THEN 
   IF (COALESCE(NEW.zd_idparent,0)<>COALESCE(OLD.zd_idparent,0)) OR 
      (((NEW.zd_flaga&(1<<15))<>0) AND (COALESCE(NEW.zl_idzlecenia,0)<>COALESCE(OLD.zl_idzlecenia,0)))
   THEN
   IF (COALESCE(NEW.zd_idparent,0)<>COALESCE(OLD.zd_idparent,0)) OR 
      (COALESCE(NEW.zl_idzlecenia,0)<>COALESCE(OLD.zl_idzlecenia,0))
   THEN
    RAISE NOTICE ':LP przed zmianami: % %', NEW.zd_lpprefix, NEW.zd_lp;
	NEW.zd_lpprefix=(SELECT toZdarzenieLPFull(zd_lpprefix,zd_lp) FROM tb_zdarzenia WHERE zd_idzdarzenia=NEW.zd_idparent);
	NEW.zd_lp=nullZero((SELECT max(zd_lp) FROM tb_zdarzenia 
                       WHERE zd_lp IS NOT NULL 
		       AND zd_idzdarzenia<>NEW.zd_idzdarzenia
			   AND zd_idrewizja IS NULL
		       AND (
		            (NEW.zd_idparent IS NOT NULL AND zd_idparent=NEW.zd_idparent) OR
		            (NEW.zd_idparent IS NULL AND zd_idparent IS NULL)
			   )
		       AND (
		            (NEW.zd_idparent IS NOT NULL) OR
		            (NEW.zl_idzlecenia IS NOT NULL AND zl_idzlecenia=NEW.zl_idzlecenia) OR
			    (NEW.zl_idzlecenia IS NULL AND zl_idzlecenia IS NULL)
			   )
		     ))+1;
    RAISE NOTICE ':LP po zmianach: % %', NEW.zd_lpprefix, NEW.zd_lp;
    END IF;		   
   END IF;
   NEW.zd_flaga=NEW.zd_flaga&(~(1<<15));		    
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$$;
