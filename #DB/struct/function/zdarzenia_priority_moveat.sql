CREATE FUNCTION zdarzenia_priority_moveat(zd_idzdarzenia_source integer, zd_idzdarzenia_destination integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 p1 INT;
 p2 INT;
 moved BOOLEAN;
BEGIN
	IF (zd_idzdarzenia_source IS NULL) OR (zd_idzdarzenia_destination IS NULL) OR (zd_idzdarzenia_source = zd_idzdarzenia_destination) THEN
		RETURN false;
	END IF;
	
	p1 = (SELECT zd_priority FROM tb_zdarzenia AS zd WHERE zd.zd_idzdarzenia = zd_idzdarzenia_source);
	p2 = (SELECT zd_priority FROM tb_zdarzenia AS zd WHERE zd.zd_idzdarzenia = zd_idzdarzenia_destination);
		
	IF (p1 IS NULL) OR (p2 IS NULL) THEN
		RETURN false;
	END IF;
		
	PERFORM doEscapeZdarzeniaTriggers(1); 	
		IF (p1 < p2) THEN	
			moved = (SELECT zdarzenia_priority_moveafter(zd_idzdarzenia_source, zd_idzdarzenia_destination));
		ELSE 
			moved = (SELECT zdarzenia_priority_movebefore(zd_idzdarzenia_source, zd_idzdarzenia_destination));
		END IF;		
	PERFORM doEscapeZdarzeniaTriggers(-1);
	
	RETURN true;
END;
$$;
