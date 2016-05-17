CREATE FUNCTION dodajet(integer, integer, numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _wx ALIAS FOR $1;
 _wy ALIAS FOR $2;
 _value ALIAS FOR $3;
 id INT;
BEGIN

 id=(SELECT vt_idvalue FROM tg_tabelavalues WHERE et_idelementux=_wx AND et_idelementuy=_wy);
 IF (id IS NULL) THEN
  INSERT INTO tg_tabelavalues (et_idelementux,et_idelementuy,vt_value,tb_idtabeli) VALUES (_wx,_wy,_value,(SELECT tb_idtabeli FROM tg_eltabeli WHERE et_idelementu=_wx));
  id=(SELECT currval('tg_tabelavalues_s'));
 ELSE
  UPDATE tg_tabelavalues SET vt_value=_value WHERE vt_idvalue=id AND vt_value<>_value;
 END IF;

 RETURN id;
END;
$_$;
