CREATE FUNCTION zmienlpmultivalue(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _mv_idvalue ALIAS FOR $1;
 typ ALIAS FOR $2;
 mv1 RECORD;
 mv2 RECORD;
BEGIN
  SELECT mv_idvalue, mv_lp, mv_type, mv_podrodzaj INTO mv1 FROM ts_multivalues WHERE mv_idvalue=_mv_idvalue;

  IF (typ) THEN
   SELECT mv_idvalue, mv_lp INTO mv2 FROM ts_multivalues WHERE mv_type=mv1.mv_type AND COALESCE(mv_podrodzaj,-177)=COALESCE(mv1.mv_podrodzaj,-177) AND mv_lp<mv1.mv_lp AND mv_lp>0 ORDER BY mv_lp DESC LIMIT 1 OFFSET 0;
  ELSE
   SELECT mv_idvalue, mv_lp INTO mv2 FROM ts_multivalues WHERE mv_type=mv1.mv_type AND COALESCE(mv_podrodzaj,-177)=COALESCE(mv1.mv_podrodzaj,-177) AND mv_lp>mv1.mv_lp AND mv_lp>0 ORDER BY mv_lp ASC LIMIT 1 OFFSET 0;
  END IF;

  RAISE NOTICE 'Zmieniam na % % (% %)',mv2.mv_lp,mv1.mv_lp,mv2.mv_idvalue,mv1.mv_idvalue;
  IF (mv2.mv_idvalue>0) THEN
   UPDATE ts_multivalues SET mv_lp=mv2.mv_lp WHERE mv_idvalue=mv1.mv_idvalue;
   UPDATE ts_multivalues SET mv_lp=mv1.mv_lp WHERE mv_idvalue=mv2.mv_idvalue;

   return mv2.mv_idvalue;
  END IF;
  RETURN 0;
END;
$_$;
