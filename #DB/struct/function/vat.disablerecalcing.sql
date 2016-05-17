CREATE FUNCTION disablerecalcing(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 v INT;
BEGIN

  IF ($1 IS NULL) THEN
---   RAISE EXCEPTION 'ID Dokumentu is NULL (%,%)',$1,$2;
   RETURN NULL;
  END IF;
----   RAISE NOTICE '(%,%)',$1,$2;


 v=vendo.getTParamI('DRC_'||$1::text,0);
 
 IF ($2=0) THEN
  RETURN v;
 END IF;

 IF ($2>0) THEN
  v=v+$2;
  PERFORM vendo.setTParamI('DRC_'||$1,v);
  RETURN v;
 END IF;

 IF ($2<0) THEN
  v=v+$2;
  PERFORM vendo.setTParamI('DRC_'||$1,v);
  IF (vendo.getTParamI('DRCS_'||$1,0)>0) THEN
   PERFORM vat.reinitvat($1);
   PERFORM vendo.setTParamI('DRCS_'||$1,0);
   IF (vendo.getTParamI('DRCSVN_'||$1,0)<>0) THEN
    UPDATE tg_transelem SET tel_idelem=tel_idelem WHERE tr_idtrans=$1;
    PERFORM vendo.setTParamI('DRCSVN_'||$1,0);
   END IF;
   IF (vendo.getTParamI('DRCSVH_'||$1,0)<>0) THEN
    UPDATE tg_transakcje SET tr_idtrans=tr_idtrans WHERE tr_idtrans=$1;
    PERFORM vendo.setTParamI('DRCSVH_'||$1,0);
   END IF;
  END IF;

  RETURN v;
 END IF;

 RETURN v;
END;
$_$;
