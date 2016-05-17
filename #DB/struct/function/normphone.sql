CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql STRICT
    AS $$
DECLARE
 ret TEXT:=phone;
 l   INT;
BEGIN
 l=strpos(ret,'w');
 if (l>0) THEN
  ret=substr(ret,1,l-1);
 END IF;
 ------------------------------------------------------------
 ret=onlynumbers(ret);
 l=length(ret);
 ---Jesli numer zaczyna sie od 00 zamien go na plus
 IF (substr(ret,1,2)='00') THEN
  ret='+'||substr(ret,3);
  l=l-2+1;
 END IF;
 ---Numer nigdy nie moze miec wiecej niz 9+3 znakow (+48122000000)
 IF (l>9+3) THEN
  RETURN NULL;
 END IF;
 ---Jesli numer zaczyna sie od 0 zamien go na +48
 IF (substr(ret,1,1)='0') THEN
  ret='+48'||substr(ret,2);
  l=l-1+3;
 END IF;
 IF (l=9) THEN
  ret='+48'||ret;
  l=l+3;
 END IF;
 IF (l!=9+3) THEN
  RETURN NULL;
 END IF;
 IF (substr(ret,1,1)!='+') THEN
  RETURN NULL;
 END IF;

 return ret;
END;
$$;
