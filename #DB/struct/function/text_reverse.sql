CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
	reverse_str TEXT;
BEGIN
    reverse_str := '';
    FOR i IN REVERSE LENGTH(txt)..1 LOOP
      reverse_str := reverse_str || substr(txt,i,1);
    END LOOP;
	RETURN reverse_str;
END;
$$;
