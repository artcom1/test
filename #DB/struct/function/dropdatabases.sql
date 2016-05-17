CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
BEGIN


 FOR r IN SELECT datname FROM pg_database WHERE datname NOT ILIKE '%template%'
 LOOP
  RAISE NOTICE 'DROP DATABASE %s; ',r.datname;
 END LOOP;


 RETURN TRUE;
END$$;
