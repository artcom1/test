CREATE FUNCTION renumerujplanzlecenia(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _zl_idzlecenia ALIAS FOR $1;
 plan RECORD;
 plan_iter INT;
BEGIN
  plan_iter=1;
  FOR plan IN SELECT pz_idplanu AS pz_idplanu FROM tg_planzlecenia WHERE pz_flaga&(2048+16384)=0 AND zl_idzlecenia=_zl_idzlecenia ORDER BY pz_data ASC, pz_ilosc ASC
  LOOP
    UPDATE tg_planzlecenia SET pz_lp=plan_iter WHERE pz_idplanu=plan.pz_idplanu;
    plan_iter=plan_iter+1;
  END LOOP;

 RETURN _zl_idzlecenia;
END;$_$;
