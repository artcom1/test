CREATE FUNCTION getplatfifoflag(integer, numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idbanku ALIAS FOR $1;
 _wplyw   ALIAS FOR $2;
 flag INT;
 ret INT:=0;
BEGIN
 IF (_idbanku IS NULL) AND (_wplyw IS NULL) THEN
  RETURN 71|(1<<11);
 END IF;

 flag=(SELECT bk_flaga FROM ts_banki WHERE bk_idbanku=_idbanku);
 --- Nie uzywaj - wyjdz
 IF (flag&64=0) THEN RETURN 0; END IF;
 ---Dla przychodow - tylko zamkniete
 IF (_wplyw>0) THEN
  RETURN 2;
 END IF;
 IF (_wplyw<0) THEN
  --Tylko zamkniete - nie ma wiec mozliwosci rowniez obliczania automatycznego kursu
  IF (flag&128=0) THEN  ret=ret|2; ELSE ret=ret|1; END IF;
  IF (flag&256=256) THEN ret=ret|4|64; END IF;
  IF (flag&(1<<11)!=0) THEN ret=ret|(1<<11); END IF;
  RETURN ret;
 END IF;

 RETURN 0;
END;
$_$;
