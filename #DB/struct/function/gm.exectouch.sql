CREATE FUNCTION exectouch() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
 o OID;
BEGIN

 IF (gm.disableTouch(0)<>0) THEN
   RAISE NOTICE 'Pomijam touch';
  RETURN FALSE;
 END IF;

 LOOP
  o=0;

  FOR r IN SELECT tel_idelem,max(oid) AS o FROM gm.tg_tetotouch GROUP BY tel_idelem ORDER BY min(oid)
  LOOP
   IF (r.o>o) THEN o=r.o; END IF;
   IF (r.tel_idelem IS NOT NULL) THEN
    RAISE NOTICE 'Wywoluje touch dla %',r.tel_idelem;
    UPDATE tg_transelem SET tel_idelem=tel_idelem WHERE tel_idelem=r.tel_idelem;
   END IF;
  END LOOP;
  
  EXIT WHEN o=0;

  DELETE FROM gm.tg_tetotouch WHERE oid<=o;

 END LOOP;

 RETURN TRUE;
END;
$$;
