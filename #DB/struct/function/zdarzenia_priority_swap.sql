CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 p1 INT;
 p2 INT;
BEGIN
	IF (zd_idzdarzenia_a IS NULL) OR (zd_idzdarzenia_b IS NULL) OR (zd_idzdarzenia_a = zd_idzdarzenia_b) THEN
		RETURN false;
	END IF;

	p1 = (SELECT zd_priority FROM tb_zdarzenia AS zd WHERE zd.zd_idzdarzenia = zd_idzdarzenia_a);
	p2 = (SELECT zd_priority FROM tb_zdarzenia AS zd WHERE zd.zd_idzdarzenia = zd_idzdarzenia_b);
	
	IF (p1 IS NULL) OR (p2 IS NULL) OR (p1=p2) THEN
		RETURN false;
	END IF;
		
	PERFORM doEscapeZdarzeniaTriggers(1);	
		UPDATE tb_zdarzenia AS zd  SET zd_priority=p2 WHERE zd.zd_idzdarzenia = zd_idzdarzenia_a;
		UPDATE tb_zdarzenia AS zd  SET zd_priority=p1 WHERE zd.zd_idzdarzenia = zd_idzdarzenia_b;		
	PERFORM doEscapeZdarzeniaTriggers(-1);
	
	RETURN true;
END;
$$;
