CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 od_okres1 ALIAS FOR $1;
 do_okres1 ALIAS FOR $2;
 od_okres2 ALIAS FOR $3;
 do_okres2 ALIAS FOR $4;
BEGIN

 IF (od_okres1>do_okres1 AND od_okres2>do_okres2) THEN  ----okresy przechodza z dnia do dnia wiec musza zachodzic
  return true;     
 END IF;

 IF (od_okres1>do_okres1) THEN  ---pierwszy okres zachodzi
  IF (do_okres1>od_okres2) THEN
   return true;
  END IF;
  IF (od_okres1<do_okres2) THEN
   return true;
  END IF;
 END IF;

 IF (od_okres2>do_okres2) THEN  ---drugi okres zachodzi
  IF (do_okres2>od_okres1) THEN
   return true;
  END IF;
  IF (od_okres2<do_okres1) THEN
   return true;
  END IF;
 END IF;
 
 ---nic nie zachodzi normalne porownanie
  IF (od_okres1<do_okres2 AND od_okres2<do_okres1) THEN
   return true;
  END IF;

 RETURN false;
END;
$_$;
