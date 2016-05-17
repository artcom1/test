CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
  _typ ALIAS FOR $1;
  _centrala ALIAS FOR $2;
  _rodzaj ALIAS FOR $3;
  _osoba ALIAS FOR $4;
  _dzial ALIAS FOR $5;
  _bycentrala INTEGER;
  _byrodzaj INTEGER;
  _byosoba INTEGER;
  _bydzial INTEGER;
  _ret TEXT;
BEGIN
  _bycentrala := (SELECT COALESCE(cf_defvalue::int,0) FROM tc_config WHERE cf_tabela='PrZlWgCentrala');
  _byrodzaj := (SELECT COALESCE(cf_defvalue::int,0) FROM tc_config WHERE cf_tabela='PrZlWgRodzaj');
  _byosoba := (SELECT COALESCE(cf_defvalue::int,0) FROM tc_config WHERE cf_tabela='PrZlWgOsoba');
  _bydzial := (SELECT COALESCE(cf_defvalue::int,0) FROM tc_config WHERE cf_tabela='PrZlWgDzial');

  _ret := 'zl_typ=' || _typ;
  IF ((_bycentrala<>0) AND (_centrala IS NOT NULL)) THEN _ret := _ret || ' AND fm_idcentrali=' || _centrala; END IF;
  IF ((_byrodzaj<>0) AND (_rodzaj IS NOT NULL)) THEN _ret := _ret || ' AND zl_rodzajimp=' || _rodzaj; END IF;
  IF ((_byosoba<>0) AND (_osoba IS NOT NULL)) THEN _ret := _ret || ' AND p_odpowiedzialny=' || _osoba; END IF;
  IF ((_bydzial<>0) AND (_dzial IS NOT NULL)) THEN _ret := _ret || ' AND dz_iddzialu=' || _dzial; END IF;

  RETURN _ret;
END;$_$;
