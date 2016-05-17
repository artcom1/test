CREATE OR REPLACE FUNCTION 
    LANGUAGE sql STABLE
    AS $_$
 SELECT cf_defvalue FROM tc_config WHERE cf_tabela=$1;
$_$;
