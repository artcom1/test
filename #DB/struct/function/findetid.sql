CREATE FUNCTION findetid(integer, numeric, numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtabeli ALIAS FOR $1;
 _wx ALIAS FOR $2;
 _wy ALIAS FOR $3;
 idx INT;
 idy INT;
BEGIN

 idx=(SELECT et_idelementu FROM tg_eltabeli WHERE tb_idtabeli=_idtabeli AND et_key>=_wx AND (et_flaga&3=0) ORDER BY et_key ASC LIMIT 1 OFFSET 0);
 IF (idx IS NULL) THEN RETURN NULL; END IF;

 idy=(SELECT et_idelementu FROM tg_eltabeli WHERE tb_idtabeli=_idtabeli AND et_key>=_wy AND (et_flaga&3=1) ORDER BY et_key ASC LIMIT 1 OFFSET 0);
 IF (idy IS NULL) THEN RETURN NULL; END IF;

 RETURN (SELECT vt_idvalue FROM tg_tabelavalues WHERE et_idelementux=idx AND et_idelementuy=idy);
END;
$_$;
