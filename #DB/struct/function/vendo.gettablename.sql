CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 RETURN (SELECT tid_tablename FROM vendo.tm_tableinfo WHERE tid_datatype=$1);    
END; $_$;
