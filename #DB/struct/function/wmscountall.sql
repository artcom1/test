CREATE FUNCTION wmscountall(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idmiejsca ALIAS FOR $1;
 rec RECORD;
BEGIN

 SELECT round(nullZero(sum(rc_iloscpoz*ttw_waga)),4) AS w,
        round(nullZero(sum(rc_iloscpoz*ttw_objetosc_mpq)),4) AS o,        
        round(nullZero(sum(rc_iloscpoz)),4) AS i,
        round(nullZero(sum(gms.getActiveIloscFromRuchPZet(rc_flaga,rc_iloscpoz,rc_iloscwzbuf))),4) AS icomm,
        round(nullZero(sum(gms.getActiveIloscFromRuchPZet(rc_flaga,rc_iloscpoz,rc_iloscwzbuf)*ttw_waga)),4) AS wcomm,
        round(nullZero(sum(gms.getActiveIloscFromRuchPZet(rc_flaga,rc_iloscpoz,rc_iloscwzbuf)*ttw_objetosc_mpq)),4) AS ocomm
	INTO rec
 FROM tg_ruchy AS r 
 JOIN tg_towary AS tw USING (ttw_idtowaru) 
 WHERE (isPZet(rc_flaga) OR isAPZet(rc_flaga)) AND 
       (rc_iloscpoz>0 OR rc_iloscwzbuf>0) AND 
       mm_idmiejsca=_idmiejsca;       
	   
 UPDATE ts_miejscamagazynowe SET 
        mm_v_obciazenie=rec.w,
	    mm_v_objetosc=rec.o,
	    mm_v_sumilosc=rec.i,
		mm_vc_sumilosc=rec.icomm,
        mm_vc_obciazenie=rec.wcomm,
	    mm_vc_objetosc=rec.ocomm
 WHERE mm_idmiejsca=_idmiejsca AND 
       (
        mm_v_obciazenie<>rec.w OR
	    mm_v_objetosc<>rec.o OR
	    mm_v_sumilosc<>rec.i OR
	    mm_vc_sumilosc<>rec.icomm OR
        mm_vc_obciazenie<>rec.wcomm OR
	    mm_vc_objetosc<>rec.ocomm
       );

 RETURN TRUE;
END;
$_$;
