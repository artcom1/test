CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN (SELECT tid_datatype FROM vendo.tm_tableinfo WHERE tid_tablename=$1);
END; $_$;
