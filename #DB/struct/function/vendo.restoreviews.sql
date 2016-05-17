CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
BEGIN
 
 FOR r IN SELECT * FROM vendo.tmp_viewspushed ORDER BY id DESC
 LOOP
  RAISE NOTICE 'Restore view: %',r.name;
  EXECUTE 'CREATE VIEW '||r.name||' AS '||r.def;
  DELETE FROM vendo.tmp_viewspushed WHERE id=r.id;
 END LOOP;
 RETURN TRUE;
END;
$$;
