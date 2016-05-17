CREATE FUNCTION sendcommandtovphone(_command text, _commandvalue text, _winusersid text, _pracownikid integer, _sendtofirstonly boolean) RETURNS TABLE(sessionid integer)
    LANGUAGE plpgsql
    AS $$
	BEGIN
		RETURN QUERY
		SELECT SendCommandToApplication('VPhone', _command, _commandValue, _winusersid, _pracownikId, _sendToFirstOnly);		
	END;
$$;
