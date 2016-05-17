CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _id ALIAS FOR $1;
 _numer TEXT;--ALIAS FOR $2;
 _rodzaj TEXT;--ALIAS FOR $3;
 _prefix ALIAS FOR $4;
 _skrot TEXT;
 ret TEXT;
BEGIN
_numer = $2::text;
_rodzaj = $3::text;

 IF ((_numer<>'') OR ((_prefix IS NOT NULL) AND (_prefix<>''))) THEN
  IF ((_prefix IS NOT NULL) AND (_prefix<>'')) THEN
   ret=_numer||'/'||_prefix::text;
  ELSE 
   ret=_numer;
  END IF;
 ELSE
  IF (_rodzaj<>'') THEN
   _skrot = (SELECT zdi_code FROM tb_zdarzeniainfo WHERE zdi_id=_id);
   ret=_id||'/'||_skrot::text;
  END IF;
 END IF;

 RETURN ret;
END;
$_$;
