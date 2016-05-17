CREATE FUNCTION zdarzenia_priority_movebefore(zd_idzdarzenia_source integer, zd_idzdarzenia_before integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 p1 INT;
 p2 INT;
 pm INT;
BEGIN
	IF (zd_idzdarzenia_source IS NULL) OR (zd_idzdarzenia_before IS NULL) OR (zd_idzdarzenia_source = zd_idzdarzenia_before) THEN
		RETURN false;
	END IF;
	
	p1 = (SELECT zd_priority FROM tb_zdarzenia AS zd WHERE zd.zd_idzdarzenia = zd_idzdarzenia_source);
	p2 = (SELECT zd_priority FROM tb_zdarzenia AS zd WHERE zd.zd_idzdarzenia = zd_idzdarzenia_before);
	
	IF (p1 IS NULL) OR (p2 IS NULL) OR (p1 < p2) THEN
		RETURN false;
	END IF;
	
	PERFORM doEscapeZdarzeniaTriggers(1);	
		IF (p1 = p2) THEN
			UPDATE tb_zdarzenia AS zd SET zd_priority=zd_priority+1 WHERE zd_priority IS NOT NULL AND zd_priority >= p1 AND zd.zd_idzdarzenia <> zd_idzdarzenia_source;
		ELSE 
			IF (p1-1 = p2) THEN
				UPDATE tb_zdarzenia AS zd  SET zd_priority=p2 WHERE zd.zd_idzdarzenia = zd_idzdarzenia_source;
				UPDATE tb_zdarzenia AS zd  SET zd_priority=p1 WHERE zd.zd_idzdarzenia = zd_idzdarzenia_before;
			ELSE
				pm = (SELECT zdarzenia_priority_firstfree(p1, p2, true));	
				
				UPDATE tb_zdarzenia SET zd_priority=zd_priority+1 WHERE zd_priority IS NOT NULL AND zd_priority >= p2 AND zd_priority < COALESCE(pm, p1);	
				UPDATE tb_zdarzenia SET zd_priority=p2 WHERE zd_idzdarzenia=zd_idzdarzenia_source;
			END IF;		
		END IF;	
	PERFORM doEscapeZdarzeniaTriggers(-1);
	
	RETURN true;
END;
$$;
