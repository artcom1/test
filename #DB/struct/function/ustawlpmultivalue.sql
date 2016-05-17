CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _mv_idvalue ALIAS FOR $1;
 _new_lp INT:=$2;
 mv1 RECORD;
 max_lp INT;
BEGIN
  SELECT mv_idvalue, mv_lp, mv_type, mv_podrodzaj INTO mv1 FROM ts_multivalues WHERE mv_idvalue=_mv_idvalue;

  max_lp := (SELECT mv_lp FROM ts_multivalues WHERE mv_type=mv1.mv_type AND NullZero(mv_podrodzaj)=NullZero(mv1.mv_podrodzaj) ORDER BY mv_lp DESC LIMIT 1);

  IF (_new_lp <= 0) THEN
    _new_lp := 1;
  END IF;
  
  IF (_new_lp > max_lp) THEN
    _new_lp := max_lp;
  END IF;

  IF (_new_lp < mv1.mv_lp) THEN
    UPDATE ts_multivalues SET mv_lp=mv_lp+1 WHERE mv_type=mv1.mv_type AND NullZero(mv_podrodzaj)=NullZero(mv1.mv_podrodzaj) AND mv_lp>=_new_lp AND mv_lp<mv1.mv_lp;
  ELSE
    UPDATE ts_multivalues SET mv_lp=mv_lp-1 WHERE mv_type=mv1.mv_type AND NullZero(mv_podrodzaj)=NullZero(mv1.mv_podrodzaj) AND mv_lp<=_new_lp AND mv_lp>mv1.mv_lp;
  END IF;
  UPDATE ts_multivalues SET mv_lp=_new_lp WHERE mv_idvalue=mv1.mv_idvalue;

  RETURN mv1.mv_idvalue;
END;
$_$;
