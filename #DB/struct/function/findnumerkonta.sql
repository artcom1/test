CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idkonta ALIAS FOR $1;
 _roknowy ALIAS FOR $2;
 ret INT;
BEGIN

 ret=(SELECT kt_idkonta FROM kh_konta AS n WHERE n.ro_idroku=_roknowy AND numerKonta(n.kt_prefix,n.kt_numer)=(SELECT numerKonta(o.kt_prefix,o.kt_numer) FROM kh_konta AS o WHERE o.kt_idkonta=_idkonta));

 IF (ret IS NULL) THEN
  RETURN _idkonta;
 END IF;

 RETURN ret;
END;
$_$;
