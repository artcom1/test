CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 minid INT:=nextval('gms.tm_simcoll_s');
 stan bool;
BEGIN

--- SET enable_nestloop=off;

 CREATE TEMP TABLE useprevimulation_init AS 
  (
   SELECT src.rc_idruchupz FROM gms.tm_simcoll AS src WHERE src.sc_sid=vendo.tv_mysessionpid() AND src.sc_simid=srcsimno
   EXCEPT
   SELECT dst.rc_idruchupz FROM gms.tm_simcoll AS dst WHERE dst.sc_sid=vendo.tv_mysessionpid() AND dst.sc_simid=dstsimno   
  );
 ---CREATE INDEX useprevimulation_init_i1 ON useprevimulation_init(rc_idruchupz);
  
 WITH a AS
 (
  SELECT sum(o.so_ilosci[0]) AS i0,sum(o.so_ilosci[1]) AS i1,sum(o.so_ilosci[2]) AS i2,
         sum(o.so_ilosc) AS iloscpoz,
         c.sc_id
  FROM useprevimulation_init AS i 
  JOIN gms.tm_simcoll AS c ON (i.rc_idruchupz=c.rc_idruchupz)
  LEFT OUTER JOIN gms.tm_simorder AS o ON (c.sc_id=o.sc_id)
  WHERE c.sc_sid=vendo.tv_mysessionpid() AND c.sc_simid=srcsimno
  GROUP BY c.sc_id
 )
 --- Przekopiuj ze starej tabeli gms.tm_simcoll te rekordy ktorych nie ma w nowej symulacji 
 INSERT INTO gms.tm_simcoll
  (sc_simid,
   rc_idruchupz,sc_idtowmag,sc_idmiejsca,sc_idpartiipz,sc_partiapzisnull,
   sc_iloscpoz,
   sc_ilosc[0],sc_ilosc[1],sc_ilosc[2],
   sc_deltailoscpoz,sc_deltailoscrez,sc_deltailoscwz,sc_iloscpriorited,sc_iloscused)
 SELECT dstsimno,
   src.rc_idruchupz,src.sc_idtowmag,src.sc_idmiejsca,src.sc_idpartiipz,src.sc_partiapzisnull,
   src.sc_iloscpoz+COALESCE(a.iloscpoz,0),
   src.sc_ilosc[0]+gms.l2p(COALESCE(a.i0,'(0,0,0,0)'::gms.tm_ilosci)),
   src.sc_ilosc[1]+gms.l2p(COALESCE(a.i1,'(0,0,0,0)'::gms.tm_ilosci)),
   src.sc_ilosc[2]+gms.l2p(COALESCE(a.i2,'(0,0,0,0)'::gms.tm_ilosci)),
   src.sc_deltailoscpoz,src.sc_deltailoscrez,src.sc_deltailoscwz,src.sc_iloscpriorited,src.sc_iloscused
 FROM useprevimulation_init 
 JOIN gms.tm_simcoll AS src ON (useprevimulation_init.rc_idruchupz=src.rc_idruchupz AND src.sc_sid=vendo.tv_mysessionpid() AND src.sc_simid=srcsimno)
 LEFT OUTER JOIN a ON (a.sc_id=src.sc_id);

 DROP TABLE useprevimulation_init;
 
 ---SET enable_nestloop=on;
/*
 WITH a AS
 (
  SELECT sum(o.so_ilosci[0]) AS i0,sum(o.so_ilosci[1]) AS i1,sum(o.so_ilosci[2]) AS i2,
         sum(o.so_ilosc) AS iloscpoz,
         o.sc_id
  FROM gms.tm_simorder AS o
  JOIN gms.tm_simcoll AS c ON (c.sc_id=o.sc_id)
  WHERE c.sc_sid=vendo.tv_mysessionpid() AND c.sc_simid=srcsimno
  GROUP BY o.sc_id
 )
 --- Przekopiuj ze starej tabeli gms.tm_simcoll te rekordy ktorych nie ma w nowej symulacji 
 INSERT INTO gms.tm_simcoll
  (sc_simid,
   rc_idruchupz,sc_idtowmag,sc_idmiejsca,sc_idpartiipz,sc_partiapzisnull,
   sc_iloscpoz,
   sc_ilosc[0],sc_ilosc[1],sc_ilosc[2],
   sc_deltailoscpoz,sc_deltailoscrez,sc_deltailoscwz,sc_iloscpriorited,sc_iloscused)
 SELECT dstsimno,
   src.rc_idruchupz,src.sc_idtowmag,src.sc_idmiejsca,src.sc_idpartiipz,src.sc_partiapzisnull,
   src.sc_iloscpoz+COALESCE(a.iloscpoz,0),
   src.sc_ilosc[0]+gms.l2p(COALESCE(a.i0,'(0,0,0,0)'::gms.tm_ilosci)),
   src.sc_ilosc[1]+gms.l2p(COALESCE(a.i1,'(0,0,0,0)'::gms.tm_ilosci)),
   src.sc_ilosc[2]+gms.l2p(COALESCE(a.i2,'(0,0,0,0)'::gms.tm_ilosci)),
   src.sc_deltailoscpoz,src.sc_deltailoscrez,src.sc_deltailoscwz,src.sc_iloscpriorited,src.sc_iloscused
 FROM gms.tm_simcoll AS src
 LEFT OUTER JOIN gms.tm_simcoll AS dst ON (dst.rc_idruchupz=src.rc_idruchupz AND dst.sc_sid=vendo.tv_mysessionpid() AND dst.sc_simid=dstsimno)
 LEFT OUTER JOIN a ON (a.sc_id=src.sc_id)
 WHERE src.sc_sid=vendo.tv_mysessionpid() AND src.sc_simid=srcsimno AND 
       dst.sc_id IS NULL;
*/

 ---Skopiuj ordery ze zdrodlowej symulacji
 
 INSERT INTO gms.tm_simorder
  (sc_id,so_ordertype,so_orderno,
   so_ilosci[0],
   so_ilosci[1],
   so_ilosci[2],
   so_ilosc,
   so_prevsimno,so_qdiv)
 SELECT
   dst.sc_id,srco.so_ordertype,srco.so_orderno,
   gms.l2p(srco.so_ilosci[0]),
   gms.l2p(srco.so_ilosci[1]),
   gms.l2p(srco.so_ilosci[2]),
   srco.so_ilosc,
   COALESCE(srco.so_prevsimno,src.sc_simid),srco.so_qdiv
 FROM gms.tm_simorder AS srco
 JOIN gms.tm_simcoll AS src ON (src.sc_id=srco.sc_id)
 JOIN gms.tm_simcoll AS dst ON (dst.rc_idruchupz=src.rc_idruchupz)
 WHERE src.sc_sid=vendo.tv_mysessionpid() AND src.sc_simid=srcsimno AND
       dst.sc_sid=vendo.tv_mysessionpid() AND dst.sc_simid=dstsimno;
	    
 RETURN TRUE;
END;
$$;
