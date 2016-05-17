CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
----argumenty data wplywu, idbanku, wl_idwaluty, formaplatnosci
DECLARE 
  b_otwarcia NUMERIC;
  platnosc RECORD;
BEGIN
 b_otwarcia=0;
 FOR platnosc IN SELECT pl_wartosc FROM kh_platnosci WHERE pl_datawplywu=date($1) AND bk_idbanku=$2 AND wl_idwaluty=$3 AND pl_formaplat=$4 AND PLisbilans(pl_flaga)
 LOOP
   b_otwarcia=platnosc.pl_wartosc;
 END LOOP;
 RETURN b_otwarcia;
END;$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
----argumenty data wplywu, idbanku, wl_idwaluty, formaplatnosci
DECLARE 
  b_otwarcia NUMERIC;
  platnosc RECORD;
BEGIN
 b_otwarcia=0;
 FOR platnosc IN SELECT pl_wartosc FROM kh_platnosci WHERE pl_datawplywu=date($1::timestamp-'1 day'::interval) AND bk_idbanku=$2 AND wl_idwaluty=$3 AND pl_formaplat=$4 AND PLisbilans(pl_flaga)
 LOOP
   b_otwarcia=platnosc.pl_wartosc;
 END LOOP;
 RETURN b_otwarcia;
END;$_$;
