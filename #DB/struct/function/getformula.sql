CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN (SELECT f_formula FROM tg_fkalkulacji WHERE ttw_idtowaru=$1);
END;
$_$;
