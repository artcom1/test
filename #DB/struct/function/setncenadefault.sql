CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 r RECORD;
 retid INT;
BEGIN

 retid=(SELECT ttw_idtowaru FROM tg_ceny WHERE tcn_idceny=$1);

 IF (retid IS NULL) THEN
  RETURN NULL;
 END IF;

 SELECT * INTO r FROM tg_ceny WHERE tcn_isdefault=true AND ttw_idtowaru=retid;
 IF (FOUND) THEN
  UPDATE tg_ceny SET tcn_isdefault=false WHERE tcn_idceny=r.tcn_idceny AND tcn_idceny<>$1;
  retid=r.tcn_idceny;
 else
  retid=$1;
 END IF;

 UPDATE tg_ceny SET tcn_isdefault=true WHERE tcn_idceny=$1 AND tcn_isdefault=false;

 RETURN retid;
END;
$_$;
