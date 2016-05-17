CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
BEGIN

 INSERT INTO gms.tm_touse
 VALUES
  (DEFAULT,
   DEFAULT,
   simid,
   idtowmag,
   idmiejsca,
   idpartiipz,
   idruchupz,
   NULL,
   0,
   0,
   idruchurez,
   (CASE WHEN idpartiipz IS NULL THEN ilosc ELSE 0 END),
   (CASE WHEN idpartiipz IS NULL THEN 0 ELSE ilosc END)
  );  

 RETURN TRUE;
END;
$$;
