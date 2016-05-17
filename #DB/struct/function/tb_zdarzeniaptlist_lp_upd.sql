CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE tb_zdarzeniaptlist AS zdl
	SET zdl_lp = tmp.lp
	FROM 
	(
		SELECT zdl2.zdl_id AS id, (rank() OVER (PARTITION BY zdl2.zdp_id ORDER BY zdl2.zdl_id)) AS lp
		FROM tb_zdarzeniaptlist AS zdl2	
	) AS tmp
	WHERE zdl.zdl_id=tmp.id;
	
	RETURN NEW;
END;
$$;
