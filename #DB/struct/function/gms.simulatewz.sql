CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
 r      RECORD;
 _sc_id INT;
 q      TEXT;
 q1     TEXT;
 ----t         timestamp:=clock_timestamp();
BEGIN

 q='SELECT s.sc_id,rpz.rc_idruchu,rwz.rc_ilosc-rwz.rc_iloscrezzr AS ilosc,rpz.prt_idpartiipz,rwz.prt_idpartiiwz,
           gm.getIDNULLPartii(rwz.ttw_idtowaru,FALSE,-1) AS idnullpartii,
           rwz.rc_idruchu AS rc_idruchuwz,rpz.mm_idmiejsca,
		   wz.tr_idtrans
    FROM tg_transakcje AS wz
    JOIN tg_ruchy AS rwz ON (wz.tr_idtrans=rwz.tr_idtrans)
    JOIN tg_ruchy AS rpz ON (rpz.rc_idruchu=rwz.rc_ruch)
    JOIN tg_partie AS p ON (p.prt_idpartii=rwz.prt_idpartiiwz)
    LEFT OUTER JOIN gms.tm_simcoll AS s ON (s.sc_sid=vendo.tv_mysessionpid() AND s.sc_simid='||simid||' AND s.rc_idruchupz=rwz.rc_ruch)
    WHERE wz.tr_flaga&128=128 AND      --- Operacja magazynowa
          wz.tr_flaga&512=512 AND      --- Rozchod
          wz.tr_zamknieta&1=0 AND      --- Dokument w buforze
		  (rwz.rc_flaga&(1<<28))!=0 AND 
          isFV(rwz.rc_flaga) AND
	      rwz.rc_ilosc-rwz.rc_iloscrezzr>0 AND
          ('||gm.toString(idmiejsca)||' IS NULL OR ((rpz.mm_idmiejsca='||gm.toString(idmiejsca)||' OR ('||gm.toString(idmiejsca)||'=0 AND rpz.mm_idmiejsca IS NULL)) AND ispzet(rpz.rc_flaga))) AND
	      ('||gm.toString(idtowmag)||' IS NULL OR rwz.ttm_idtowmag='||gm.toString(idtowmag)||') AND
	       (
		    rwz.ttm_idtowmag IN (SELECT DISTINCT sc_idtowmag from gms.tm_simcoll AS ss WHERE ss.sc_sid=vendo.tv_mysessionpid() AND ss.sc_simid='||simid||') OR
	       ('||gm.toString(idtowmag)||' IS NOT NULL AND 
		    rwz.ttm_idtowmag IS NOT DISTINCT FROM '||gm.toString(idtowmag)||' AND 
			('||gm.toString(idmiejsca)||' IS NULL OR rpz.mm_idmiejsca IS NOT DISTINCT FROM '||gm.toString(idmiejsca)||' OR ('||gm.toString(idmiejsca)||'=0 AND rpz.mm_idmiejsca IS NULL) )
		   )
	  )
	  ORDER BY rpz.rc_idruchu';
 RAISE NOTICE '%',gm.toNotice(q);	  

 --RAISE NOTICE 'SW1 %',(clock_timestamp()-t);
 ---t=clock_timestamp();
 
 IF (current_setting('server_version_num')::int>=90200) THEN
  q='WITH q AS ('||q||'), 
    b AS ('||gms.initscex('SELECT DISTINCT q.rc_idruchu FROM q WHERE sc_id IS NULL','a',simid::text,NULL,'a.rc_idruchu')||' RETURNING rc_idruchupz,sc_id)
      SELECT COALESCE(q.sc_id,b.sc_id) AS sc_id,q.rc_idruchu,q.ilosc,q.prt_idpartiipz,q.prt_idpartiiwz,q.idnullpartii,q.rc_idruchuwz,q.mm_idmiejsca,q.tr_idtrans
      FROM q LEFT OUTER JOIN b ON (q.rc_idruchu=b.rc_idruchupz)'; 
 END IF;


----RAISE NOTICE '1';

 FOR r IN EXECUTE q	 
 LOOP
  _sc_id=r.sc_id;

 ---RAISE NOTICE 'SWP %',(clock_timestamp()-t);
 ---t=clock_timestamp();


  IF (_sc_id IS NULL) THEN
   _sc_id=gms.getIDSC(simid,r.rc_idruchu);
  END IF;

  INSERT INTO gms.tm_simwz
    (sc_id,
     rc_idruchupz,
     rc_idruchuwz,
     prt_idpartiipz,
     mm_idmiejscapz,
     swz_iloscrest_pnull,
     swz_iloscrest_p,
	 tr_idtrans
    )
  VALUES
    (_sc_id,
     r.rc_idruchu,
     r.rc_idruchuwz,
     r.prt_idpartiipz,
     r.mm_idmiejsca,
     (CASE WHEN r.prt_idpartiiwz IS NOT DISTINCT FROM r.idnullpartii THEN r.ilosc ELSE 0 END),
     (CASE WHEN r.prt_idpartiiwz IS DISTINCT FROM r.idnullpartii THEN r.ilosc ELSE 0 END),
	 r.tr_idtrans
    );     
 END LOOP;

 INSERT INTO gms.tm_idtouse (sc_simid,ttm_idtowmag,rc_idruchuwz_touse,suu_smietnik)
 SELECT simid,c.sc_idtowmag,a.rc_idruchuwz,false
 FROM gms.tm_simwz AS a
 JOIN gms.tm_simcoll AS c ON (c.sc_id=a.sc_id)
 WHERE c.sc_sid=vendo.tv_mysessionpid() AND c.sc_simid=simid;

 ---RAISE NOTICE 'SWLAST %',(clock_timestamp()-t);
        
 RETURN TRUE;
END;
$$;
