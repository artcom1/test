CREATE FUNCTION updatemvpodrodzaj(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _mvs_id ALIAS FOR $1;
  _mvp_podrodzaj ALIAS FOR $2;
  id INT;
BEGIN
 
 id=(SELECT mvp_id FROM mv.ts_mvpodrodzaj WHERE mvs_id=_mvs_id AND mvp_notpodrodzaj=_mvp_podrodzaj);
 IF (id IS NOT NULL) THEN
  UPDATE mv.ts_mvpodrodzaj SET mvp_moddate=now() WHERE mvp_id=id;
  RETURN id;
 END IF;

 INSERT INTO mv.ts_mvpodrodzaj
  (mvs_id,mvp_notpodrodzaj)
 VALUES
  (_mvs_id,_mvp_podrodzaj);


 RETURN currval('mv.mvmultivalues_s');
END; 
$_$;


SET search_path = mvv, pg_catalog;
