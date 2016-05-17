CREATE FUNCTION zdarzenia_priority_movebottom(zd_idzdarzenia_source integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF (zd_idzdarzenia_source IS NULL) THEN
		RETURN false;
	END IF;
	
	PERFORM doEscapeZdarzeniaTriggers(1);
		UPDATE tb_zdarzenia AS zd SET zd_priority=NEXTVAL('zd_priority_upper') WHERE zd.zd_idzdarzenia=zd_idzdarzenia_source;
	PERFORM doEscapeZdarzeniaTriggers(-1);
	
	RETURN true;
END;
$$;
