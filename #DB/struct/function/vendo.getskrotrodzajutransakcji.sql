CREATE FUNCTION getskrotrodzajutransakcji(integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN 
 RETURN (SELECT tr_skrot FROM vendo.tm_rodzajeinfo WHERE tr_rodzaj=$1 LIMIT 1);
END;
$_$;
