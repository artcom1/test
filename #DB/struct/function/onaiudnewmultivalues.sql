CREATE FUNCTION onaiudnewmultivalues() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
 tableInfo RECORD;
 keyValue INT;
BEGIN
 
 SELECT * INTO tableInfo FROM vendo.tm_tableinfo WHERE tid_datatype=TG_ARGV[0]::int;

 IF (tableInfo.tim_hasrecchanges=TRUE) OR (tableInfo.tim_hasautonotifies=TRUE) THEN
  IF (TG_OP='INSERT') THEN
   EXECUTE 'SELECT (($1)::text::'||TG_TABLE_SCHEMA||'.'||TG_TABLE_NAME||').'||TG_ARGV[1] INTO keyValue USING NEW;
  ELSE
   EXECUTE 'SELECT (($1)::text::'||TG_TABLE_SCHEMA||'.'||TG_TABLE_NAME||').'||TG_ARGV[1] INTO keyValue USING OLD;
  END IF;

---  RAISE NOTICE 'Wysylam % % ',TG_ARGV[0]::int,keyValue;
  PERFORM updaterecchange(TG_ARGV[0]::int,keyValue);
 END IF;

 IF (tableInfo.tim_hasautonotifies=TRUE) THEN
  IF (TG_OP='UPDATE') THEN
   IF (NEW<>OLD) THEN
    PERFORM vendo.sendRecordChanged(tableInfo.tid_datatype,keyValue::text);
   END IF;
  ELSE
   PERFORM vendo.sendRecordChanged(tableInfo.tid_datatype,keyValue::text);
  END IF;
 END IF;

 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 END IF;

 RETURN NEW;
END;
$_$;
