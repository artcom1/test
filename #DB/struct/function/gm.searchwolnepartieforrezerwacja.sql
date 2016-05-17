CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idrezerwacji ALIAS FOR $1;
 _idtowmag     ALIAS FOR $2;

 r RECORD;
 q TEXT;
 inoutmethod INT;
BEGIN
 

 IF (COALESCE(vendo.getTParam('BLOCKREZSEARCH'),'0')<>'0') THEN
  RETURN 0;
 END IF;

 IF (_idrezerwacji IS NOT NULL) THEN
  inoutmethod=(SELECT ttw_inoutmethod FROM tg_towary join tg_ruchy USING (ttw_idtowaru) WHERE rc_idruchu=_idrezerwacji);
 ELSE
  inoutmethod=(SELECT ttw_inoutmethod FROM tg_towary join tg_towmag USING (ttw_idtowaru) WHERE ttm_idtowmag=_idtowmag);
 END IF;

 q='SELECT ptm.prt_idpartii,rrez.ttm_idtowmag
    FROM tg_ruchy AS rrez
    JOIN tg_partie AS pwz ON (pwz.prt_idpartii=rrez.prt_idpartiiwz)
    JOIN tg_partietm AS ptm ON (ptm.ttm_idtowmag=rrez.ttm_idtowmag)
    JOIN tg_partie AS ppz ON (ppz.prt_idpartii=ptm.prt_idpartii)
    JOIN tg_towary AS tw ON (tw.ttw_idtowaru=rrez.ttw_idtowaru)
	'||gm.getinoutjoinclause(inoutmethod,'rrez')||'
    WHERE ptm.ptm_stanmag-ptm.ptm_rezerwacje-ptm.ptm_rezerwacjel>0 AND
          isRezerwacja(rrez.rc_flaga) AND
	  gm.comparePartie(ppz,pwz,tw.ttw_whereparams)>0 AND ';

  IF (_idrezerwacji IS NOT NULL) THEN
   q=q||'rrez.rc_idruchu='||_idrezerwacji;
  ELSE
   q=q||'rrez.ttm_idtowmag='||_idtowmag;
  END IF;

 q=q||' ORDER BY gm.comparePartie(ppz,pwz,tw.ttw_whereparams) DESC,
          '||gm.getinoutsortclause(inoutmethod,'rrez','ppz',FALSE);

--- RAISE NOTICE '\r\n%',gm.toNotice(q);
 FOR r IN EXECUTE q
 LOOP
---  RAISE NOTICE 'Znalazlem % ',r;
  PERFORM gm.searchallrezerwacje(r.ttm_idtowmag,r.prt_idpartii);
 END LOOP;

 RETURN TRUE;
END;
$_$;
