CREATE FUNCTION dorenumerujtrans(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;

BEGIN
  RETURN dorenumerujtrans(_idtrans,NULL,''::text);
END;$_$;


--
--

CREATE FUNCTION dorenumerujtrans(integer, integer, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;
 _tel_skojzestaw ALIAS FOR $2;
 _tel_lpprefix ALIAS FOR $3;
 lp INT:=1;
 rec RECORD;
BEGIN

 --Najpierw normalne dokumenty
 FOR rec IN SELECT tr_idtrans,tel_idelem,tel_lp,tel_newflaga FROM tg_transakcje JOIN tg_transelem USING (tr_idtrans) WHERE tr_zamknieta&12::int2=0 AND tg_transakcje.tr_idtrans IN (_idtrans) AND NullZero(tel_skojzestaw)=NullZero(_tel_skojzestaw) ORDER BY tr_idtrans,tel_lp FOR UPDATE
 LOOP

  UPDATE tg_transelem SET tel_flaga=tel_flaga|16384,tel_lp=lp, tel_lpprefix=_tel_lpprefix WHERE tel_idelem=rec.tel_idelem AND (tel_lp<>lp OR tel_lpprefix<>_tel_lpprefix);

  IF ((rec.tel_newflaga&(256))=(256)) THEN
   ---pozycja ma elementy powiazane, wiec sortujemy te elementy osobno
   PERFORM dorenumerujtrans(_idtrans,rec.tel_idelem,numerkonta(_tel_lpprefix,lp));
  END IF;

  lp=lp+1;
 END LOOP;

 ---Teraz korekty
 FOR rec IN SELECT tr.tr_idtrans,te.tel_idelem,tep.tel_lp,tep.tel_lpprefix,te.tel_lp AS tel_lpo FROM tg_transakcje AS tr JOIN tg_transelem AS te USING (tr_idtrans) LEFT OUTER JOIN tg_transelem AS tep ON (tep.tel_idelem=te.tel_skojarzony) WHERE tr_zamknieta&12::int2<>0 AND tr.tr_idtrans IN (_idtrans) ORDER BY tr.tr_idtrans,tep.tel_lp,te.tel_lp FOR UPDATE OF te
 LOOP
  IF (rec.tel_lp IS NULL) THEN
   UPDATE tg_transelem SET tel_lp=(SELECT nullZero(max(tel_lp))+1 FROM tg_transelem AS te WHERE te.tr_idtrans=tg_transelem.tr_idtrans AND tel_lp<rec.tel_lpo) WHERE tel_idelem=rec.tel_idelem;
  ELSE
   UPDATE tg_transelem SET tel_flaga=tel_flaga|16384,tel_lp=rec.tel_lp, tel_lpprefix=rec.tel_lpprefix WHERE tel_idelem=rec.tel_idelem AND (tel_lp<>rec.tel_lp OR tel_lpprefix=rec.tel_lpprefix);
  END IF;
 END LOOP;

 RETURN 0;
END;
$_$;
