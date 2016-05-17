CREATE FUNCTION getncena(integer, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowaru ALIAS FOR $1;
 _idgrupy ALIAS FOR $2;
 r RECORD;
BEGIN

 IF (_idgrupy IS NOT NULL) THEN
  SELECT * INTO r FROM tg_ceny WHERE ttw_idtowaru=_idtowaru AND tgc_idgrupy=_idgrupy;
 ELSE
  SELECT * INTO r FROM tg_ceny WHERE ttw_idtowaru=_idtowaru AND tcn_isdefault;
 END IF;

 RETURN r.tcn_value||':'||r.tcn_valuebrt||':'||r.tcn_idwaluty||':'||r.tgc_idgrupy;
END;
$_$;
