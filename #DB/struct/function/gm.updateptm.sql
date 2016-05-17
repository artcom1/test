CREATE FUNCTION updateptm(integer, integer, numeric, numeric, numeric, boolean, numeric, integer, addalways boolean DEFAULT false) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idpartii    ALIAS FOR $1;
 _idtowmag    ALIAS FOR $2;
 _deltastan   ALIAS FOR $3;
 _deltarez    ALIAS FOR $4;
 _deltarezl   ALIAS FOR $5;
 _rezlnull    ALIAS FOR $6;
 _deltaspotw  ALIAS FOR $7;
 _deltapzetsc ALIAS FOR $8;
 id           INT;
 idtm         INT;
 rtowaru      INT;
BEGIN
--- RAISE NOTICE '% % % % %',_idpartii,_idtowmag,_deltastan,_deltarez,_deltarezl;
 
 IF (_idpartii IS NULL) OR ((_deltastan=0) AND (_deltarez=0) AND (_deltarezl=0) AND (_deltaspotw=0) AND (addalways=FALSE)) THEN
  RETURN NULL;
 END IF;
 
 UPDATE tg_partietm 
 SET ptm_stanmag=ptm_stanmag+_deltastan,
     ptm_rezerwacje=ptm_rezerwacje+_deltarez,
     ptm_rezerwacjel=ptm_rezerwacjel+_deltarezl,
     ptm_wtymrezlnull=ptm_wtymrezlnull+(CASE WHEN _rezlnull=TRUE THEN _deltarezl ELSE 0 END),
     ptm_stanmagpotw=ptm_stanmagpotw+_deltaspotw,
	 ptm_pzetscount=ptm_pzetscount+_deltapzetsc
 WHERE prt_idpartii=_idpartii AND ttm_idtowmag=_idtowmag
 RETURNING ptm_id
 INTO id;
 
 IF (id IS NOT NULL) THEN
  RETURN id;
 END IF;
 
 --Rozmiarowka
 id=(SELECT prt_idparent_rozm FROM tg_partie WHERE prt_idpartii=_idpartii);
 IF (id IS NOT NULL) THEN
  idtm=(SELECT gettowmag(p.ttw_idtowaru,tmsrc.tmg_idmagazynu,TRUE)
        FROM tg_partie AS p 
		JOIN tg_towmag AS tmsrc ON (tmsrc.ttm_idtowmag=_idtowmag) 
		WHERE p.prt_idpartii=id
	   );
  id=gm.updateptm(id,idtm,0,0,0,false,0,0,TRUE);
  IF (id IS NULL) THEN
   RAISE EXCEPTION 'Nie moge wyznaczyc IDParent dla tg_partietm';
  END IF;
 END IF;
 
 rtowaru=(SELECT ttw_rtowaru FROM tg_towary WHERE ttw_idtowaru=(SELECT ttw_idtowaru FROM tg_towmag WHERE ttm_idtowmag=_idtowmag));

 INSERT INTO tg_partietm
  (ttm_idtowmag,prt_idpartii,
   ttw_idtowaru,
   tmg_idmagazynu,
   ptm_stanmag,
   ptm_rezerwacje,
   ptm_rezerwacjel,
   ptm_wtymrezlnull,
   ptm_inkj,
   ptm_stanmagpotw,
   ptm_rtowaru,
   ptm_idparent,
   ptm_dzielnikrozm,
   ptm_pzetscount
 ) VALUES
 (_idtowmag,_idpartii,
  (SELECT ttw_idtowaru FROM tg_towmag WHERE ttm_idtowmag=_idtowmag),
  (SELECT tmg_idmagazynu FROM tg_towmag WHERE ttm_idtowmag=_idtowmag),
  _deltastan,
  _deltarez,
  _deltarezl,
  (CASE WHEN _rezlnull=TRUE THEN _deltarezl ELSE 0 END),
  (SELECT (prt_inkj&2) IS NOT DISTINCT FROM 2 FROM tg_partie WHERE prt_idpartii=_idpartii),
  _deltaspotw,
  rtowaru,
  id,
  COALESCE((CASE WHEN rtowaru=128 THEN (SELECT sum(rmk_przelicznik) FROM tg_rozmsppakelems JOIN tg_partie USING (rmp_idsposobu) WHERE prt_idpartii=_idpartii) ELSE 1 END),1),
  _deltapzetsc  
 );

 return currval('tg_partietm_s');
END;
$_$;
