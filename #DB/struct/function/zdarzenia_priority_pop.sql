CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 p INT;
 nextp TEXT;
BEGIN
	IF (zd_idzdarzenia_source IS NULL) OR (prefer_max IS NULL) THEN
		RETURN NULL;
	END IF;

	IF prefer_max THEN
		nextp = 'zd_priority_upper';
	ELSE 
		nextp = 'zd_priority_lower';
	END IF;

	p = (SELECT zpr_oldpriority FROM tb_zdarzenia_priority AS zd WHERE zd.zpr_zd_idzdarzenia = zd_idzdarzenia_source);	
	
	IF (p IS NOT NULL) THEN	
		DELETE FROM tb_zdarzenia_priority AS zd WHERE zd.zpr_zd_idzdarzenia = zd_idzdarzenia_source;
		
		p = (SELECT zdarzenia_priority_firstfree(p, p+100, true));
		
		IF (p IS NOT NULL) THEN
			RETURN p;		
		END IF;		
	END IF;	
	
	RETURN NEXTVAL(nextp);
END;
$$;
