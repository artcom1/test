CREATE FUNCTION checkpackelemchange(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
 flag INT;
 pk_idpaczki INT;
BEGIN

 flag=(SELECT pk_flaga FROM tg_packhead AS h JOIN tg_packelem AS e ON (e.pk_idpaczki=h.pk_idpaczki) WHERE e.pe_idelemu=_idelem);

 IF ((flag&1)=1) THEN
  pk_idpaczki=(SELECT pe.pk_idpaczki FROM tg_packelem AS pe WHERE pe.pe_idelemu=_idelem);
  RAISE EXCEPTION '4|%:%|Paczka jest juz zamknieta!',pk_idpaczki,_idelem;
  RETURN FALSE;
 END IF;

 RETURN TRUE;
END;
$_$;
