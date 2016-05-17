CREATE FUNCTION rebuildindexes() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
BEGIN
 FOR r IN select distinct on (t.relname) t.relname,t.relkind,ns.nspname
          from pg_class AS i 
	  join pg_index as idx on (idx.indexrelid=i.oid) 
	  join pg_class AS t ON (idx.indrelid=t.oid) 
	  join pg_namespace AS ns ON (i.relnamespace=ns.oid AND ns.nspacl IS NOT NULL)
	  where i.relkind='i' and t.relkind='r' and t.relname not ilike 'pg_%'
 LOOP
  RAISE NOTICE 'Tabela %.%',r.nspname,r.relname;
  EXECUTE 'REINDEX TABLE '||r.nspname||'.'||r.relname;
 END LOOP;
 RETURN TRUE;
END;
$$;
