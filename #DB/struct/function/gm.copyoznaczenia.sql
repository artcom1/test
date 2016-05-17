CREATE FUNCTION copyoznaczenia(idruchusrc integer, idruchudst integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
--- Funkcja kopiuje oznaczenia na wszystkich SETID z ruchu o ID=idruchusrc 
--- tak by byly oznaczenia dla ruchu o ID=idruchudst
BEGIN
 IF (gm.isAnyOznaczonyRuchN()=FALSE) THEN
  RETURN TRUE;
 END IF;
 
 INSERT INTO tm_oznaczoneruchy
  (ozr_setid,rc_idruchu)
 SELECT n.ozr_setid,idruchudst
 FROM tm_oznaczoneruchy AS n
 LEFT OUTER JOIN tm_oznaczoneruchy AS ex ON (ex.ozr_setid=n.ozr_setid AND ex.rc_idruchu=idruchudst)
 WHERE n.rc_idruchu=idruchusrc AND ex.ozr_id IS NULL;
 
 RETURN TRUE;
END;
$$;
