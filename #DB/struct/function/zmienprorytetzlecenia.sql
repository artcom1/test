CREATE FUNCTION zmienprorytetzlecenia(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _zl_idzlecenia ALIAS FOR $1;
 _wgore ALIAS FOR $2;
 _old_priorytet INTEGER;
 _new_priorytet INTEGER;
 ret INTEGER;
BEGIN
  SELECT COALESCE(zl_prorytet, 0) INTO _old_priorytet FROM tg_zlecenia WHERE zl_idzlecenia=_zl_idzlecenia;

  IF (_wgore) THEN
   _new_priorytet := _old_priorytet - 1;
  ELSE
   _new_priorytet := _old_priorytet + 1;
  END IF;

  SELECT ustawprorytetzlecenia(_zl_idzlecenia, _new_priorytet) INTO ret;
  RETURN ret;
END;
$_$;
