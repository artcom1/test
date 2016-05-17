CREATE FUNCTION naliczpunktypremiowe(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;
 _idkarty ALIAS FOR $2;
 _punktow ALIAS FOR $3;
 id INT;
BEGIN

 id=(SELECT kr_idkarty FROM tg_punktykarty WHERE tr_idtrans=_idtrans);
 IF (id IS NULL) THEN
 
  --Nie podano karty - nie dodajemy na sile
  IF (_idkarty IS NULL) THEN
   RETURN NULL;
  END IF;

  INSERT INTO tg_punktykarty
   (tr_idtrans,kr_idkarty,kpt_punktow)
  VALUES
   (_idtrans,_idkarty,_punktow);

  RETURN _idkarty;
 END IF;

 IF (_idkarty IS NULL) THEN
  UPDATE tg_punktykarty SET kpt_punktow=_punktow WHERE tr_idtrans=_idtrans AND kpt_punktow<>_punktow;
  RETURN id;
 ELSE
  UPDATE tg_punktykarty SET kpt_punktow=_punktow,kr_idkarty=_idkarty WHERE tr_idtrans=_idtrans AND (kpt_punktow<>_punktow OR kr_idkarty<>_idkarty);
  RETURN _idkarty;
 END IF;

 RETURN NULL;
END
$_$;
