CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowaru ALIAS FOR $1;
 _idkraju ALIAS FOR $2;
 id INT;
BEGIN

 id=(SELECT tv_idvatu FROM tg_vatytowarow WHERE ttw_idtowaru=_idtowaru AND pw_idpowiatu=_idkraju);

 IF (id IS NULL) THEN
  RETURN NULL;
 END IF;

 DELETE FROM tg_vatytowarow WHERE tv_idvatu=id;

 RETURN id;
END
$_$;
