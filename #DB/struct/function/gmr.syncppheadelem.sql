CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
 d RECORD;
 plocal tg_partie;
 idpartiipz INT;
 idpartiipz_bezsppak INT;
 reccount INT:=0;
BEGIN
 SELECT * INTO d FROM tg_ppheadelem WHERE phe_idheadelemu=idheadelemu;

 IF (idsposobu IS NOT NULL) THEN
  --Skasuj elementy bez sposobu pakowania
  DELETE FROM tg_ppheadelem WHERE phe_ref=idheadelemu AND rmp_idsposobu IS NULL;
  
  FOR r IN SELECT elems.phe_idheadelemu,
                  pak.rmk_idelemu,
				  pak.ttw_idtowaru_pdx,
				  pak.rmk_przelicznik,
				  elems.phe_wplyw,
				  elems.prt_idpartiiplusnosspak_fromref,
				  tes.tel_idelem
           FROM (
 		    SELECT * FROM tg_ppheadelem as e WHERE e.phe_ref=idheadelemu
		   ) AS elems
		   FULL JOIN
		   (
 		    SELECT * FROM tg_rozmsppakelems as s WHERE s.rmp_idsposobu=idsposobu
		   ) as pak ON (pak.ttw_idtowaru_pdx=elems.ttw_idtowaru AND pak.rmp_idsposobu=elems.rmp_idsposobu)
		   LEFT OUTER JOIN
		   (
		    SELECT te.tel_idelem,te.ttw_idtowaru,te.rmp_idsposobu FROM tg_transelem AS te WHERE te.tel_skojzestaw IS NOT NULL AND te.tel_skojzestaw=d.tel_idelemsrcskoj
		   ) AS tes ON (tes.ttw_idtowaru=pak.ttw_idtowaru_pdx AND tes.rmp_idsposobu=pak.rmp_idsposobu)
		   ORDER BY (pak.rmk_idelemu IS NULL) DESC,elems.ttw_idtowaru,pak.ttw_idtowaru_pdx
  LOOP 
   reccount=reccount+1;
   ---RAISE NOTICE 'ID %=>% (%,%)',d.tel_idelemsrcskoj,r.tel_idelem,r.ttw_idtowaru_pdx,idsposobu;
   IF (r.prt_idpartiiplusnosspak_fromref IS DISTINCT FROM d.prt_idpartiiplus_nosppak) THEN
    IF (r.phe_idheadelemu IS NOT NULL) THEN
	 DELETE FROM tg_ppheadelem WHERE phe_idheadelemu=r.phe_idheadelemu;
	 r.phe_idheadelemu=NULL;
	END IF;
   END IF;
   ---------------------------------------------------------------------------------------------------
   IF (r.phe_idheadelemu IS NOT NULL) THEN
    --Albo trzeba zupdatowac rekord albo go usunac - w zaleznosci od sposobu pakowania
    IF (r.rmk_idelemu IS NULL) THEN
     DELETE FROM tg_ppheadelem WHERE phe_idheadelemu=r.phe_idheadelemu;
     CONTINUE WHEN TRUE;
    END IF;
   
    UPDATE tg_ppheadelem
    SET phe_iloscop=iloscop,
        phe_iloscopdone=iloscopdone,
        tel_idelemsrcskoj=r.tel_idelem		
    WHERE phe_idheadelemu=r.phe_idheadelemu AND
          (
 		   phe_iloscop IS DISTINCT FROM iloscop OR
		   phe_iloscopdone IS DISTINCT FROM iloscopdone OR
		   tel_idelemsrcskoj IS DISTINCT FROM r.tel_idelem
		  );
		 
    CONTINUE WHEN TRUE;		 
   END IF;  
  
   IF (d.phe_wplyw<0) THEN
    SELECT * INTO plocal FROM tg_partie AS p WHERE p.prt_idpartii=d.prt_idpartiiplus;
    idpartiipz=(gmr.findOrCreatePartiaLikeOther(plocal,r.ttw_idtowaru_pdx,false)).prt_idpartii;
    ---Pozbadz sie z aprtii sposobu pakowania
    plocal.rmp_idsposobu=NULL;
    idpartiipz_bezsppak=(gmr.findOrCreatePartiaLikeOther(plocal,r.ttw_idtowaru_pdx,true)).prt_idpartii;
   ELSE
    SELECT * INTO plocal FROM tg_partie AS p WHERE p.prt_idpartii=d.prt_idpartiiplus_nosppak;
    idpartiipz_bezsppak=(gmr.findOrCreatePartiaLikeOther(plocal,r.ttw_idtowaru_pdx,true)).prt_idpartii;
	plocal.rmp_idsposobu=idsposobu;
    idpartiipz=(gmr.findOrCreatePartiaLikeOther(plocal,r.ttw_idtowaru_pdx,true)).prt_idpartii;   
   END IF;
   
   INSERT INTO tg_ppheadelem
    (
      pph_idheadu,phe_ref,tr_idtrans,
	  ttw_idtowaru,ttw_idtowarundx,
 	  phe_wplyw,
	  prt_idpartiiplus,
	  prt_idpartiiplus_nosppak,
	  rmp_idsposobu,
	  phe_iloscop,phe_mnoznik,
	  phe_iloscopdone,
	  prt_idpartiiplusnosspak_fromref,
	  tel_idelemsrcskoj
    )
   VALUES
   (
     d.pph_idheadu,idheadelemu,d.tr_idtrans,
	 r.ttw_idtowaru_pdx,d.ttw_idtowarundx,
	 d.phe_wplyw,
	 ---(SELECT (gmr.findOrCreatePartiaLikeOther(p,r.ttw_idtowaru_pdx,false)).prt_idpartii FROM tg_partie AS p WHERE p.prt_idpartii=d.prt_idpartiiplus),	
	 idpartiipz,
	 idpartiipz_bezsppak,
	 idsposobu,
	 iloscop,r.rmk_przelicznik,
	 iloscopdone,
	 d.prt_idpartiiplusnosspak_fromref,
	 r.tel_idelem
    );
  
  END LOOP;
  
  RETURN TRUE;
 END IF;
 
 --Skasuj te rekordy gdzie jest sposob pakowania
 DELETE FROM tg_ppheadelem WHERE phe_ref=idheadelemu AND rmp_idsposobu IS NOT NULL;
  
 SELECT * INTO r FROM tg_ppheadelem WHERE phe_ref=idheadelemu;
  
 IF (r.prt_idpartiiplusnosspak_fromref IS DISTINCT FROM d.prt_idpartiiplus_nosppak) THEN
  IF (r.phe_idheadelemu IS NOT NULL) THEN
   DELETE FROM tg_ppheadelem WHERE phe_idheadelemu=r.phe_idheadelemu;
   r.phe_idheadelemu=NULL;
  END IF;
 END IF;
  
 IF (r.phe_idheadelemu IS NOT NULL) THEN
  UPDATE tg_ppheadelem
  SET phe_iloscop=iloscop,
      phe_iloscopdone=iloscopdone   
  WHERE phe_idheadelemu=r.phe_idheadelemu AND
       (
   	    phe_iloscop IS DISTINCT FROM iloscop OR
		phe_iloscopdone IS DISTINCT FROM iloscopdone
	   );
  RETURN TRUE;	   
 END IF;
  
 INSERT INTO tg_ppheadelem
 (
   pph_idheadu,phe_ref,tr_idtrans,
   ttw_idtowaru,ttw_idtowarundx,
   phe_wplyw,
   prt_idpartiiplus,
   prt_idpartiiplus_nosppak,
   rmp_idsposobu,
   phe_iloscop,phe_mnoznik,
   phe_iloscopdone,
   prt_idpartiiplusnosspak_fromref
 )
 VALUES
 (
  d.pph_idheadu,idheadelemu,d.tr_idtrans,
  d.ttw_idtowaru,d.ttw_idtowarundx,
  d.phe_wplyw,
  d.prt_idpartiiplus_nosppak,
  d.prt_idpartiiplus_nosppak,
  NULL,
  iloscop,1,
  iloscopdone,
  d.prt_idpartiiplusnosspak_fromref
 ); 
 
 RETURN TRUE;
END;
$$;
