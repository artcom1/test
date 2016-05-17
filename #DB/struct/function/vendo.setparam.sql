CREATE FUNCTION setparam(text, text) RETURNS boolean
    LANGUAGE sql
    AS $_$ UPDATE tc_params SET prm_value=$2 WHERE prm_name=$1; SELECT TRUE $_$;
