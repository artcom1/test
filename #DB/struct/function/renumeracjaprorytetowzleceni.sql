CREATE FUNCTION renumeracjaprorytetowzleceni(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _typ ALIAS FOR $1;
 _centrala ALIAS FOR $2;
 _where TEXT;
 _bycentrala INTEGER;
 _byrodzaj INTEGER;
 _byosoba INTEGER;
 _bydzial INTEGER;
BEGIN
  _where := '0=0';

  IF (_typ IS NOT NULL) THEN
    _where := _where || ' AND zl_typ=' || _typ;
  END IF;

  IF (_centrala IS NOT NULL) THEN
    _where := _where || ' AND fm_idcentrali=' || _centrala;
  END IF;

  _bycentrala := (SELECT COALESCE(cf_defvalue::int,0) FROM tc_config WHERE cf_tabela='PrZlWgCentrala');
  _byrodzaj := (SELECT COALESCE(cf_defvalue::int,0) FROM tc_config WHERE cf_tabela='PrZlWgRodzaj');
  _byosoba := (SELECT COALESCE(cf_defvalue::int,0) FROM tc_config WHERE cf_tabela='PrZlWgOsoba');
  _bydzial := (SELECT COALESCE(cf_defvalue::int,0) FROM tc_config WHERE cf_tabela='PrZlWgDzial');

  EXECUTE renumeracjaprorytetowzlecen((_bycentrala<>0), (_byrodzaj<>0), (_byosoba<>0), (_bydzial<>0), _where);
  RETURN 1;
END;
$_$;
