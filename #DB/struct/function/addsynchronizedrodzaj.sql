CREATE FUNCTION addsynchronizedrodzaj(integer, text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rodzaj ALIAS FOR $1;
 _skrot  ALIAS FOR $2;
BEGIN
 IF (_rodzaj=1) THEN
  RETURN FALSE;
 END IF;
 
 DELETE FROM tg_rodzajtransakcji WHERE tr_rodzaj=_rodzaj;
 INSERT INTO tg_rodzajtransakcji (tr_rodzaj,trt_skrot,trt_ostseria)
 SELECT DISTINCT ON (trt_ostseria) _rodzaj,_skrot,trt_ostseria FROM tg_rodzajtransakcji WHERE tr_rodzaj=1;
 
 RETURN TRUE;
END;
$_$;
