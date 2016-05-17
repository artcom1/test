CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 ttw_usluga ALIAS FOR $1;
 ttw_flaga ALIAS FOR $2;
 wynik int;
BEGIN
 wynik=-1;

 IF (ttw_usluga=FALSE AND ttw_flaga&(20+262144+524288)=0) THEN
   wynik=0;
 END IF;

 IF (ttw_usluga=TRUE AND ttw_flaga&(20+262144+524288)=0) THEN
   wynik=1;
 END IF;

 IF (ttw_usluga=TRUE AND ttw_flaga&(20+262144+524288)=4) THEN
   wynik=2;
 END IF;


 IF (ttw_usluga=FALSE AND ttw_flaga&(20+262144+524288)=16) THEN
   wynik=3;
 END IF;

 IF (ttw_usluga=TRUE AND ttw_flaga&(20+262144+524288)=262144) THEN
   wynik=4;
 END IF;

 IF (ttw_usluga=TRUE AND ttw_flaga&(20+262144+524288)=524288) THEN
   wynik=5;
 END IF;
 
 RETURN wynik;
END;
$_$;
