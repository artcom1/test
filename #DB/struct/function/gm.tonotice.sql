CREATE FUNCTION tonotice(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 ret  TEXT;
 reti TEXT;
BEGIN
 ret=replace($1,'\r\n',' ');
 LOOP
  reti=ret;
  ret=replace(ret,'   ',' ');
  EXIT WHEN ret=reti;
 END LOOP;

 RETURN ret;
END;
$_$;
