CREATE FUNCTION array_multi(numeric[], numeric[]) RETURNS numeric[]
    LANGUAGE plpgsql
    AS $_$
DECLARE
  licz      ALIAS FOR $1;
  mian      ALIAS FOR $2;
BEGIN 
  -- 1 plus
  -- 2 multi
  -- 3 minus
  -- 4 div
 RETURN array_dzialanie(licz,mian,2);
END
$_$;
