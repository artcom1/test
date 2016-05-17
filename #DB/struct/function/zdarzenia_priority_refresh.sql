CREATE FUNCTION zdarzenia_priority_refresh() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
	r RECORD;
BEGIN
	PERFORM doEscapeZdarzeniaTriggers(1);	
		UPDATE tb_zdarzenia 
		SET zd_priority = NULL
		WHERE zd_priority IS NOT NULL 
		AND (zd_flaga&12)<>0;
	
		UPDATE tb_zdarzenia 
		SET zd_priority = NEXTVAL('zd_priority_upper')
		WHERE zd_priority IS NULL 
		AND (zd_flaga&12)=0;
		
		FOR r IN 
				SELECT z1.zd_idzdarzenia AS zd_1, z2.zd_idzdarzenia AS zd_2
				FROM tb_zdarzenia AS z1 
				JOIN tb_zdarzenia AS z2 ON (z1.zd_priority=z2.zd_priority 
											AND z1.zd_idzdarzenia <> z2.zd_idzdarzenia 
											AND z1.zd_idzdarzenia = (SELECT min(z.zd_idzdarzenia) FROM tb_zdarzenia AS z WHERE z.zd_priority=z1.zd_priority))			
			LOOP
				PERFORM zdarzenia_priority_moveafter(r.zd_2, r.zd_1);
			END LOOP;
	PERFORM doEscapeZdarzeniaTriggers(-1);	
	
	return true;
END;
$$;
