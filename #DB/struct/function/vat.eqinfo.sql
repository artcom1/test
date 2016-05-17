CREATE FUNCTION eqinfo(tb_vat, tb_vat) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
 SELECT ($1.tr_idtrans=$2.tr_idtrans) AND
        ($1.v_stvat=$2.v_stvat) AND
	($1.v_zw=$2.v_zw) AND
	($1.v_kurswal=$2.v_kurswal) AND
	($1.v_idwaluty IS NOT DISTINCT FROM $2.v_idwaluty) AND
	($1.v_isorg=$2.v_isorg) AND
	($1.v_iswal=$2.v_iswal) AND
	($1.v_iscorr=$2.v_iscorr) AND
	($1.v_ispkormakro=$2.v_ispkormakro) AND
	($1.v_iskgoforwal=$2.v_iskgoforwal);
$_$;
