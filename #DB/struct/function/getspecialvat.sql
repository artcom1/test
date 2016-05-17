CREATE FUNCTION getspecialvat(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowaru ALIAS FOR $1;
 _idkraju ALIAS FOR $2;
 id INT;
BEGIN

 id=(SELECT ttv_idvatu FROM tg_vatytowarow JOIN tg_vatykraje USING (vk_idvatkraj) WHERE ttw_idtowaru=_idtowaru AND tg_vatykraje.pw_idpowiatu=_idkraju);
 IF (id IS NOT NULL) THEN
  RETURN id;
 END IF;

 RETURN NULL;
END
$_$;
