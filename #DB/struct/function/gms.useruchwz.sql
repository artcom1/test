CREATE FUNCTION useruchwz(simid integer, idtowmag integer, idmiejsca integer, idpartiipz integer, idruchupz integer, idruchuwz integer, ilosc numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN

 PERFORM gms.getIDSC(simid,idruchupz);

 INSERT INTO gms.tm_touse
 VALUES
  (DEFAULT,
   DEFAULT,
   simid,
   idtowmag,
   idmiejsca,
   idpartiipz,
   idruchupz,
   idruchuwz,
   (CASE WHEN idpartiipz IS NULL THEN ilosc ELSE 0 END),
   (CASE WHEN idpartiipz IS NULL THEN 0 ELSE ilosc END)
  );  

 RETURN TRUE;
END;
$$;


SET search_path = mv, pg_catalog;
