CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r RECORD;
 s RECORD;
BEGIN

 FOR r IN SELECT * 
          FROM (
		   select *,coalesce((SELECT sum(rc_ilosc-rc_iloscpoz) AS ilosc FROM tg_ruchy where isrezerwacja(rc_flaga) and tg_ruchy.ttm_idtowmag=tg_partietm.ttm_idtowmag),0) AS ilosc 
		   from tg_partietm 
		   where ptm_stanmag > ptm_rezerwacje+ptm_rezerwacjel AND ttm_idtowmag=idtowmag
		  ) AS a where ilosc>0
 LOOP
  RAISE NOTICE 'TowMag % ',r.ttm_idtowmag;
  
  FOR s IN SELECT rc_idruchu FROM tg_ruchy AS rr WHERE isPZet(rc_flaga) AND rc_iloscpoz>rc_iloscrez AND ttm_idtowmag=r.ttm_idtowmag
  LOOP
   RAISE NOTICE 'Update PZ %',s.rc_idruchu;
   
   UPDATE tg_ruchy SET rc_flaga=rc_flaga|20148 WHERE rc_idruchu=s.rc_idruchu AND isPZet(rc_flaga);
   UPDATE tg_ruchy SET rc_flaga=rc_flaga&(~20148) WHERE rc_idruchu=s.rc_idruchu AND isPZet(rc_flaga);
   
  END LOOP; 
  
 END LOOP; 

 RETURN TRUE;
END;
$$;
