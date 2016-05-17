CREATE FUNCTION initscex(tablename text, tablealias text, simid text, idtowmag text, idruchupz text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
 q TEXT;
 ret INT;
BEGIN

 IF (NOT (current_setting('server_version_num')::int>=90200)) THEN
  tablealias='('||tablename||') AS '||tablealias;
 END IF;

 q='
 INSERT INTO gms.tm_simcoll
  (sc_simid,rc_idruchupz,sc_iloscpoz,sc_idmiejsca,sc_idpartiipz,
   sc_partiapzisnull,
   sc_ilosc[0],
   sc_ilosc[1],
   sc_ilosc[2],
   sc_idtowmag
  )
 SELECT '||simid||',r.rc_idruchu,r.rc_iloscpoz,r.mm_idmiejsca,r.prt_idpartiipz,
        gm.getIDNULLPartii(r.ttw_idtowaru,FALSE,1) IS NOT DISTINCT FROM r.prt_idpartiipz,
       (0,0,0,0)::gms.tm_ilosci,
       (COALESCE(rez.iloscpnull,0),COALESCE(rez.iloscp,0),0,0)::gms.tm_ilosci,
       (0,0,0,0)::gms.tm_ilosci,
       r.ttm_idtowmag 
 FROM tg_ruchy AS r';

 IF (tablename IS NOT NULL) THEN
  q=q||' JOIN '||tablealias||' ON (true=true)';
 END IF;

 q=q||' LEFT OUTER JOIN
 (
  SELECT rez.rc_ruch,
         sum((CASE WHEN isRezerwacjaNULL(rez.rc_flaga) THEN rez.rc_iloscrez ELSE 0 END)) AS iloscpnull,
         sum((CASE WHEN isRezerwacjaNULL(rez.rc_flaga) THEN 0 ELSE rez.rc_iloscrez END)) AS iloscp
  FROM tg_ruchy AS rez ';

 IF (tablename IS NOT NULL) THEN
  --q=q||' JOIN '||tablename||' AS '||tablealias||' ON (true=true)';
  q=q||' JOIN '||tablealias||' ON (true=true)';
 END IF;

 q=q||' WHERE isRezerwacja(rez.rc_flaga) AND 
        NOT isRezerwacjaLekka(rez.rc_flaga) AND
        rez.rc_iloscrez>0';

 IF (idtowmag IS NOT NULL) THEN
  q=q||' AND rez.ttm_idtowmag='||idtowmag;
 END IF;

 IF (idruchupz IS NOT NULL) THEN
  q=q||' AND rez.rc_ruch='||idruchupz;
 END IF;

 q=q||'
   GROUP BY rez.rc_ruch
  ) AS rez ON (rez.rc_ruch=r.rc_idruchu)
  WHERE isPZet(r.rc_flaga)';

 IF (idtowmag IS NOT NULL) THEN
  q=q||' AND r.rc_iloscpoz>0 AND r.ttm_idtowmag='||idtowmag;
 END IF;

 IF (idruchupz IS NOT NULL) THEN
  q=q||' AND r.rc_idruchu='||idruchupz;
 END IF;

 IF (tablename IS NOT NULL) AND (current_setting('server_version_num')::int>=90200) THEN
  q='WITH '||tablealias||' AS ('||tablename||') '||q;
 END IF;

--- RAISE NOTICE '%',gm.toNotice(q);

 RETURN q;
END;
$$;
