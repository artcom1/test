CREATE FUNCTION logtmptables() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN

 CREATE TABLE IF NOT EXISTS vendo.pg_class_log
 (
  reloid OID,
  relname TEXT,
  adddate TIMESTAMP DEFAULT now()
 );
 
 INSERT INTO vendo.pg_class_log
  (reloid,relname)
 SELECT c.oid,c.relname FROM pg_class AS c 
 LEFT OUTER JOIN vendo.pg_class_log AS l ON (l.reloid=c.oid)
 WHERE l.reloid IS NULL;
 

 RETURN TRUE;
END;
$$;
