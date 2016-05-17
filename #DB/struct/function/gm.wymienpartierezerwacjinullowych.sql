CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r1 tg_ruchy;
 r2 tg_ruchy;
BEGIN

 SELECT * INTO r1 FROM tg_ruchy WHERE rc_idruchu=idruchurez1;
 SELECT * INTO r2 FROM tg_ruchy WHERE rc_idruchu=idruchurez2;

 IF (r1.rc_idruchu IS NULL OR r2.rc_idruchu IS NULL) THEN
  RAISE EXCEPTION 'Nie ma ktoregos z ruchow rezerwacji';
 END IF;
 
 UPDATE tg_partietm SET ptm_stanmag=ptm_stanmag+ilosc WHERE prt_idpartii=r1.prt_idpartiipz AND ttm_idtowmag=r1.ttm_idtowmag;
 
 PERFORM gm.zmienpartiepzdlarezerwacjilekkiej(NULL,idruchurez2,r1.prt_idpartiipz,ilosc);
 PERFORM gm.zmienpartiepzdlarezerwacjilekkiej(NULL,idruchurez1,r2.prt_idpartiipz,ilosc);
 
 UPDATE tg_partietm SET ptm_stanmag=ptm_stanmag-ilosc WHERE prt_idpartii=r1.prt_idpartiipz AND ttm_idtowmag=r1.ttm_idtowmag;
 
 RETURN ilosc; 
END
$$;
