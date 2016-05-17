CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
 return sortKonta($1,$2,'-');
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _in ALIAS FOR $1;
 _ile ALIAS FOR $2;
 _sep ALIAS FOR $3;
 t TEXT;
 tmp TEXT;
 ret TEXT:='';
BEGIN
  
 t=_in;

 IF (t IS NULL) THEN RETURN NULL; END IF;

 LOOP
  tmp=substr(t,1,strpos(t,_sep));
  IF (tmp='') THEN
   ret=ret||mylpad(t,_ile,'0');
   t='';
  ELSE
   ret=ret||mylpad(tmp,_ile+1,'0');
   t=substr(t,length(tmp)+1);
  END IF;
  EXIT WHEN length(t)=0;
 END LOOP;
 
 RETURN ret;
END;
$_$;
