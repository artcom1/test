CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _typtabeli ALIAS FOR $1;
 _id ALIAS FOR $2;
 nazwaZmiennej ALIAS FOR $3;
BEGIN 
 RETURN vendo.addonbeforecommitorder(1<<2,_typtabeli::text||'|'||_id::text||'|'||nazwaZmiennej);
END; $_$;
