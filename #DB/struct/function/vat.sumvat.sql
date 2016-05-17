CREATE FUNCTION sumvat(tb_vat, tb_vat) RETURNS tb_vat
    LANGUAGE sql
    AS $_$
 SELECT CASE WHEN $1.tr_idtrans IS NULL THEN $2 WHEN $2.tr_idtrans IS NULL THEN $1 ELSE $1+$2 END;
$_$;
