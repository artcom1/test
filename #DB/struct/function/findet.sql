CREATE FUNCTION findet(integer, numeric, numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtabeli ALIAS FOR $1;
 _wx ALIAS FOR $2;
 _wy ALIAS FOR $3;
 id INT;
BEGIN

 id=findETID(_idtabeli,_wx,_wy);
 IF (id IS NULL) THEN RETURN NULL; END IF;

 RETURN (SELECT vt_value FROM tg_tabelavalues WHERE vt_idvalue=id);
END;
$_$;
