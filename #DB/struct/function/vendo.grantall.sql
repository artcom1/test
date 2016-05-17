CREATE FUNCTION grantall(text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$

DECLARE

 r RECORD;

BEGIN

 FOR r IN select distinct on (t.relname) t.relname,t.relkind,ns.nspname 
          from pg_class AS t 
          JOIN pg_namespace AS ns ON (ns.oid=t.relnamespace) 
          where t.relkind IN ('r','S','v') and 
                t.relname not ilike 'pg_%' and 
                t.relname not ilike 'sql_%' AND 
                (SELECT count(*) FROM pg_class as s where s.relname=t.relname)=1 AND
                ns.nspname<>'information_schema'

 LOOP

  RAISE NOTICE 'Tabela %.%',r.nspname,r.relname;

  EXECUTE 'GRANT ALL ON '||r.nspname||'.'||r.relname||' TO '||$1;

 END LOOP;

 RETURN TRUE;

END;

$_$;
