CREATE FUNCTION findpzetsforrezerwacja(numeric, public.tg_ruchy, integer DEFAULT NULL::integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _maxilosc   ALIAS FOR $1;
 _rez        ALIAS FOR $2;
 _idpztoskip ALIAS FOR $3;
 ruch_data   tg_ruchy;
 q           TEXT;
 _rp         tg_partie;
 wp          RECORD;
 iloscpoz    NUMERIC:=_maxilosc;
 tmp         NUMERIC;
BEGIN
 
 SELECT * INTO _rp FROM tg_partie WHERE prt_idpartii=_rez.prt_idpartiiwz;
 SELECT ttw_whereparams,ttw_inoutmethod INTO wp FROM tg_towary WHERE ttw_idtowaru=_rez.ttw_idtowaru;

 q='SELECT r.* 
    FROM tg_ruchy AS r
    JOIN tg_partie AS ppz ON (ppz.prt_idpartii=r.prt_idpartiipz) 
	LEFT OUTER JOIN gm.tv_oznaczoneruchy_top AS ozn ON (ozn.rc_idruchu=r.rc_idruchu) 
	'||gm.getinoutjoinclause(wp.ttw_inoutmethod,'r')||'
    WHERE ttm_idtowmag='||_rez.ttm_idtowmag||'
    AND isPZet(r.rc_flaga) AND NOT isBlockedPZ(r.rc_flaga) 
    AND r.rc_iloscpoz-(r.rc_iloscrez-r.rc_iloscrezzr)>0 
    AND r.rc_iloscpoz>0
    AND r.rc_idruchu<>COALESCE('||gm.toString(_idpztoskip)||',-1)
    '||gm.getWhereClause('ppz',_rp,wp.ttw_whereparams)||'
    ORDER BY (ozn.rc_idruchu IS NOT NULL) DESC,'||gm.getinoutsortclause(wp.ttw_inoutmethod::int,'r','ppz',FALSE);
 FOR ruch_data IN EXECUTE q
 LOOP
  tmp=min(iloscpoz,ruch_data.rc_iloscpoz-(ruch_data.rc_iloscrez-ruch_data.rc_iloscrezzr));

  IF (gm.isFullPartiaOnly(wp.ttw_whereparams,ruch_data.rc_idruchu)=TRUE) THEN
   IF (tmp<>ruch_data.rc_iloscpoz) OR (tmp<>_rez.rc_ilosc-_rez.rc_iloscpoz)THEN
    CONTINUE;
   END IF;
  END IF;


  iloscpoz=iloscpoz-gm.skojarzPZzRezerwacja(tmp,ruch_data,_rez);

  ---Nie mozemy iterowac dalej bo rezerwacja mogla sie zmienic - musimy wczytac jeszcze raz rezerwacje :(
  RETURN _maxilosc-iloscpoz;
 END LOOP;

 RETURN _maxilosc-iloscpoz;
END;
$_$;
