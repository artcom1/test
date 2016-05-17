CREATE FUNCTION ustawprorytetzlecenia(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _zl_idzlecenia ALIAS FOR $1;
 _new_priorytet INT:= $2;
 _zl1 RECORD;
 _maxlp INT;
 _where TEXT;
 _maxlp_query TEXT;
 _updquery TEXT;
BEGIN
  SELECT zl_idzlecenia, zl_typ, zl_prorytet, fm_idcentrali, zl_rodzajimp, p_odpowiedzialny, dz_iddzialu INTO _zl1 FROM tg_zlecenia WHERE zl_idzlecenia=_zl_idzlecenia; 
  SELECT podzialpriorytetowzlecen(_zl1.zl_typ, _zl1.fm_idcentrali, _zl1.zl_rodzajimp, _zl1.p_odpowiedzialny, _zl1.dz_iddzialu) INTO _where;

  _maxlp_query := 'SELECT zl_prorytet FROM tg_zlecenia WHERE zl_prorytet IS NOT NULL AND ' || _where || ' ORDER by zl_prorytet DESC LIMIT 1';
  EXECUTE _maxlp_query INTO _maxlp;

  IF (_new_priorytet <= 0) THEN
    _new_priorytet := 1;
  END IF;
  
  IF (_new_priorytet > _maxlp) THEN
    _new_priorytet := _maxlp;
  END IF;

  _updquery := 'UPDATE tg_zlecenia SET zl_prorytet=zl_prorytet';
  IF (_new_priorytet < _zl1.zl_prorytet) THEN
    _updquery := _updquery || '+1';
  ELSE
    _updquery := _updquery || '-1';
  END IF;
  _updquery := _updquery || ' WHERE ' || _where;
  IF (_new_priorytet < _zl1.zl_prorytet) THEN
    _updquery := _updquery || ' AND zl_prorytet>=' || _new_priorytet || ' AND zl_prorytet<' || _zl1.zl_prorytet;
  ELSE
    _updquery := _updquery || ' AND zl_prorytet<=' || _new_priorytet || ' AND zl_prorytet>' || _zl1.zl_prorytet;
  END IF;
  EXECUTE _updquery;
  UPDATE tg_zlecenia SET zl_prorytet=_new_priorytet WHERE zl_idzlecenia=_zl1.zl_idzlecenia;

  RETURN _zl1.zl_idzlecenia;
END;
$_$;
