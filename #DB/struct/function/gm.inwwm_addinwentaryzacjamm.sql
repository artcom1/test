CREATE FUNCTION inwwm_addinwentaryzacjamm(idtrans integer, idmiejsca integer, idpartiipz integer, deltailoscf numeric, iloscfcomp numeric DEFAULT NULL::numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 ineid INT;
 indid INT;
BEGIN
 
 IF (idmiejsca=0) THEN
  idmiejsca=NULL;
 END IF;

 ineid=(SELECT ine_id FROM tg_inwelems WHERE tr_idtrans=idtrans AND mm_idmiejsca IS NOT DISTINCT FROM idmiejsca FOR UPDATE);
 IF (ineid IS NULL) THEN
  INSERT INTO tg_inwelems 
  (
   tr_idtrans,mm_idmiejsca,
   ine_isinbuf
  ) VALUES (
   idtrans,idmiejsca,
   (SELECT tr_zamknieta&1=0 FROM tg_transakcje WHERE tr_idtrans=idtrans)
  );
  ineid=currval('tg_transelem_s');
 END IF;
 
 --- W sytuacji gdy chcemy tylko zeby byl rekord miejsca
 IF ((deltailoscf=0) AND (iloscfcomp IS NULL)) THEN
  RETURN NULL;
 END IF;


 IF (iloscfcomp IS NULL) THEN
  iloscfcomp=COALESCE((SELECT sum(r.rc_iloscpoz+r.rc_iloscwzbuf) 
                       FROM tg_ruchy AS r 
					   JOIN tg_magazyny AS mg ON (mg.tmg_idmagazynu=r.tmg_idmagazynu)
					   WHERE r.prt_idpartiipz=idpartiipz AND 
					         r.mm_idmiejsca IS NOT DISTINCT FROM idmiejsca AND 
							 isPZet(r.rc_flaga) AND 
							 r.rc_iloscpoz+r.rc_iloscwzbuf>0 AND
							 mg.fm_idcentrali=(SELECT fm_idcentrali FROM tg_transakcje WHERE tr_idtrans=idtrans) AND
							 (r.tmg_idmagazynu=(SELECT tmg_idmagazynu FROM tg_transakcje WHERE tr_idtrans=idtrans) OR
							  gm.hasMiejscaMagazynoweWspolne()=TRUE
							 )
					  ),0);
 END IF;

 indid=(SELECT ind_id FROM tg_inwdetails WHERE ine_id=ineid AND prt_idpartiipz=idpartiipz);
 IF (indid IS NULL) THEN
  
  INSERT INTO tg_inwdetails
   (ine_id,tr_idtrans,mm_idmiejsca,prt_idpartiipz,ttw_idtowaru,
    ind_iloscf_calc,ind_iloscf,
	ind_isinbuf)
  VALUES
   (ineid,idtrans,idmiejsca,idpartiipz,(SELECT ttw_idtowaru FROM tg_partie WHERE prt_idpartii=idpartiipz),
    COALESCE(iloscfcomp,0),deltailoscf,
	(SELECT tr_zamknieta&1=0 FROM tg_transakcje WHERE tr_idtrans=idtrans)
	);
	
  return currval('tg_transelem_s');
 END IF;
 

 --- Podbij ilosc standardowo 
 UPDATE tg_inwdetails 
 SET ind_iloscf=ind_iloscf+deltailoscf,
     ind_iloscf_calc=COALESCE(iloscfcomp,ind_iloscf_calc),
	 ind_updatecounter=(CASE WHEN deltailoscf!=0 THEN nextval('tg_inwdetails_upd') ELSE ind_updatecounter END),
	 ind_versioncounter=nextval('tg_inwdetails_upd')
 WHERE ind_id=indid AND (deltailoscf!=0 OR iloscfcomp IS NOT NULL);
 
 RETURN indid;
END;
$$;
