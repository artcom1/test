CREATE FUNCTION getidpoprzedniejkorekty(integer, boolean DEFAULT true) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;
 _withorg ALIAS FOR $2;
 ret INT;
BEGIN
 ret=(SELECT tr_idtrans 
      FROM tg_transakcje 
      WHERE tr_skojarzona=(SELECT tr_skojarzona FROM tg_transakcje WHERE tr_idtrans=_idtrans) AND
            tr_idtrans<_idtrans AND
	    tr_rodzaj=(SELECT tr_rodzaj FROM tg_transakcje WHERE tr_idtrans=_idtrans) AND
	    tr_skojarzona>0
      ORDER BY tr_idtrans DESC
      LIMIT 1
     );

 IF (ret IS NOT NULL) OR (_withorg=FALSE) THEN
  RETURN ret;
 END IF;

 ret=(SELECT tr_skojarzona FROM tg_transakcje WHERE tr_idtrans=_idtrans);
 IF (ret=0) THEN ret=NULL; END IF;

 RETURN ret;
END;
$_$;
