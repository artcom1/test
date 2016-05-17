CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
---Funkcja ustawia informacje o tym ze wykorzystano funkcje oznaczania partii
---UWAGA: Funkcja powinna byc wykonana tyle razy z domark=TRUE ile razy z domark=FALSE
DECLARE
 tmp INT;
 tmpb INT8;
BEGIN 
 IF (setid IS NULL) THEN
  RAISE EXCEPTION 'Musi byc podane SETID!';
 END IF;
 
 IF (domark=TRUE) THEN ---Tryb oznaczania
  PERFORM gm.createoznaczruchytable();
  --- Zwieksz znacznik o 1
  tmp=vendo.deltaTParamI('ANYOZNACZONYRUCHCNT'||(setid::text),1,0);  
  IF (tmp=1) THEN --- Jesli to pierwsze zwiekszenie zwieksz znacznik ogolny
   tmp=vendo.deltaTParamI('ANYOZNACZONYRUCHCNT',1,0);   
   --- Zrob wpis na stosie
   tmpb=gm.topOznaczRuchN();
   
   IF ((usePrevious=TRUE) AND (tmpb>0)) THEN
    ---Potraktuj poprzedni tak by oznaczone ruchy w poprzednim kroku zostaly dodane do biezacego kroku
    INSERT INTO tm_oznaczoneruchy (ozr_setid,rc_idruchu) SELECT setid,rc_idruchu FROM tm_oznaczoneruchy WHERE ozr_setid=tmpb;
	---Nie ograniczamy mozliwych do zaznaczenia ruchow do zbioru ruchow zaznaczonych w poprzednim kroku
    PERFORM vendo.setTParam('ANYOZNACZONYRUCH_IGNOREPREV_'||setid,'1');  
   END IF;
   
   PERFORM vendo.setTParam('ANYOZNACZONYRUCH_TOP',setid::text);
   PERFORM vendo.setTParam('ANYOZNACZONYRUCH_PREV_'||setid,tmpb::text);  
  END IF;
 ELSE
  tmp=vendo.deltaTParamI('ANYOZNACZONYRUCHCNT'||(setid::text),-1,0);  
  IF (tmp=0) THEN --- Jesli to ostatnie zmniejszenie zmniejsz znacznik ogolny
   tmp=vendo.deltaTParamI('ANYOZNACZONYRUCHCNT',-1,0);
   DELETE FROM tm_oznaczoneruchy WHERE ozr_setid>=setid; 
   --- Zdejm ze stosu
   tmpb=gm.prevOznaczRuchN(setid);
   PERFORM vendo.setTParam('ANYOZNACZONYRUCH_TOP',tmpb::text);
  END IF;
 END IF;
 
 RETURN setid;
END;
$$;
