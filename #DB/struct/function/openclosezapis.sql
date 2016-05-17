CREATE FUNCTION openclosezapis(integer, integer, boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _id ALIAS FOR $1;
 _idksiegujacego ALIAS FOR $2;
 _close ALIAS FOR $3;
BEGIN

 IF (_close=TRUE) THEN
  UPDATE kh_zapisyhead SET zk_flaga=zk_flaga|1,p_ksiegujacy=_idksiegujacego WHERE (zk_idzapisu=_id) AND (zk_flaga&1=0);
 ELSE
  UPDATE kh_zapisyhead SET zk_flaga=zk_flaga&(~1),p_ksiegujacy=NULL WHERE (zk_idzapisu=_id) AND (zk_flaga&1=1);
 END IF;

 RETURN _id;

END;
$_$;
