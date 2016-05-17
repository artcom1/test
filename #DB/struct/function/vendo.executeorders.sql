CREATE FUNCTION executeorders() RETURNS smallint
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
 ret INT2:=0;
BEGIN
 
 FOR r IN SELECT ord_order,ord_type FROM vendo.tm_vorders WHERE ord_backendpid=pg_backend_pid() AND ord_timestamp=now() AND ord_order IS NOT NULL ORDER BY ord_id
 LOOP
  IF (r.ord_type=0) THEN
   EXECUTE r.ord_order;
  END IF;
  ret=ret|r.ord_type;
 END LOOP;

 DELETE FROM vendo.tm_vorders WHERE ord_backendpid=pg_backend_pid() AND ord_timestamp=now() AND ord_order IS NOT NULL AND ord_type IN (0);
 
 RETURN ret;
END;
$$;
