CREATE FUNCTION correctoznaczenia(oznid bigint DEFAULT topoznaczruchn()) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
----Funkcja moze byc wykorzystana wtedy kiedy oznaczenie zrobilismy poprzez wpis wszystkich potencjalnych rekordow
----do tm_oznaczoneruchy a chcielibysmy uwzglednic informacje z poprzedniego SETID.
----Funkcja gm.correctOznaczenia wykasuje niepotrzebne wpisy na SETID=oznid.
DECLARE
 previd INT8;
BEGIN

 IF (gm.isAnyOznaczonyRuchN()=FALSE) THEN
  RETURN TRUE;
 END IF;
 
 previd=gm.prevOznaczRuchN(oznid);
 IF (previd<0) THEN
  RETURN TRUE;
 END IF;
 
 WITH r AS 
 (
  SELECT n.rc_idruchu
  FROM tm_oznaczoneruchy AS n 
  LEFT OUTER JOIN tm_oznaczoneruchy AS p ON (p.rc_idruchu=n.rc_idruchu AND p.ozr_setid=previd)
  WHERE p.rc_idruchu IS NULL AND n.ozr_setid=oznid
 ) 
 DELETE FROM tm_oznaczoneruchy AS rr
 USING r
 WHERE rr.rc_idruchu=r.rc_idruchu;

 RETURN TRUE;
END;
$$;
