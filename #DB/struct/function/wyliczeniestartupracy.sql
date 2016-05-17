CREATE FUNCTION wyliczeniestartupracy(timestamp with time zone, timestamp with time zone, numeric, integer) RETURNS timestamp with time zone
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _pracaod ALIAS FOR $1;
 _pracado ALIAS FOR $2;
 _rbh ALIAS FOR $3;
 _flaga ALIAS FOR $4;
 _elem INT;
 tmp TEXT;
BEGIN
 
 -- Niewykonane mnie nie interesuja
 IF (_flaga&2=0) THEN
  RETURN _pracaod;
 END IF;
 
 -- Tryb zapisu
 IF (_flaga&1=1) THEN
  -- Start-stop
  RETURN _pracaod;
 ELSE
  -- Musze liczyc
  tmp=' '''|| _rbh::TEXT;
  tmp=tmp||' hour ';
  tmp=tmp||' ''';

  RETURN _pracaod -  (tmp)::INTERVAL ;
 END IF;
 
END;
$_$;
