CREATE FUNCTION checklimittowaronakcja(integer, integer DEFAULT NULL::integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtam ALIAS FOR $1;
 _idklienta ALIAS FOR $2;
 r RECORD;
BEGIN

 IF (_idklienta IS NOT NULL) THEN
  SELECT ta_iloscmaxperklient-tam_ilosccurrent AS ile,* INTO r FROM tg_towaryakcjim AS m JOIN tg_towaryakcjimdet AS d USING (ta_idtowaru) WHERE m.ta_idtowaru=$1 AND d.k_idklienta=$2;
  IF (r.ile<0) THEN
   RAISE EXCEPTION '39|%:%:%:%:%:%|Przekroczenie limitu towarow akcji marketingowej per klient',$1,r.zl_idzlecenia,r.ttw_idtowaru,r.tam_ilosccurrent,r.ta_iloscmaxperklient,_idklienta;
  END IF;
  
  RETURN TRUE;
 END IF;


 SELECT * INTO r FROM tg_towaryakcjim WHERE ta_idtowaru=$1;

 IF (r.ta_ilosccurrent>r.ta_iloscmax) THEN
  RAISE EXCEPTION '39|%:%:%:%:%|Przekroczenie limitu towarow akcji marketingowej',$1,r.zl_idzlecenia,r.ttw_idtowaru,r.ta_ilosccurrent,r.ta_iloscmax;
 END IF;

 RETURN TRUE;
END;
$_$;
