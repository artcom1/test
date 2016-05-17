CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idmp ALIAS FOR $1;
 _ep_idetapu ALIAS FOR $2;
 lp INT;
 ret INT;
BEGIN
 
 lp=(SELECT ep_lp FROM tp_etappolproduktu WHERE ep_idetapu=_ep_idetapu);

 ret=(SELECT kwl_lp FROM tp_planonkkw AS pl 
			 JOIN tp_etappolproduktu AS epp USING (ep_idetapu) 
			 WHERE (pl.kwp_idplanu=_idmp) AND			       
			       (epp.ep_lp<=lp)
			 ORDER BY epp.ep_lp DESC,kwl_nakiedy DESC LIMIT 1 OFFSET 0
			 );

 RETURN nullZero(ret)+1;
END;
$_$;
