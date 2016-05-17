CREATE FUNCTION initforkkw(simid integer, kkwnod integer, idmiejsca_alltowary integer DEFAULT NULL::integer, idtowmag_alltowary integer DEFAULT NULL::integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 tmpint    INT;
 t         timestamp:=clock_timestamp();
 rrr       RECORD;
 spid      INT:=vendo.tv_mysessionpid();
 q         TEXT;
BEGIN
 
 RAISE NOTICE '1 %',(clock_timestamp()-t);
 t=clock_timestamp();

 ---Dodadza sie wszystkie ruchy gdzie cos pozostalo z pozycji WZ/FV
 IF (idtowmag_alltowary IS NULL) THEN
  PERFORM gms.initSCBlock('(SELECT DISTINCT ttm_idtowmag FROM tr_nodrec WHERE knr_wplywmag=-1 AND (kwe_idelemu='||kkwnod||' OR (kwe_idelemu IS NULL AND kwh_idheadu=(SELECT kwh_idheadu FROM tr_kkwnod WHERE kwe_idelemu='||kkwnod||'))))','a',
                          simid::text,'a.ttm_idtowmag',NULL);
 ELSE
  PERFORM gms.initSC(simid,idtowmag_alltowary,NULL);
 END IF;

 RAISE NOTICE '2 %',(clock_timestamp()-t);
 t=clock_timestamp();

 RETURN gms.initForDocs(simid,NULL,NULL,idmiejsca_alltowary,idtowmag_alltowary);
END
$$;
