CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
		SELECT SendCommandToApplication('Vendo', _command, _commandValue, _winusersid, _pracownikId, _sendToFirstOnly);		
	END;
$$;
