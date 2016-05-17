CREATE FUNCTION binaryfind(text, text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _cursorName ALIAS FOR $1;
 _pole ALIAS FOR $2;
 _value ALIAS FOR $3;
 cur REFCURSOR;
 firstExact INT:=-1;
 moved INT:=0;
 r RECORD;
BEGIN
 cur:=_cursorName;

 FETCH cur INTO r;
 moved=moved+1;
 WHILE FOUND LOOP
  IF (r._pole=_value) THEN
   firstExact=moved-1;
   EXIT;
  END IF;
  FETCH cur INTO r;
  moved=moved+1;
 END LOOP;

 RETURN  moved||'|'||firstExact;
END;
$_$;
