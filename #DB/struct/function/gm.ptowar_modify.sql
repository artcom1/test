CREATE FUNCTION ptowar_modify(idtowaru integer, idmagazynu integer, stan numeric, wartosc numeric, rezerwacje numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
BEGIN

  SELECT tm.ttm_idtowmag,tw.ttw_idtowaru INTO r
  FROM tg_towary AS tw
  LEFT OUTER JOIN tg_towmag AS tm ON (tm.ttw_idtowaru=tw.ttw_idtowaru AND tm.tmg_idmagazynu=idmagazynu)
  WHERE tw.ttw_idtowaru=idtowaru AND tw.ttw_rtowaru=(1<<8)
  LIMIT 1;

  IF (r.ttw_idtowaru IS NULL) THEN
   RETURN NULL;
  END IF;
  
  IF (r.ttm_idtowmag=NULL) THEN
   INSERT INTO tg_towmag
    (ttw_idtowaru,tmg_idmagazynu,
 	 ttm_stan,ttm_wartosc,ttm_rezerwacja
	)
   VALUES
    (idtowaru,idmagazynu,
	 COALESCE(stan,0),COALESCE(wartosc,0),COALESCE(rezerwacje,0)
	);
	
   RETURN currval('tg_towmag_s');
  END IF;
  
  UPDATE tg_towmag SET
   ttm_stan=COALESCE(stan,ttm_stan),
   ttm_wartosc=COALESCE(wartosc,ttm_wartosc),
   ttm_rezerwacja=COALESCE(rezerwacje,ttm_rezerwacja)
  WHERE ttm_idtowmag=r.ttm_idtowmag AND 
        (
         ttm_stan IS DISTINCT FROM COALESCE(stan,ttm_stan) OR
         ttm_wartosc IS DISTINCT FROM COALESCE(wartosc,ttm_wartosc) OR
         ttm_rezerwacja IS DISTINCT FROM COALESCE(rezerwacje,ttm_rezerwacja)
		);

 RETURN r.ttm_idtowmag;
END;
$$;
