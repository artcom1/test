CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN mv.convertSimpleMultiVal($1,$2,$3,$4,$5,$6,$7,'int',$8,$9);
END; $_$;
