CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 pack RECORD;
 lp INT;
 pk_idpaczki INT;
BEGIN
  pk_idpaczki=-2;
  lp=1;
  FOR pack IN EXECUTE $1 
  LOOP
    IF (pack.pk_idpaczki!=pk_idpaczki) THEN
     pk_idpaczki=pack.pk_idpaczki::INT;
     lp=1;
    END IF;
    
    UPDATE tg_packelem SET pe_lp=lp WHERE pe_idelemu=pack.pe_idelemu;
    lp=lp+1;
  END LOOP;

  RETURN 1;
END;
$_$;
