CREATE FUNCTION idfvdlaza(integer, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 tr_idtrans ALIAS FOR $1;
 tr_skojlog ALIAS FOR $2;
 tr_rodzaj ALIAS FOR $3;

BEGIN
  IF (tr_rodzaj=103) THEN
    RETURN tr_skojlog;
  END IF;
 
  RETURN tr_idtrans;
END;
$_$;
