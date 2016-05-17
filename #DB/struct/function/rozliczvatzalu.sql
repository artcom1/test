CREATE FUNCTION rozliczvatzalu(integer, integer, numeric, boolean, boolean, integer DEFAULT NULL::integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF ($5=TRUE) THEN
  RETURN rozliczVatZalP($1,$2,$3,$4,$6);
 END IF;
 
 RETURN rozliczVatZal($1,$2,$3,$4,$6);
END;
$_$;
