CREATE FUNCTION sum_date(double precision, date, date, date) RETURNS double precision
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _value ALIAS FOR $1;
 _data ALIAS FOR $2;
 _start ALIAS FOR $3;
 _end ALIAS FOR $4;
BEGIN

 IF ((_data<_start) OR (_data>_end)) THEN RETURN 0; END IF;

 RETURN _value;
END;
$_$;


--
--

CREATE FUNCTION sum_date(numeric, date, date, date) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _value ALIAS FOR $1;
 _data ALIAS FOR $2;
 _start ALIAS FOR $3;
 _end ALIAS FOR $4;
BEGIN

 IF ((_data<_start) OR (_data>_end)) THEN RETURN 0; END IF;

 RETURN _value;
END;
$_$;
