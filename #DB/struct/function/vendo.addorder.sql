CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 
 INSERT INTO vendo.tm_vorders
  (ord_order)
 VALUES
  ($1);

 RETURN currval('vendo.tm_vorders_s');
END;
$_$;
