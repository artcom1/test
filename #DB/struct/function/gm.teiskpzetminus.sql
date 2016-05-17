CREATE FUNCTION teiskpzetminus(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
 BEGIN
  RETURN ($1&(1<<3))<>0;
 END;
  $_$;
