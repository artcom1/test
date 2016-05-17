CREATE FUNCTION plisfifotorr(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
 
 IF (($1&((1<<21)|(1<<25)))=((1<<21)|(1<<25))) THEN
  RETURN TRUE;
 END IF;

 RETURN FALSE;
END;
$_$;
