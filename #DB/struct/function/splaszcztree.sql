CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 IF ($1 IS NULL) THEN RETURN ''; END IF;

 RETURN splaszczTree((SELECT te_parent FROM tg_trees WHERE te_idelemu=$1))||'/'||(SELECT te_nazwa FROM tg_trees WHERE te_idelemu=$1);
END;
$_$;
