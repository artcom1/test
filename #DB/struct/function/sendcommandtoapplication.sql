CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
		WITH sessions(id) AS 
		(
			SELECT u.id AS id
			FROM vendo.tv_vusers AS u
			WHERE u.application_name LIKE (_appName || '%')
				AND (_pracownikId IS NULL OR _pracownikId = u.p_idpracownika)
				AND (_winusersid IS NULL OR _winusersid = u.winusersid)
			GROUP BY u.id
			ORDER BY u.id
			LIMIT (CASE WHEN _sendToFirstOnly IS NULL OR _sendToFirstOnly = TRUE THEN 1 ELSE 10000 END)
		)
		SELECT t.id
		FROM (
			SELECT s.id AS id, pg_notify('lc_commands_' || s.id::TEXT, COALESCE(_command, '') || ' ' || COALESCE(_commandValue, '')) AS notify
			FROM sessions AS s) AS t;		
	END;
$$;
