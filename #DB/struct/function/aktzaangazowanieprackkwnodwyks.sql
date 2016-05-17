CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _knw_idelemow ALIAS FOR $1;
BEGIN
 RETURN aktZaangazowaniePracKKWNODWYKs(_knw_idelemow,0);
END
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _knw_idelemow ALIAS FOR $1;
 _iloscosob    ALIAS FOR $2;
 
 normatyw_all  NUMERIC:=0; 
 query         TEXT;
 
 recnodwyk     RECORD;
BEGIN

 query='SELECT knw_idelemu, getNormatywPrac(wyk.knw_iloscwyk+wyk.knw_iloscbrakow,wyk.knw_tpj,wyk.knw_tpz,wyk.knw_wydajnosc,wyk.knw_iloscosob) AS normatyw FROM tr_kkwnodwyk AS wyk WHERE knw_idelemu IN ('|| _knw_idelemow ||')';
 
 FOR recnodwyk IN EXECUTE query
 LOOP
  normatyw_all=normatyw_all+recnodwyk.normatyw;
 END LOOP;
 
 FOR recnodwyk IN EXECUTE query
 LOOP
  PERFORM aktZaangazowaniePracKKWNODWYK(recnodwyk.knw_idelemu,recnodwyk.normatyw,normatyw_all);
 END LOOP;
 
 RETURN TRUE;
END
$_$;
