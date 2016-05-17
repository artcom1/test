CREATE FUNCTION zdarzenia_owner_refreshdzial() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	r RECORD;
BEGIN
	UPDATE tb_zdarzenia AS zd
	SET dz_iddzialu = (SELECT p.dz_iddzialu FROM tb_pracownicy AS p WHERE p.p_idpracownika=zd.p_idpracownika)
	WHERE ((zd_flaga>>19)&1)=0
		AND p_idpracownika IS NOT NULL 
		AND p_idpracownika <> 0
		AND ((dz_iddzialu IS NULL) OR (dz_iddzialu <> (SELECT p.dz_iddzialu FROM tb_pracownicy AS p WHERE p.p_idpracownika=zd.p_idpracownika)));
		
	UPDATE tb_zdarzenia AS zd
	SET dz_iddzialu = 0
	WHERE ((zd_flaga>>19)&1)=0
		AND (p_idpracownika IS NULL OR p_idpracownika = 0);
		
	return true;
END;
$$;
