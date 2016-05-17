CREATE FUNCTION dodaj_wz_querypz(dodaj_wz_type, public.tg_partie, boolean DEFAULT false, integer DEFAULT NULL::integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
---WSPOK
DECLARE
 _in         ALIAS FOR $1;
 pap         ALIAS FOR $2;
 _allst      ALIAS FOR $3;   ---Jesli true to zwroc wszystkie a nie tylko te gdzie jest cos niezarezerwowane
 _idpartiipz ALIAS FOR $4;
 q TEXT;
BEGIN
 ---SELECT
 ---tg_ruchy
 ---Partie
 q='SELECT r.rc_cenajedn,r.rc_idruchu,r.rc_iloscpoz,
           r.rc_iloscpoz-(r.rc_iloscrez-r.rc_iloscrezzr) AS rc_zostalo,r.rc_wartoscpoz,r.rc_flaga,
           rc_ilosc,rc_iloscrez,rc_iloscrezzr,
	       r.prt_idpartiipz,
		   r.rc_wspwartosci
    FROM tg_ruchy AS r
    JOIN tg_partie AS ppz ON (r.prt_idpartiipz=ppz.prt_idpartii) 
	LEFT OUTER JOIN gm.tv_oznaczoneruchy_top AS ozn ON (ozn.rc_idruchu=r.rc_idruchu) ';
	
 q=q||gm.getinoutjoinclause(_in.ttw_inoutmethod,'r');
 
 ---WHERE Towar/partie
 IF (_in.ttm_idtowmag IS NOT NULL) THEN
  q=q||'WHERE r.ttm_idtowmag='||_in.ttm_idtowmag;
 ELSE
   q=q||' JOIN tg_magazyny AS mg ON (mg.tmg_idmagazynu=r.tmg_idmagazynu) ';
  q=q||'WHERE r.ttw_idtowaru='||_in.ttw_idtowaru||' AND mg.fm_idcentrali=COALESCE('||gm.toString(_in.fm_idcentrali)||',vendo.getIDCentrali())';
 END IF;

 --Wskazano ID partii PZ
 IF (_idpartiipz IS NOT NULL) THEN
  q=q||' AND r.prt_idpartiipz='||_idpartiipz;
 END IF;

 ---Czy tylko te gdzie cos jest niezarezerwowane
 IF (_allst=FALSE) THEN
  q=q||' AND r.rc_iloscpoz-(r.rc_iloscrez-r.rc_iloscrezzr)>0 ';
 ELSE
  q=q||' AND r.rc_iloscpoz>0 ';
 END IF;

 ---Cos zostalo na PZet i PZET i niezablokowany PZet
 ---Klauzula WHERE
 --ORDER
 q=q||' AND r.rc_iloscpoz>0 AND isPZet(r.rc_flaga) AND NOT isBlockedPZ(r.rc_flaga)
      '||gm.getWhereClause('ppz',pap,_in.ttw_whereparams)||'
       ORDER BY ozn.rc_idruchu IS NOT NULL DESC,r.rc_flaga&(1<<29) DESC,
       gm.comparePartie(ppz,'||vendo.record2string(pap)||'::tg_partie,'||_in.ttw_whereparams||') DESC,'
      ||gm.getinoutsortclause(_in.ttw_inoutmethod,'r','ppz',FALSE);

 ---RAISE NOTICE '%\r\n',q	;
		  
 RETURN q;
END
$_$;
