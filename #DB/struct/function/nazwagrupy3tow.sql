CREATE FUNCTION nazwagrupy3tow(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _flaga ALIAS FOR $1;
BEGIN
 IF (_flaga=0) THEN 
  return 'Handlowy';
 END IF;

 IF (_flaga=(1<<21)) THEN 
  return 'Wyr??b';
 END IF;

 IF (_flaga=(2<<21)) THEN 
  return 'Surowiec';
 END IF;

 IF (_flaga=(3<<21)) THEN 
  return 'P????produkt';
 END IF;

 RETURN '';
END;$_$;
