CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _type ALIAS FOR $1;
 _id ALIAS FOR $2;
BEGIN
 
 IF (_id IS NULL) THEN
  RETURN NULL;
 END IF;

 INSERT INTO vendo.tm_vorders
  (ord_order,ord_type)
 VALUES
  (_type::text||'|'||_id,1<<0);

 RETURN currval('vendo.tm_vorders_s');
END;
$_$;
