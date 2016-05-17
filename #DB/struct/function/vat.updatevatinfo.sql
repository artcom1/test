CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _t ALIAS FOR $1;
 _x vat.tb_vat;
 id INT;
 q TEXT;
BEGIN
 IF (_t.tr_idtrans IS NULL) THEN
  RETURN NULL;
 END IF;

 SELECT * INTO _x FROM vat.tb_vat AS v WHERE tr_idtrans=_t.tr_idtrans AND v==_t LIMIT 1;

 IF (_x.tr_idtrans IS NOT NULL) THEN
  DELETE FROM vat.tb_vat WHERE v_id=_x.v_id;
  _t=_x+_t;
 END IF;

 IF (vat.isZero(_t)=TRUE) THEN
  RETURN _x.v_id;
 END IF;

 /*
 q='UPDATE vat.tb_vat AS v SET ('||vendo.fieldNames(_t)||')=vat.addInfo(('||vendo.fieldNames(_t)||'),'||vendo.record2string(_t)||'::vat.tg_vat) WHERE tr_idtrans='||_t.tr_idtrans||' AND v=='||vendo.record2string(_t)||' RETURNING v_id';
 EXECUTE q INTO id;

 IF (id IS NOT NULL) THEN
  RETURN id;
 END IF;
*/

 ----------------------------------------------------------
 IF (_t.v_id IS NULL) THEN
  _t.v_id=nextval('vat.tb_vat_s');
 END IF;

 INSERT INTO vat.tb_vat VALUES (_t.*);

 RETURN _t.v_id;
END;
$_$;


SET search_path = vendo, pg_catalog;
