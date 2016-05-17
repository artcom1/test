CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 od_okres1 ALIAS FOR $1;
 do_okres1 ALIAS FOR $2;
 od_okres2 ALIAS FOR $3;
 do_okres2 ALIAS FOR $4;
BEGIN

 IF (od_okres1>do_okres1 AND od_okres2>do_okres2) THEN  
  ----okresy przechodza z dnia do dnia 
  IF (od_okres1<=od_okres2 AND do_okres1>do_okres2) THEN
   return TRUE;
  END IF;
  return FALSE;     
 END IF;

 IF (od_okres1>do_okres1 ) THEN  
  ----okresy przechodzi przez polnoc a drugi nie
  IF (od_okres1<=od_okres2) THEN
   return TRUE;
  END IF;
  IF (do_okres1>do_okres2) THEN
   return TRUE;
  END IF;
  
  return FALSE;     
 END IF;

 IF (od_okres2>do_okres2 ) THEN  
  ----okresy drugi przechodzi przez polnoc a pierwszy nie
  return FALSE;     
 END IF;

 IF (od_okres1<=od_okres2 AND do_okres1>do_okres2) THEN
   return TRUE;
 END IF;

 return FALSE;
END;
$_$;
