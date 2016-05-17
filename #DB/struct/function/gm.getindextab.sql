CREATE FUNCTION getindextab(idcentrali integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$
 SELECT fm_idindextab FROM tb_firma WHERE fm_index=$1
$_$;
