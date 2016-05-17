CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $_$
 SELECT tid_datatype FROM vendo.tm_tableinfo WHERE tid_tablename=$1;
$_$;
