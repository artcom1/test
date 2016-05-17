CREATE FUNCTION flipkalkulacje(integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _id1 ALIAS FOR $1;
 _id2 ALIAS FOR $2;
 tmp INT;
BEGIN
 
 IF (_id2 IS NULL) THEN RETURN NULL; END IF;

 SELECT kk_lp INTO tmp FROM tg_kalkulacje WHERE kk_idkalk=_id1 FOR UPDATE;

 UPDATE tg_kalkulacje SET kk_lp=(SELECT kk_lp FROM tg_kalkulacje WHERE kk_idkalk=_id2) WHERE kk_idkalk=_id1;
 UPDATE tg_kalkulacje SET kk_lp=tmp WHERE kk_idkalk=_id2;

 RETURN _id2;
END;
$_$;
