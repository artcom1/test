CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 id_rodzaju ALIAS FOR $1; --id rodzaju archiwum
 zdrodzaj ALIAS FOR $2; --rodzaj zdarzenia
 t_idtypu integer;
BEGIN	
	SELECT tsz_idtypu INTO t_idtypu FROM ts_typzdarzenia WHERE tsz_oldid = id_rodzaju AND zd_rodzaj = zdrodzaj;
	RETURN t_idtypu;
END;
$_$;
