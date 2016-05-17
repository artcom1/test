CREATE FUNCTION updatetelsprzedaz(idtrans integer, warunekupdate text, warunekwhere text, warunekorder text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
 query TEXT;
 cnt INT:=0;
BEGIN

 query='SELECT tel_idelem FROM tg_transelem WHERE tr_idtrans='||idtrans||' AND '||COALESCE(warunekwhere,'true=true')||' ORDER BY '||COALESCE(warunekorder,'tel_lp');
 FOR r IN EXECUTE query
 LOOP  
  query='UPDATE tg_transelem SET '||warunekupdate||' WHERE tel_idelem='||r.tel_idelem;    
  cnt=cnt+1;
  EXECUTE query;
 END LOOP;

 RAISE NOTICE 'Updated % elems on gm.UpdateTelSprzedaz ',cnt;
 
 RETURN TRUE;
END;
$$;
