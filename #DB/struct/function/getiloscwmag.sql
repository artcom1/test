CREATE FUNCTION getiloscwmag(integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _pz_idplanu ALIAS FOR $1;
 ret NUMERIC:=0;
BEGIN

 IF (_pz_idplanu IS NULL) THEN RETURN 0; END IF;

 ret=nullZero((SELECT sum(kwr_ilosc) FROM 
             tg_planzlecenia AS pz
	     JOIN tp_kkwplan AS pl USING (pz_idplanu)
	     JOIN tp_kkwhead AS h USING (kwp_idplanu)
	     JOIN tp_kkwelem AS e USING (kwh_idheadu)
	     JOIN tp_ruchy AS r ON (r.kwr_etapsrc=e.kwe_idelemu)
	     JOIN tg_transelem AS te ON (te.tel_idelem=r.tel_idelemdst)
	     WHERE pz.pz_idplanu=_pz_idplanu AND
	           pz.ttw_idtowaru=te.ttw_idtowaru
     ));
 
 RETURN ret;
END;
$_$;
