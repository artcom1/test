CREATE FUNCTION searchforrezerwacje(_nadmiar numeric, _r public.tg_ruchy, idrezerwacjionly integer DEFAULT NULL::integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
 nadmiar     NUMERIC:=_nadmiar;
 -----
 ruch_data   tg_ruchy;
 q           TEXT;
 -----
 t_ile       NUMERIC;
 ilemax      NUMERIC;
 doloop      BOOL:=TRUE;
 tmp         NUMERIC;
 whereparams INT;
BEGIN
 
 IF (_nadmiar<=0) THEN
  RETURN 0;
 END IF;

 IF (COALESCE(vendo.getTParam('BLOCKREZSEARCH'),'0')<>'0') AND (idrezerwacjionly IS NULL) THEN
  RETURN _nadmiar;
 END IF;


/*
 ilemax=(SELECT ttm_stan-ttm_rezerwacja FROM tg_towmag WHERE ttm_idtowmag=_r.ttm_idtowmag FOR UPDATE);

 _nadmiar=min(_nadmiar,ilemax);

 IF (_nadmiar<=0) THEN
  RETURN 0;
 END IF;
 */

 
 --- W zasadzie nadmiar powinien byc wiekszy od 0
 q='SELECT r.*
    FROM tg_ruchy AS r ---- Rezerwacja
    LEFT OUTER JOIN tg_partie AS ppz ON (ppz.prt_idpartii='||COALESCE(_r.prt_idpartiipz,-1)||') ---Wskazana partia
    LEFT OUTER JOIN tg_wskrez AS wr ON (wr.tel_idelem_fv=r.tel_idelem)                          ---WskRez
    LEFT OUTER JOIN tg_partie AS pwz ON (pwz.prt_idpartii=r.prt_idpartiiwz)                     ---Partia PZ
    JOIN tg_towary AS tw ON (tw.ttw_idtowaru=r.ttw_idtowaru)                                    ---Towar
    WHERE (r.ttm_idtowmag='||_r.ttm_idtowmag||') AND
          isRezerwacja(r.rc_flaga) AND
		  r.rc_idruchu=COALESCE('||tostringnull(idrezerwacjionly)||',r.rc_idruchu) AND
          (wr.tel_idelem_pz='||COALESCE(_r.tel_idelem,-1)||' OR wr.tel_idelem_pz IS NULL) AND
	   rc_ilosc-rc_iloscpoz>0 AND 
	  (gm.comparePartie(ppz,pwz,tw.ttw_whereparams,TRUE)>0)
      ORDER BY wr_priorytet ASC,gm.comparePartie(ppz,pwz,tw.ttw_whereparams,TRUE) DESC,r.rc_seqid ASC,r.rc_idruchu ASC';
 WHILE (doloop=TRUE) AND (nadmiar>0)
 LOOP
  doloop=FALSE;

  ilemax=(SELECT ptm_stanmag-ptm_rezerwacje-ptm_rezerwacjel FROM tg_partietm WHERE ttm_idtowmag=_r.ttm_idtowmag AND prt_idpartii=_r.prt_idpartiipz FOR UPDATE);

  CONTINUE WHEN ilemax IS NULL OR ilemax<=0;

---  RAISE NOTICE 'Moge maksymalnie % dla %',ilemax,_r.prt_idpartiipz;

  FOR ruch_data IN EXECUTE q
  LOOP
   t_ile=round(max(min(nadmiar,ruch_data.rc_ilosc-ruch_data.rc_iloscpoz),0),4);
  ---RAISE NOTICE 'Przejmuje ja % % (% %)',t_ile,ilemax,_r.ttm_idtowmag,_r.prt_idpartiipz;

   t_ile=min(t_ile,ilemax);

   CONTINUE WHEN t_ile<=0;
   EXIT WHEN nadmiar<=0;



   IF ((ruch_data.rc_flaga&(1<<24))<>0) THEN   --Rezerwacja lekka
    nadmiar=round(nadmiar-t_ile,4);
    PERFORM gm.skojarzPZzRezerwacjaLekka(t_ile,ruch_data,_r.prt_idpartiipz);
    CONTINUE;
   END IF;

   IF (_r.rc_idruchu IS NULL) THEN
    tmp=gm.findPZetsForRezerwacja(t_ile,ruch_data::tg_ruchy);
    IF (tmp<>0) THEN
     nadmiar=nadmiar-tmp;
     doloop=TRUE;
     EXIT;
    END IF;
    CONTINUE;
   END IF;

   IF (whereparams IS NULL) THEN
    whereparams=(SELECT ttw_whereparams FROM tg_towary WHERE ttw_idtowaru=_r.ttw_idtowaru);
   END IF;

   IF (gm.isFullPartiaOnly(whereparams,ruch_data.rc_idruchu)=TRUE) THEN
    IF (t_ile<>_nadmiar) OR (t_ile<>_r.rc_iloscpoz) OR (t_ile<>ruch_data.rc_ilosc-ruch_data.rc_iloscpoz) THEN
     CONTINUE;
    END IF;
   END IF;

   nadmiar=round(nadmiar-gm.skojarzPZzRezerwacja(t_ile,_r,ruch_data),4);
  END LOOP;
 END LOOP;

 RETURN nadmiar;
END;
$$;
