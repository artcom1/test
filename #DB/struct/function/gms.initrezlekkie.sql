CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
BEGIN

 FOR r IN 
 SELECT * FROM (
 SELECT b.sc_id,
        max(min(b.iloschpoz,max(0,b.ilosc-(b.ilosctotal-b.iloschpoz))),0) as iloscl,
---        b.ilosctotal AS iloscl,
	iloschpoz,
	ilosc,
	ilosctotal
 FROM (
 SELECT a.sc_id,
        a.iloschpoz,
        sum(iloschpoz) OVER w AS ilosctotal,
	a.ilosc
 FROM (
 SELECT sc.sc_id, ---- ID 
        sc.sc_iloscpoz-((sc.sc_ilosc[1]).pnull+(sc.sc_ilosc[1]).p+(sc.sc_ilosc[1]).lnull+(sc.sc_ilosc[1]).lnull) AS iloschpoz, ---Ilosc pozostala na rekordzie
	ptm.ptm_rezerwacjel-ptm.ptm_wtymrezlnull AS ilosc, --- Ilosc rezerwacji lekkich
	sc.sc_idpartiipz,sc.rc_idruchupz
 FROM gms.tm_simcoll AS sc
 LEFT OUTER JOIN tg_partietm AS ptm ON (sc.sc_idpartiipz=ptm.prt_idpartii AND sc.sc_idtowmag=ptm.ttm_idtowmag)
 WHERE sc.sc_sid=vendo.tv_mysessionpid() AND sc_simid=simid
 ) AS a
 WINDOW w AS (PARTITION BY a.sc_idpartiipz ORDER BY a.rc_idruchupz)
 ORDER BY a.sc_idpartiipz,a.rc_idruchupz
 ) AS b
 ) AS c WHERE iloscl>0
 LOOP
  ----RAISE NOTICE 'DLa % robie % (stahn % rezerwacji lekkich % dotychczas handlowy %)',r.sc_id,r.iloscl,r.iloschpoz,r.ilosc,r.ilosctotal;
---  RAISE EXCEPTION 'Found';
  UPDATE gms.tm_simcoll SET sc_ilosc[2].p=(sc_ilosc[2]).p+r.iloscl WHERE sc_id=r.sc_id;
 END LOOP;

 ----------------------------------------------------------------------------------------------------------------------------------------------

 FOR r IN 
 SELECT * FROM (
 SELECT b.sc_id,
        max(min(b.iloschpoz,max(0,b.ilosc-(b.ilosctotal-b.iloschpoz))),0) as iloscl,
---        b.ilosctotal AS iloscl,
	iloschpoz,
	ilosc,
	ilosctotal
 FROM (
 SELECT a.sc_id,
        a.iloschpoz,
        sum(iloschpoz) OVER w AS ilosctotal,
	a.ilosc
 FROM (
 SELECT sc.sc_id, ---- ID 
        sc.sc_iloscpoz-((sc.sc_ilosc[1]).pnull+(sc.sc_ilosc[1]).p+(sc.sc_ilosc[1]).lnull+(sc.sc_ilosc[1]).lnull+(sc.sc_ilosc[2]).p) AS iloschpoz, ---Ilosc pozostala na rekordzie
	ptm.ptm_wtymrezlnull AS ilosc, --- Ilosc rezerwacji lekkich
	sc.sc_idpartiipz,sc.rc_idruchupz
 FROM gms.tm_simcoll AS sc
 LEFT OUTER JOIN tg_partietm AS ptm ON (sc.sc_idpartiipz=ptm.prt_idpartii AND sc.sc_idtowmag=ptm.ttm_idtowmag)
 WHERE sc.sc_sid=vendo.tv_mysessionpid() AND sc_simid=simid
 ) AS a
 WINDOW w AS (PARTITION BY a.sc_idpartiipz ORDER BY a.rc_idruchupz)
 ORDER BY a.sc_idpartiipz,a.rc_idruchupz
 ) AS b
 ) AS c WHERE iloscl>0
 LOOP
-- RAISE NOTICE 'DLa % robie % (stahn % rezerwacji lekkich % dotychczas handlowy %)',r.sc_id,r.iloscl,r.iloschpoz,r.ilosc,r.ilosctotal;
---  RAISE EXCEPTION 'E';
  UPDATE gms.tm_simcoll SET sc_ilosc[2].pnull=(sc_ilosc[2]).pnull+r.iloscl WHERE sc_id=r.sc_id;
 END LOOP;


 RETURN TRUE;
END
$$;
