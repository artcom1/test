CREATE FUNCTION getskrotrodzajuzlecenia(integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN 
 RETURN COALESCE((SELECT zl_skrot FROM vendo.tm_rodzajezleceninfo WHERE zl_typ=$1 LIMIT 1),'---');
END;
$_$;
