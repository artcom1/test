CREATE FUNCTION convertrefmultival(integer, integer, text, text, text, text, text, boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN mv.convertSimpleMultiVal($1,$2,$3,$4,$5,$6,$7,'int',$8,''); ---''
END; $_$;
