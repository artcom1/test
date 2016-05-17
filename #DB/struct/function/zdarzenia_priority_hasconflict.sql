CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN
	RETURN (SELECT count(*) FROM tb_zdarzenia AS z1 JOIN tb_zdarzenia AS z2 ON (z1.zd_priority=z2.zd_priority AND z1.zd_idzdarzenia<>z2.zd_idzdarzenia)) > 0;
END;
$$;
