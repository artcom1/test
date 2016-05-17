CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 ret INT;
BEGIN

 UPDATE gm.tm_flagcounter AS c SET
  flc_counter=flc_counter+delta
 WHERE (c==b) RETURNING c.flc_counter INTO ret;
 
 IF (ret IS NOT NULL) THEN
  RETURN ret;
 END IF;

 ret=(SELECT mrpp_idpalety FROM tr_mrppalety WHERE mrpp_idpalety=b.mrpp_idpalety_to);
 IF (ret IS NULL) THEN
  RETURN NULL;
 END IF;
 
 INSERT INTO gm.tm_flagcounter
  (mrpp_idpalety_to,
   flc_type,
   flc_counter
  ) VALUES
  (
   b.mrpp_idpalety_to,
   b.flc_type,
   COALESCE(delta,0)
  ) RETURNING flc_counter INTO ret;
    
 RETURN ret;
END;
$$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE sql
    AS $$
 SELECT gm.flc_updatecounter(b,delta::int);
$$;
