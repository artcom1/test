CREATE FUNCTION reinitvat(integer, boolean DEFAULT true) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 r RECORD;
 q TEXT;
 i vat.tb_vat;
BEGIN
 ---RAISE NOTICE 'Reinit dla IDTRANS=%',$1;
 DELETE FROM vat.tb_vat WHERE tr_idtrans=$1;

 FOR r IN SELECT sum(a.v) AS i FROM (SELECT vat.createInfo(te,FALSE,FALSE) AS v FROM tg_transelem AS te where tr_idtrans=$1) AS a
          WHERE (a.v).tr_idtrans IS NOT NULL
          GROUP BY a.v::vat.tb_vat_b
 LOOP
  i=r.i;
  i.v_id=nextval('vat.tb_vat_s');
  INSERT INTO vat.tb_vat VALUES (i.*);
 END LOOP;
 FOR r IN SELECT sum(a.v) AS i FROM (SELECT vat.createInfo(te,TRUE,FALSE) AS v FROM tg_transelem AS te where tr_idtrans=$1) AS a
          WHERE (a.v).tr_idtrans IS NOT NULL
          GROUP BY a.v::vat.tb_vat_b
 LOOP
  i=r.i;
  i.v_id=nextval('vat.tb_vat_s');
  INSERT INTO vat.tb_vat VALUES (i.*);
 END LOOP;
 FOR r IN SELECT sum(a.v) AS i FROM (SELECT vat.createInfo(te,TRUE,TRUE) AS v FROM tg_transelem AS te where tr_idtrans=$1) AS a
          WHERE (a.v).tr_idtrans IS NOT NULL
          GROUP BY a.v::vat.tb_vat_b
 LOOP
  i=r.i;
  i.v_id=nextval('vat.tb_vat_s');
  INSERT INTO vat.tb_vat VALUES (i.*);
 END LOOP;

 IF ($2=TRUE) THEN
  PERFORM gm.recalcDocVat($1);
 END IF;

 RETURN TRUE;
END
$_$;
