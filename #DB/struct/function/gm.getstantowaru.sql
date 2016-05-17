CREATE FUNCTION getstantowaru(integer, integer, integer, integer, integer, integer, integer DEFAULT NULL::integer, numeric DEFAULT NULL::numeric) RETURNS stan_towaru
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowmag    ALIAS FOR $1;
 _idtowaru    ALIAS FOR $2;
 _idpartii    ALIAS FOR $3;
 _idklienta   ALIAS FOR $4;
 _idskojelem  ALIAS FOR $5;
 _fmidx       ALIAS FOR $6;
 pap        tg_partie;
 ret   gm.STAN_TOWARU;
BEGIN 
 IF (_idpartii IS NOT NULL) THEN
  SELECT * INTO pap FROM tg_partie WHERE prt_idpartii=_idpartii;
 ELSE
  pap=gm.getNULLPartiaRecord(_idtowaru,_idtowmag,-1);
 END IF;

 ret=gm.getStanTowaru(_idtowmag,_idtowaru,pap,_idklienta,_idskojelem,_fmidx,$7,$8);

 RETURN ret;
END;
$_$;


--
--

CREATE FUNCTION getstantowaru(integer, integer, public.tg_partie, integer, integer, integer, integer DEFAULT NULL::integer, numeric DEFAULT NULL::numeric) RETURNS stan_towaru
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtowmag    ALIAS FOR $1;
 _idtowaru    ALIAS FOR $2;
 pap          ALIAS FOR $3;
 _idklienta   ALIAS FOR $4;
 _idskojelem  ALIAS FOR $5;
 _fmidx       ALIAS FOR $6;
 _simid       ALIAS FOR $7;
 _similosc    ALIAS FOR $8;
 q TEXT;
 _in          gm.DODAJ_WZ_TYPE;
 retrez RECORD;
 retpz  RECORD;
 rettm  RECORD;

 tmp    NUMERIC;
 tmpl   NUMERIC;
 tmpt   NUMERIC;

 iloscpoz NUMERIC:=_similosc;

 ret   gm.STAN_TOWARU;
 s     gm.tm_simulation;

 rc_iloscrez   NUMERIC:=0;
 rc_iloscrezl  NUMERIC:=0;
 rezlekkie     NUMERIC:=0;
 stanh         NUMERIC:=0;
 stanmag       NUMERIC:=0;
 rezl          NUMERIC:=0;

 onemoretime   BOOL:=TRUE;
 retl          NUMERIC;

 anychange     BOOL;

 r     RECORD;
BEGIN 
 _in.ttm_idtowmag=_idtowmag;
 _in.ttw_idtowaru=_idtowaru;
 _in.k_idklienta=_idklienta;
 _in.rez_idelem=_idskojelem;
 _in.fm_idcentrali=(SELECT fm_index FROM tb_firma WHERE fm_idindextab=_fmidx);
 _in._pominrez=FALSE;

 ----------------------------------------------------------------------------------------------------------------------------------------
 IF (_idtowmag IS NOT NULL) THEN
  SELECT ttw_whereparams,ttm_stan,ttm_rezerwacja,ttm_rezlekka INTO rettm 
  FROM tg_towary 
  JOIN tg_towmag USING (ttw_idtowaru) 
  WHERE ttm_idtowmag=_idtowmag;
  _in.ttw_whereparams=rettm.ttw_whereparams;
 ELSE
  SELECT ttw_stan[_fmidx] AS ttm_stan,ttw_rezerwacja[_fmidx] AS ttm_rezerwacja,ttw_rezlekka[_fmidx] AS ttm_rezlekka INTO rettm 
  FROM tg_towary 
  WHERE ttw_idtowaru=_idtowaru;
  _in.ttw_whereparams=(SELECT ttw_whereparams FROM tg_towary WHERE ttw_idtowaru=_idtowaru);
 END IF;
 ----------------------------------------------------------------------------------------------------------------------------------------

 q=gm.dodaj_wz_queryrez(_in,pap,TRUE);
 
 IF (_simid IS NULL) THEN
  q='SELECT sum(rc_iloscrez) AS rc_iloscrez,sum(rc_iloscrezl) AS rc_iloscrezl FROM ('||q||') AS inq';
---  RAISE NOTICE '\r\n%',gm.toNotice(q);
  EXECUTE q INTO retrez;

  rc_iloscrez=retrez.rc_iloscrez;
  rc_iloscrezl=retrez.rc_iloscrezl;
 ELSE 
  s.sim_sid=COALESCE(vendo.tv_mysessionpid(),-1);
  s.sim_simid=_simid;
  s.sim_iloscpz=0;

  q='SELECT inq.rc_iloscrez,inq.rc_iloscrezl,s.sim_iloscrezn,s.sim_iloscrezl,inq.rc_idruchu,inq.rc_ruch,inq.prt_idpartiipz FROM ('||q||') AS inq 
     LEFT OUTER JOIN gm.tv_simulationrez AS s ON (inq.rc_idruchu=s.rc_idruchurez AND s.sim_sid=COALESCE(vendo.tv_mysessionpid(),-1) AND s.sim_simid='||_simid||')';
  
  onemoretime=TRUE;
  LOOP
   EXIT WHEN onemoretime=FALSE;
   onemoretime=FALSE;
   ---RAISE NOTICE 'Wykonanie ponowne';
   FOR r IN EXECUTE q
   LOOP
    --Lekkie + ciezkie
    tmp=r.rc_iloscrez-COALESCE(r.sim_iloscrezn,0)-COALESCE(r.sim_iloscrezl,0);
    --Lekkie
    tmpl=r.rc_iloscrezl-COALESCE(r.sim_iloscrezl,0);
    ---Tylko ciezkie
    tmp=tmp-tmpl;
    CONTINUE WHEN tmp=0 AND tmpl=0;

    IF (_similosc IS NOT NULL) AND (iloscpoz>0) THEN
     s.rc_idruchurez=r.rc_idruchu;
     s.rc_idruchupz=r.rc_ruch;
     tmpt=min(iloscpoz,tmpl);
     tmpl=tmpl-tmpt;
     s.sim_iloscrezl=tmpt;
     rezlekkie=rezlekkie-tmpt-COALESCE(r.sim_iloscrezl,0);
     iloscpoz=iloscpoz-tmpt;
     tmpt=min(iloscpoz,tmp);
     tmp=tmp-tmpt;
     s.sim_iloscrezn=tmpt;
     iloscpoz=iloscpoz-tmpt;
     retl=gm.simulate_wz(_in,pap,s,s.sim_iloscrezl,r.prt_idpartiipz);
     IF (retl>0)  THEN
      ---RAISE NOTICE 'OMT (%) % (%+%)',s,retl,tmp,tmpl;
      anychange=(retl!=s.sim_iloscrezn+s.sim_iloscrezl);
      rc_iloscrez=rc_iloscrez+tmp+tmpl-retl;
      iloscpoz=iloscpoz+retl;
      IF (tmpl=0) THEN retl=0; END IF;
      rc_iloscrezl=rc_iloscrezl+tmpl-retl;
      IF (anychange=TRUE) THEN
       onemoretime=TRUE;
       ---EXIT;
      END IF;
     END IF;
    END IF;
    rc_iloscrez=rc_iloscrez+tmp+tmpl;
    rc_iloscrezl=rc_iloscrezl+tmpl;
   END LOOP;
  END LOOP;
 END IF;

 ----------------------------------------------------------------------------------------------------------------------------------------
 --RAISE NOTICE '% %',q,retrez;

 IF (_simid IS NULL) THEN
  q=gm.dodaj_wz_querypz(_in,pap,TRUE);
  q='SELECT sum(stanh) AS stanh,sum(stanmag) AS stanmag,sum(rl) AS rl FROM (
     SELECT rc_zostalo AS stanh,inq.rc_iloscpoz AS stanmag,
            min(inq.rc_zostalo,max(0,tm.ptm_rezerwacjel-((sum(inq.rc_zostalo) OVER w)-inq.rc_zostalo))) AS rl
     FROM ('||q||') AS inq
     JOIN tg_ruchy AS r ON (inq.rc_idruchu=r.rc_idruchu)
     JOIN tg_partietm AS tm ON (tm.prt_idpartii=inq.prt_idpartiipz AND tm.ttm_idtowmag=r.ttm_idtowmag) 
     WINDOW w AS (PARTITION BY inq.prt_idpartiipz ORDER BY inq.rc_idruchu ASC)
     ) AS inqi';
  EXECUTE q INTO retpz;

  stanh=retpz.stanh;
  stanmag=retpz.stanmag;
  rezl=retpz.rl;
 ELSE
  q=gm.dodaj_wz_querypz(_in,pap,TRUE);
  ---q='SELECT qi.*,COALESCE(ss.sim_iloscpz+ss.sim_iloscrezl+ss.sim_iloscrezn,0) AS dod,COALESCE(ss.sim_iloscrezl,0) AS dodl FROM ('||q||') AS qi 
  q='SELECT qi.*,
            COALESCE(ss.sim_iloscpz+ss.sim_iloscrezl,0) AS dod,
	    COALESCE(ss.sim_iloscpz+ss.sim_iloscrezl+ss.sim_iloscrezn,0) AS dodfull,
	    COALESCE(ss.sim_iloscrezl,0) AS dodl 
     FROM ('||q||') AS qi 
     LEFT OUTER JOIN gm.tv_simulation AS ss ON (qi.rc_idruchu=ss.rc_idruchupz AND ss.sim_sid='||s.sim_sid||' AND ss.sim_simid='||s.sim_simid||')';

  q='SELECT (stanh) AS stanh,(stanmag) AS stanmag,(rl) AS rl,rc_idruchu FROM (
     SELECT rc_zostalo-dod AS stanh,inq.rc_iloscpoz-dodfull AS stanmag,
            min(inq.rc_zostalo-dod,max(0,tm.ptm_rezerwacjel-(sum(dodl) OVER v)-((sum(inq.rc_zostalo-dod) OVER w)-(inq.rc_zostalo-dod)))) AS rl,
	    inq.rc_idruchu
     FROM ('||q||') AS inq
     JOIN tg_ruchy AS r ON (inq.rc_idruchu=r.rc_idruchu)
     JOIN tg_partietm AS tm ON (tm.prt_idpartii=inq.prt_idpartiipz AND tm.ttm_idtowmag=r.ttm_idtowmag) 
     WINDOW w AS (PARTITION BY inq.prt_idpartiipz ORDER BY inq.rc_idruchu ASC),
            v AS (PARTITION BY inq.prt_idpartiipz)
     ) AS inqi';
---  EXECUTE q INTO retpz;

  onemoretime=TRUE;
  LOOP
   EXIT WHEN onemoretime=FALSE;
   onemoretime=FALSE;

   FOR r IN EXECUTE q 
   LOOP
    tmp=r.stanh-r.rl;
    tmpl=min(iloscpoz,tmp);
    stanmag=stanmag+r.stanmag;
    stanh=stanh+r.stanh;
    rezl=rezl+r.rl;

    IF (tmpl>0) THEN
     stanmag=stanmag-tmpl;
     stanh=stanh-tmpl;
     s.rc_idruchurez=NULL;
     s.rc_idruchupz=r.rc_idruchu;
     s.sim_iloscpz=tmpl;
     s.sim_iloscrezn=0;
     s.sim_iloscrezl=0;
     retl=gm.simulate_wz(NULL,NULL,s,0,NULL);     
     IF (retl>0) AND (onemoretime=TRUE) AND (retl!=s.sim_iloscpz) THEN
      iloscpoz=iloscpoz-tmpl+retl;
      onemoretime=TRUE;
      ----EXIT;
     END IF;
    END IF;
    iloscpoz=iloscpoz-tmpl;
   END LOOP;
  END LOOP;
 END IF;
 ---RAISE NOTICE 'Iloscpoz % %',iloscpoz,_similosc;
--- RAISE NOTICE '\r\n%',gm.toNotice(q);

 ----------------------------------------------------------------------------------------------------------------------------------------
/*
 st: stan_towaru
sp: suma_poprzednich
rl: rezerwacje lekkie
rlp=max(rl-sp,0): rezerwacje lekkie pozostale
rlw=min(rlp,st): rezerwacje lekkie wykorzystane
*/

 ---RAISE NOTICE '% %',q,retpz;

 ---Stan magazynowy partii
 ret.stanmag=stanmag;
 ---Stan handlowy partii (stan magazynowy minus rezerwacje ciezkie)
 ret.stanh=stanh;
 ---Rezerwacje od klienta
 ret.addfromkl=COALESCE(rc_iloscrez,0);
 ---W tym rezerwacji lekkich
 ret.addfromrl=COALESCE(rc_iloscrezl,0);
 ---Suma rezerwacji lekkich
 ret.rezlekkie=rezl;---rezlekkie;

 --Stan handlowy realny
 ret.stanh_real=ret.stanh-ret.rezlekkie+ret.addfromkl;

 --Ilosc dostepna
 ret.iloscavail=_similosc-iloscpoz;

 RETURN ret;
END;
$_$;
