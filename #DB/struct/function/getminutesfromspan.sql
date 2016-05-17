CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
BEGIN
 RETURN extract(minutes FROM $1)+extract(hours FROM $1)*60+extract(days FROM $1)*60*24; 
END
$_$;
