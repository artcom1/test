CREATE FUNCTION tv_mysessionpid() RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
 ret INT;
BEGIN
 

 ret=vendo.gettparami('TV_MYSESSIONPID',NULL);
 IF (ret IS NOT NULL) THEN
  RETURN ret;
 END IF;
  

 ret=(SELECT id FROM vendo.tv_mysession);

 -----RAISE NOTICE 'Czytam vendo.tv_mysession z widoku (%)',ret;

 IF (ret IS NOT NULL) THEN 
  PERFORM vendo.settparami('TV_MYSESSIONPID',ret);
 END IF;

 RETURN ret;
END;
$$;


SET search_path = gm, pg_catalog;
