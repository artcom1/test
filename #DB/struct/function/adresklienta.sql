CREATE FUNCTION adresklienta(text, text, text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _ulica ALIAS FOR $1;
 _nrdomu ALIAS FOR $2;
 _nrlokalu ALIAS FOR $3;
BEGIN

 IF (COALESCE(_nrdomu,'')='' AND COALESCE(_nrlokalu,'')='') THEN 
  RETURN COALESCE(_ulica,'');
 END IF;

 IF (COALESCE(_nrdomu,'')='') THEN 
  RETURN COALESCE(_ulica,'')||' '||COALESCE(_nrlokalu,'');
 END IF;

 IF (COALESCE(_nrlokalu,'')='') THEN 
  RETURN COALESCE(_ulica,'')||' '||COALESCE(_nrdomu,'');
 END IF;

 RETURN COALESCE(_ulica,'')||' '||COALESCE(_nrdomu,'')||'/'||COALESCE(_nrlokalu,'');
END
$_$;
