CREATE FUNCTION createoznaczruchytable() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
---- Utworz tabele w ktorej beda ruchy oznaczone
DECLARE
 tmp TEXT;
BEGIN 
 IF (gm.isAnyOznaczonyRuchN(NULL)=TRUE) THEN
  RETURN TRUE;
 END IF;
 
 tmp = current_setting('client_min_messages');
 PERFORM set_config('client_min_messages','warning',true);
  
 CREATE TEMP TABLE IF NOT EXISTS tm_oznaczoneruchy
 (
  ozr_setid BIGINT DEFAULT gm.topOznaczRuchN()
 )
 INHERITS (gm.tm_oznaczoneruchy);
 ----ON COMMIT DELETE ROWS;
 
---- ALTER TABLE tm_oznaczoneruchy ALTER ozr_setid SET DEFAULT gm.topOznaczRuchN();

 IF (vendo.gettparami('OZNACZONERUCHYDELETED',0)=0) THEN
  PERFORM vendo.settparami('OZNACZONERUCHYDELETED',1);
  DELETE FROM ONLY tm_oznaczoneruchy;
 END IF;

 BEGIN
  CREATE INDEX tm_oznaczoneruchy_i1 ON tm_oznaczoneruchy(ozr_setid,rc_idruchu);
  CREATE INDEX tm_oznaczoneruchy_i2 ON tm_oznaczoneruchy(rc_idruchu);
  EXCEPTION WHEN OTHERS THEN 
  BEGIN 
   PERFORM set_config('client_min_messages',tmp,true);
   RETURN TRUE;
  END;
 END;
 
 PERFORM set_config('client_min_messages',tmp,true); 
 RETURN TRUE;
END;
$$;
