CREATE FUNCTION dajlistekorekt(integer, boolean) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _dok ALIAS FOR $1;
 _forupdate ALIAS FOR $2;
  wynik TEXT:='';
 query TEXT;
 d RECORD;
 prev INT:=0;
BEGIN

 query='WITH a AS (
         select c.tr_idtrans,c.tr_zamknieta
         from tg_transelem AS te 
	 	 JOIN tg_transelem AS tec ON (tec.tel_skojarzony=te.tel_idelem AND tec.ttw_idtowaru=te.ttw_idtowaru) 
	 	 JOIN tg_transakcje AS c ON (c.tr_idtrans=tec.tr_idtrans) 
		 WHERE te.tr_idtrans='||_dok;

 IF (_forupdate) THEN
  query=query||' FOR UPDATE OF c';
 END IF;
		 
 query=query||'), b AS (
 		 select c.tr_idtrans,c.tr_zamknieta
 		 FROM tg_transakcje AS c
		 WHERE c.tr_skojarzona='||_dok;

 IF (_forupdate) THEN
  query=query||' FOR UPDATE OF c';
 END IF;
		 
query=query||')
        select c.tr_idtrans,c.tr_zamknieta FROM (
         SELECT * FROM a
		UNION
		 SELECT * FROM b
		) AS c
		ORDER BY c.tr_idtrans';


 FOR d IN EXECUTE query
 LOOP
  IF (d.tr_idtrans<>prev) THEN
   wynik=wynik||'|('||d.tr_idtrans||',';
   IF ((d.tr_zamknieta&1::int2)=1::int2) THEN
    wynik=wynik||'1';
   ELSE
    wynik=wynik||'0';
   END IF;
   wynik=wynik||')';
   prev=d.tr_idtrans;
  END IF;
 END LOOP;

 RETURN wynik;
END;
$_$;
