CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _idtowaru ALIAS FOR $1;
 _wsp      ALIAS FOR $2;
 ret INT;
BEGIN

 IF (_wsp<0) THEN _wsp=-2; END IF;

 ret=(SELECT prt_idpartii 
      FROM tg_partie 
      WHERE ttw_idtowaru=_idtowaru AND 
            prt_hashcode IS NULL AND 
	    k_idklienta IS NULL AND 
	    zl_idzlecenia IS NULL AND 
	    prt_serialno IS NULL AND
	    prt_datawazn IS NULL AND
	    prt_idref IS NULL AND
		prt_terozroznik IS NULL AND
		prt_inkj IS NULL AND
		rmp_idsposobu IS NULL AND
	    prt_wplyw=_wsp
     );
 RETURN ret;
END;
$_$;
