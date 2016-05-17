CREATE FUNCTION zdarzeniacykliczne_iswyjatek(integer, timestamp with time zone) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN

	IF ((SELECT count(*) 
		FROM tb_cyklwyjatki 
		JOIN tb_cyklicznosc AS ck USING (ck_idcyklu) 
		JOIN tb_zdarzenia AS zd USING (zd_idzdarzenia) 
		WHERE ck_idcyklu = $1 AND (zd.zd_datarozpoczecia + cw_lp*ck.ck_okres) = $2) > 0)
	THEN
		RETURN TRUE;	
	END IF;
	
	RETURN FALSE;	
END;
$_$;
