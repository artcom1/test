CREATE FUNCTION createcursor(text, text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _cursorName ALIAS FOR $1;
 _query ALIAS FOR $2;
 _value ALIAS FOR $3;
 cur REFCURSOR;
 wynik INT:=0;
 mini INT:=-999999999;
 minimin INT:=999999999;
 r RECORD;
BEGIN

 ---cur:=_cursorName;
 cur:=CCursor(_cursorName,'SELECT * FROM ('||_query||') AS _asda');
 ---OPEN cur FOR EXECUTE 'SELECT * FROM ('||_query||') AS _asda';
 FETCH cur INTO r;
 IF (_value <> '') THEN
  WHILE FOUND LOOP
   IF (r._pole>=_value) THEN
    IF (r._pole=_value) THEN
     mini=wynik; EXIT;
    END IF;
    minimin=min(wynik,minimin);
   END IF;
   wynik=wynik+1;
   FETCH cur INTO r;
  END LOOP;
 END IF;


 IF FOUND THEN
  wynik=wynik+1;
  FETCH cur INTO r;

  WHILE FOUND LOOP
   wynik=wynik+1;
   FETCH cur INTO r;
  END LOOP;
 END IF;

 CLOSE cur;
 OPEN cur FOR EXECUTE 'SELECT * FROM ('||_query||') AS _asda';
 
 IF (mini>=0) THEN
  RETURN wynik||'|'||mini;
 ELSE
  IF (minimin<>999999999) THEN
   RETURN  wynik||'|'||minimin;
  ELSE
   RETURN  wynik||'|0';
  END IF;
 END IF;
END;
$_$;
