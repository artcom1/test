CREATE FUNCTION setobjetosctowarow(text, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _skrot ALIAS FOR $1;
 _dzielnik ALIAS FOR $2;
BEGIN
  
 UPDATE tc_config SET cf_tabela='towar_jedn_obj_dzielnik', cf_defvalue=_dzielnik WHERE cf_tabela='towar_jedn_obj_dzielnik';
 INSERT INTO tc_config (cf_tabela,cf_defvalue) SELECT 'towar_jedn_obj_dzielnik', _dzielnik WHERE NOT EXISTS (SELECT cf_defvalue FROM tc_config WHERE cf_tabela='towar_jedn_obj_dzielnik');
  
 UPDATE tc_config SET cf_tabela='towar_jedn_obj_skrot', cf_defvalue=_skrot WHERE cf_tabela='towar_jedn_obj_skrot';
 INSERT INTO tc_config (cf_tabela,cf_defvalue) SELECT 'towar_jedn_obj_skrot', _skrot WHERE NOT EXISTS (SELECT cf_defvalue FROM tc_config WHERE cf_tabela='towar_jedn_obj_skrot');
	   
 RETURN 1;
END
$_$;
