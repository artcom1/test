CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
		SELECT SendCommandToApplication('VPhone', _command, _commandValue, _winusersid, _pracownikId, _sendToFirstOnly);		
	END;
$$;
