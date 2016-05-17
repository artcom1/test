CREATE FUNCTION przeliczenie_lp_rozmrodzajeelems(integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _rmr_idrodzaju ALIAS FOR $1;
 lp INT:=1;
 _rec RECORD;
BEGIN

 FOR _rec IN SELECT rme_idelemu FROM tg_rozmrodzajeelems WHERE rmr_idrodzaju=_rmr_idrodzaju ORDER BY rme_idelemu ASC
 LOOP
  UPDATE tg_rozmrodzajeelems SET rme_lp=lp WHERE rme_idelemu=_rec.rme_idelemu;
  lp=lp+1;
 END LOOP;

 RETURN lp;
END;
$_$;
