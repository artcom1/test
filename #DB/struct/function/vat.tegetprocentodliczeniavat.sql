CREATE FUNCTION tegetprocentodliczeniavat(procodlvat numeric, tel_newflaga integer, tel_new2flaga integer) RETURNS numeric
    LANGUAGE sql IMMUTABLE
    AS $_$
 SELECT (CASE WHEN (($2>>14)&3)=0 THEN 0                                       --- Nie odliczamy VAT
              WHEN vat.TEhasProcentOdliczeniaVAT($2,$3)=FALSE THEN 100         --- Nie korzystamy z procenta
			  ELSE $1 
		 END);
$_$;
