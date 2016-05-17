CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _kwe_idelemu ALIAS FOR $1;
 _ilosc_oczek ALIAS FOR $2;
 _ilosc_plan_wyk ALIAS FOR $3;
 _ilosc_plan_brak ALIAS FOR $4;
 
 _ilosc_op NUMERIC;
 _ilosc_wyr NUMERIC;
 prev RECORD;
BEGIN
   
 _ilosc_op=1;
 _ilosc_wyr=COALESCE(_ilosc_plan_wyk,0)+COALESCE(_ilosc_plan_brak,0);
 IF (_ilosc_wyr=0) THEN
  RETURN FALSE;
 END IF;
 
 _ilosc_wyr=(_ilosc_op*_ilosc_oczek)/_ilosc_wyr;
   
 FOR prev IN 	SELECT kwe_iloscwyk, kwe_tonext, 
				(CASE 
					WHEN (knpn_flaga&((1<<2)|(1<<3)|(1<<4))=0) AND knpn_x_mianownik<>0 THEN ((knpn_x_licznik*_ilosc_op)/knpn_x_mianownik+knpn_x_wspc)
					WHEN (knpn_flaga&((1<<2)|(1<<3)|(1<<4))=(1<<2)) AND knpn_x_mianownik<>0 THEN ((knpn_x_licznik*_ilosc_wyr)/knpn_x_mianownik+knpn_x_wspc)
					ELSE 0 
				END) AS ilosc 
				FROM tr_kkwnodprevnext AS pn
				JOIN tr_kkwnod AS nod ON (nod.kwe_idelemu=pn.kwe_idprev) 
				WHERE 
				kwe_idnext=_kwe_idelemu AND 
				knpn_flaga&((1<<2)|(1<<3)|(1<<4)) IN (0,(1<<2)) AND
				knpn_flaga&(1<<1)=0
				ORDER BY kwe_idprev ASC 
 LOOP 
  IF (prev.kwe_iloscwyk<(prev.kwe_tonext+prev.ilosc)) THEN
   RETURN FALSE;
  END IF;
 END LOOP;
  
 RETURN TRUE;
END;
$_$;
