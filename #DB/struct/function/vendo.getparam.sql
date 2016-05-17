CREATE FUNCTION getparam(text) RETURNS text
    LANGUAGE sql
    AS $_$ SELECT prm_value FROM tc_params WHERE prm_name=$1 $_$;
