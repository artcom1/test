CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _cursorName ALIAS FOR $1;
 _pole ALIAS FOR $2;
 _value ALIAS FOR $3;
 _count ALIAS FOR $4;
 _length ALIAS FOR $5;

 cur REFCURSOR;
 firstExact INT:=-1;
 moved INT:=0;
 r TEXT;
 r2 TEXT;
BEGIN
 cur:=_cursorName;

 FETCH cur INTO r2,r;
 moved=moved+1;
 WHILE FOUND LOOP
  IF (r=_value) THEN
   firstExact=moved-1;
   EXIT;
  END IF;
  FETCH cur INTO r2,r;
  moved=moved+1;
 END LOOP;

 RETURN  moved||'|'||firstExact;
END;
$_$;
