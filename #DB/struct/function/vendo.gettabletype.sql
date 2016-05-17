CREATE FUNCTION gettabletype(tablename text) RETURNS integer
    LANGUAGE sql
    AS $_$
 SELECT tid_datatype FROM vendo.tm_tableinfo WHERE tid_tablename=$1;
$_$;
