CREATE FUNCTION islistpolecony(integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$ --argumentem jest flaga zdarzenia (tb_zdarzenia.zd_flaga)
BEGIN
 IF ((($1>>5)&3) = 3) THEN
  RETURN TRUE;
 ELSE
  RETURN FALSE;
 END IF;
END;
$_$;
