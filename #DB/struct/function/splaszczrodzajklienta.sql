CREATE FUNCTION splaszczrodzajklienta(integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 r RECORD;
BEGIN
 IF ($1 IS NULL) THEN RETURN ''; END IF;
 SELECT rk_parent, rk_typrodzaju INTO r FROM ts_rodzajklienta  WHERE rk_idrodzajklienta=$1;
 IF (r.rk_parent IS NULL) THEN
  return r.rk_typrodzaju;
 ELSE 
  RETURN splaszczRodzajKlienta(r.rk_parent)||'??'||r.rk_typrodzaju;
 END IF;
END;
$_$;
