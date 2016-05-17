CREATE FUNCTION statuswynagrodzenia(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE 
  iledni TEXT;
BEGIN
  IF (($1&7)=0) THEN
    iledni='Oczekujace';
  ELSE
    IF (($1&7)=3) THEN
      iledni='Do wyp??aty';
   ELSE
     IF (($1&7)=4) THEN
       iledni='Do anulowania';
     ELSE
      IF (($1&7)=5) THEN
        iledni='Wyp??acono';
      ELSE
        IF (($1&7)=6) THEN
          iledni='Anulowano';
	ELSE
	  iledni='Nie znany';
	END IF;
      END IF;
     END IF;
   END IF;
  END IF;
  RETURN iledni;
END;$_$;
