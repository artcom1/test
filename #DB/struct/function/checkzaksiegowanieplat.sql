CREATE FUNCTION checkzaksiegowanieplat(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idplat INT;
BEGIN

 _idplat=(SELECT pl_idplatnosc FROM kh_platnosci WHERE pl_idplatnosc=$1 AND (pl_flaga&(1<<16)<>0));
  IF (_idplat IS NOT NULL) THEN
   RAISE EXCEPTION '27|%|Platnosc jest juz zaksiegowana',_idplat;
  END IF;

  RETURN TRUE;
 END;
$_$;
