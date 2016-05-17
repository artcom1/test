CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$ --argumentem jest flaga zdarzenia (tb_zdarzenia.zd_flaga)
BEGIN
 IF ((($1>>5)&3) = 1) THEN
  RETURN TRUE;
 ELSE
  RETURN FALSE;
 END IF;
END;
$_$;
