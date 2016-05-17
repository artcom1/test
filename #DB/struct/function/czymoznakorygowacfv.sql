CREATE FUNCTION czymoznakorygowacfv(integer, boolean) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _fv ALIAS FOR $1;
 _forupdate ALIAS FOR $2;
 wynik TEXT:='';
 query TEXT;
 d RECORD;
BEGIN

 query='SELECT tr_idtrans,tr_zamknieta FROM tg_transakcje WHERE tr_idtrans='||_fv||' OR tr_skojarzona='||_fv||' AND tr_rodzaj!=6';

 IF (_forupdate) THEN
  query=query||' FOR UPDATE';
 END IF;

 FOR d IN EXECUTE query
 LOOP
  wynik=wynik||'|('||d.tr_idtrans||',';
  IF ((d.tr_zamknieta&1::int2)=1::int2) THEN
   wynik=wynik||'1';
  ELSE
   wynik=wynik||'0';
  END IF;
  wynik=wynik||')';
 END LOOP;

 RETURN wynik;
END;
$_$;
