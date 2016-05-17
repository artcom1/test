CREATE FUNCTION podczetaputopodczzd(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
	id_dok ALIAS FOR $1;
	id_zdarzenia ALIAS FOR $2;
	ret integer;
	
	dok record;
BEGIN
	SELECT * INTO dok FROM tg_podczepieniadoetapow WHERE pde_idpodczepienia=id_dok;

	INSERT INTO tb_zdpowiazania (zd_idzdarzenia, zp_idref, zp_datatype) 
	VALUES(id_zdarzenia, dok.pde_ref, dok.pde_typref);

	ret = (SELECT currval('tb_zdpowiazania_s'));

	RETURN ret;
END;
$_$;
