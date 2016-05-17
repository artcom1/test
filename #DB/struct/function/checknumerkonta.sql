CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
 BEGIN
 
  IF (numer IS NULL) THEN
   RAISE EXCEPTION 'Numer konta nie mo??e by?? NULL!';
  END IF;
 
  IF ((zerosto&(1<<9))!=0) THEN
   --Konto alfanumeryczne
   numer=trim(numer);
   numer=replace(numer,'-','_');
   numer=upper(numer);
   IF (length(numer)>8) OR (length(numer)<=0) THEN
    RAISE EXCEPTION 'Numer konta powinien miec minimum 1 a maksimum 8 znakow (jest: ''%'')',numer;
   END IF;
   IF (strpos(numer,'$')>0) THEN
    RAISE EXCEPTION 'Numer konta nie moze zawierac znaku ''$'' (jest: ''%'')',numer;
   END IF;
   IF (strpos(numer,'{')>0) THEN
    RAISE EXCEPTION 'Numer konta nie moze zawierac znaku ''{'' (jest: ''%'')',numer;
   END IF;
   IF (strpos(numer,'}')>0) THEN
    RAISE EXCEPTION 'Numer konta nie moze zawierac znaku ''}'' (jest: ''%'')',numer;
   END IF;
   IF (substr(numer,1,1)='0') THEN
    RAISE EXCEPTION 'Numer konta nie moze rozpoczynac sie od znaku ''0'' (jest: ''%'')',numer;
   END IF;
   RETURN numer;
  END IF;
  
  BEGIN 
   RETURN (numer::int)::text;
   EXCEPTION WHEN invalid_text_representation THEN RAISE EXCEPTION 'Konto ''%'' powinno byc numeryczne',numer;
  END;
   
 END;
 $_$;
