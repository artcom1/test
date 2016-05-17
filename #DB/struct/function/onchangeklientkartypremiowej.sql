CREATE FUNCTION onchangeklientkartypremiowej(integer, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;
 _idklienta ALIAS FOR $2;
 id INT;
 idold INT;
BEGIN

 IF (_idklienta IS NULL) THEN
  id=(SELECT kr_idkarty FROM tg_punktykarty WHERE tr_idtrans=_idtrans);
  DELETE FROM tg_punktykarty WHERE tr_idtrans=_idtrans;
  RETURN id||'|';
 END IF;

 --Sprawdz czy juz nie jest karta wlasciwego klienta
 id=(SELECT k_idklienta FROM tg_punktykarty JOIN tg_kartypremiowe USING (kr_idkarty) WHERE tr_idtrans=_idtrans);
 IF (id=_idklienta) THEN
  RETURN NULL;
 END IF;

 idold=(SELECT kr_idkarty FROM tg_punktykarty WHERE tr_idtrans=_idtrans);

 --Wez karte na ktora mam naliczyc teraz punkty
 id=(SELECT kr_idkarty FROM tg_kartypremiowe WHERE kr_flaga&1=1 AND k_idklienta=_idklienta);
 IF (id IS NULL) THEN
  DELETE FROM tg_punktykarty WHERE tr_idtrans=_idtrans;
  RETURN COALESCE(idold,0)||'|';
 END IF;

 IF (idold IS NOT NULL) THEN
  UPDATE tg_punktykarty SET kr_idkarty=id WHERE tr_idtrans=_idtrans;
 ELSE
  id=naliczPunktyPremiowe(_idtrans,id,0);
 END IF;
    
 RETURN COALESCE(idold,0)||'|'||COALESCE(id,0);
END
$_$;
