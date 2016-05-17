CREATE FUNCTION migracjaustawienpodcentrale(text) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _ust ALIAS FOR $1;
 wartosc TEXT;
 r RECORD;
BEGIN
 
 wartosc=(SELECT cf_defvalue FROM tc_config WHERE cf_tabela=_ust);

 FOR r IN SELECT DISTINCT fm_idcentrali FROM tb_firma 
 LOOP
  INSERT INTO tc_config(cf_tabela,cf_defvalue) VALUES (_ust||r.fm_idcentrali,wartosc);
 END LOOP;


 RETURN '';
END;$_$;
