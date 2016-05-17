CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 p INT;
BEGIN
	IF (p_start IS NULL) OR (p_end IS NULL) OR (search_in_order IS NULL) THEN
		RETURN NULL;
	END IF;
	
	IF p_start > p_end THEN
		p = p_end;
		p_end = p_start;
		p_start = p;
		p = NULL;
	END IF;

	IF search_in_order THEN
		p = (WITH RECURSIVE t(n) AS (
				SELECT p_start WHERE EXISTS(SELECT * FROM tb_zdarzenia AS z WHERE z.zd_priority = p_start)
				UNION ALL
				SELECT n+1 FROM t JOIN tb_zdarzenia AS z ON (z.zd_priority=n+1) WHERE (n+1) <= p_end
			)
			SELECT max(n) FROM t);
				
		IF p IS NULL THEN	
			RETURN p_start;	
		END IF;
		
		IF p = p_end THEN
			RETURN NULL;
		ELSE
			RETURN p+1;
		END IF;
	ELSE
		p = (WITH RECURSIVE t(n) AS (
				SELECT p_end WHERE EXISTS(SELECT * FROM tb_zdarzenia AS z WHERE z.zd_priority = p_end)
				UNION ALL
				SELECT n-1 FROM t JOIN tb_zdarzenia AS z ON (z.zd_priority=n-1) WHERE (n-1) >= p_start
			)
			SELECT min(n) FROM t);
			
		IF p IS NULL THEN	
			RETURN p_end;	
		END IF;
		
		IF p = p_start THEN
			RETURN NULL;
		ELSE
			RETURN p-1;
		END IF;
	END IF;
END;
$$;
