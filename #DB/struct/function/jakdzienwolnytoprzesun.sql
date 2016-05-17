CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 data ALIAS FOR $1;
 jestwolny INT;
BEGIN
 jestwolny=(SELECT duw_iddnia FROM ts_dniustawowowolne WHERE duw_data=data);

 IF (jestwolny>0) THEN
  RETURN JakDzienWolnyToPrzesun(data+1);
 END IF;

 RETURN data;

 END;
$_$;
