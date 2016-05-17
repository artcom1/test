CREATE FUNCTION execnoerrornoticequery(q text, qnoerror text DEFAULT NULL::text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 tmp TEXT;
BEGIN
 tmp = current_setting('client_min_messages');
 PERFORM set_config('client_min_messages','warning',true);
  
 EXECUTE q;

 IF (qnoerror IS NOT NULL) THEN 
  BEGIN
  
   EXECUTE qnoerror;
   
   EXCEPTION WHEN OTHERS THEN 
   BEGIN 
    PERFORM set_config('client_min_messages',tmp,true);
    RETURN TRUE;
   END;
  END;
 END IF;
 
 PERFORM set_config('client_min_messages',tmp,true); 
 RETURN TRUE;
END
$$;
