CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 retcount INT:=0;
 r        RECORD;
 q        TEXT;
BEGIN
 ---- Skasuj niepotrzebne elementy
 FOR r IN SELECT pze.pzw_idelemu
          FROM gmr.tg_planzleceniarozmelems AS pze
		  LEFT OUTER JOIN tg_rozmsppakelems AS e ON (e.ttw_idtowaru_pdx=pze.ttw_idtowaru_pdx AND e.rmp_idsposobu=idsposobu AND e.rmp_idsposobu=pze.rmp_idsposobu)
		  WHERE pze.pz_idplanu=idplanu AND e.rmp_idsposobu IS NULL
 LOOP
  DELETE FROM gmr.tg_planzleceniarozmelems WHERE pzw_idelemu=r.pzw_idelemu;
 END LOOP; 
 
 
 ----1. Wez elementy sposobu pakowania
 ----2. Dolacz elementy rozmiarowki planu zlecenia po towar+plan+sposob pakowania
 ----3. Dolacz transelemy po skojzestaw+towar+sposob pakowania
 q = 'SELECT pze.pzw_idelemu,
                 e.ttw_idtowaru_pdx AS ttw_idtowaru_pdx_e,e.rmk_przelicznik AS rmk_przelicznik_e,
                 te.tel_idelem AS tel_idelem_te
          FROM tg_rozmsppakelems AS e
		  LEFT OUTER JOIN gmr.tg_planzleceniarozmelems AS pze ON (e.ttw_idtowaru_pdx=pze.ttw_idtowaru_pdx AND pze.pz_idplanu='||toStringNULL(idplanu)||' AND pze.rmp_idsposobu='||toStringNull(idsposobu)||')
		  LEFT OUTER JOIN tg_transelem AS te ON (te.tel_skojzestaw IS NOT NULL AND 
		                                         te.tel_skojzestaw='||toStringNull(idsrcelem)||' AND 
												 '||toStringNULL(idsrcelem)||' IS NOT NULL AND 
												 te.ttw_idtowaru=e.ttw_idtowaru_pdx )
		  WHERE e.rmp_idsposobu='||toStringNull(idsposobu);
 
 ----RAISE NOTICE '%',q;
 /*
 FOR r IN SELECT pze.pzw_idelemu,
                 e.ttw_idtowaru_pdx AS ttw_idtowaru_pdx_e,e.rmk_przelicznik AS rmk_przelicznik_e,
                 te.tel_idelem AS tel_idelem_te
          FROM gmr.tg_planzleceniarozmelems AS pze
		  FULL JOIN tg_rozmsppakelems AS e ON (e.ttw_idtowaru_pdx=pze.ttw_idtowaru_pdx AND e.rmp_idsposobu=idsposobu)
		  FULL JOIN tg_transelem AS te ON (te.tel_skojzestaw IS NOT NULL AND te.tel_skojzestaw=idsrcelem AND idsrcelem IS NOT NULL AND te.ttw_idtowaru=e.ttw_idtowaru_pdx)
		  WHERE pze.pz_idplanu=idplanu
		  */
 FOR r IN EXECUTE q		  
 LOOP
 
  IF (idsrcelem IS NOT NULL AND r.tel_idelem_te IS NULL) THEN
   RAISE EXCEPTION 'Nie znalazlem transelemu dla elementu rozmiarowki planu zlecenia';
  END IF;
  
  IF (r.pzw_idelemu IS NULL) THEN
   IF (idsrcelem IS NOT NULL) THEN
    IF (r.tel_idelem_te IS NULL) THEN
	 RAISE EXCEPTION 'Blad przy laczeniu planu zlecenia z elementami rozmiarowki na transelemie';
	END IF;
   END IF;   
  
   INSERT INTO gmr.tg_planzleceniarozmelems
    (pz_idplanu,pzw_iloscop,
	 rmp_idsposobu,ttw_idtowaru_pdx,
     tel_idsrcelem,
     pzw_mnoznikop
	)	 
   VALUES
    (
	 idplanu,iloscop,
	 idsposobu,r.ttw_idtowaru_pdx_e,
	 r.tel_idelem_te,
	 r.rmk_przelicznik_e
	);
   retcount=retcount+1;
   CONTINUE WHEN TRUE;
  END IF;
  
  ------------------------------------------------------------------------------------------------------------------------------------------------
  UPDATE gmr.tg_planzleceniarozmelems
  SET
    pzw_iloscop=iloscop,
	rmp_idsposobu=idsposobu,
	ttw_idtowaru_pdx=r.ttw_idtowaru_pdx_e,
	tel_idsrcelem=r.tel_idelem_te,
	pzw_mnoznikop=r.rmk_przelicznik_e
  WHERE
   pzw_idelemu=r.pzw_idelemu AND
   (
    pzw_iloscop IS DISTINCT FROM iloscop OR
	rmp_idsposobu IS DISTINCT FROM idsposobu OR
	ttw_idtowaru_pdx IS DISTINCT FROM r.ttw_idtowaru_pdx_e OR
	tel_idsrcelem IS DISTINCT FROM r.tel_idelem_te OR
	pzw_mnoznikop IS DISTINCT FROM r.rmk_przelicznik_e
   );
   
   retcount=retcount+1;
 END LOOP; 
 
  
 RETURN retcount;
END;
$$;
