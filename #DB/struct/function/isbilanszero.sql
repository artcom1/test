CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;
 _v NUMERIC;
BEGIN

 _v=(
     SELECT sum(tr_dozaplaty) FROM tg_transakcje WHERE
      (tr_idtrans=_idtrans OR tr_skojarzona=_idtrans) AND
      (tr_flaga&(1<<16)<>0)
    );

 IF (_v=0) THEN
  RETURN 1;
 ELSE
  RETURN 0;
 END IF;

END;
$_$;
