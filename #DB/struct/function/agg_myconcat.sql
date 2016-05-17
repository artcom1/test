CREATE FUNCTION agg_myconcat(text, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 t text;
BEGIN
 IF  character_length($1) > 0 THEN
  t = $1 ||'??'|| $2;
 ELSE
  t = $2;
 END IF;
 RETURN t;
END;
$_$;
