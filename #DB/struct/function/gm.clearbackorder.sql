CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelemsrc ALIAS FOR $1;
 id         INT;
BEGIN
 id=(SELECT bo_idbackord FROM tg_backorder WHERE (tel_idelemsrc=_idelemsrc));
 IF (id IS NULL) THEN
  RETURN NULL;
 END IF;

 DELETE FROM tg_backorder WHERE bo_idbackord=id;

 RETURN id;
END;
$_$;
