CREATE FUNCTION dodajapz(_idelem integer, _idtex integer, _idmiejsca integer, _idpartii integer, _idpaletymrp integer, _ilosc numeric, _checkerr boolean, _checknerr boolean DEFAULT true) RETURNS integer
    LANGUAGE plpgsql
    AS $$
---WSPOK
---Uwaga: IDPaletyMRP = NULL oznacza ze jest nam wszystko jedno jaka paleta bedzie przy updatach, a przy insercie dodajemy NULLowa
---                     0 oznacza ze paleta musi byc NULLowa
DECLARE
 ret        INT;
 tmp        NUMERIC;
 rr         RECORD;
 rec        RECORD;
 pozostalo  NUMERIC;
 anypaleta  BOOL:=TRUE;
BEGIN
 pozostalo=_ilosc;

 IF (_idpaletymrp=0) THEN
  _idpaletymrp=NULL;
  anypaleta=FALSE;
 END IF;
 IF (_idpaletymrp IS NOT NULL) THEN
  anypaleta=FALSE;
 END IF;
 
 FOR rec IN SELECT ex.tex_idelem,
                   COALESCE((CASE WHEN _idtex IS NULL THEN ex.tex_iloscf ELSE NULL END),_ilosc) AS ilosc,
		           COALESCE(ex.prt_idpartii,_idpartii) AS idpartii
                   FROM (SELECT _idelem AS tel_idelem,_idtex AS tex_idelem) AS a 
	               LEFT OUTER JOIN tg_teex AS ex USING (tel_idelem,tex_idelem) 
	               ORDER BY tex_idelem
 LOOP
  IF (_checkerr=TRUE) THEN

   --Ilosc pozostala ewentualnie do zawizowania
   IF (rec.tex_idelem IS NULL) THEN
    tmp=(SELECT tel_iloscf-nullZero((SELECT sum(rc_iloscpoz) FROM tg_ruchy AS r WHERE r.tel_idelem=te.tel_idelem AND (isPZet(rc_flaga) OR isAPZet(rc_flaga)) )) FROM tg_transelem AS te WHERE te.tel_idelem=_idelem);
   ELSE
    tmp=(SELECT tex_iloscf-nullZero((SELECT sum(rc_iloscpoz) FROM tg_ruchy AS r WHERE r.tex_idelem=te.tex_idelem AND (isPZet(rc_flaga) OR isAPZet(rc_flaga)) )) FROM tg_teex AS te WHERE te.tex_idelem=rec.tex_idelem);
   END IF;

   IF (tmp<0) THEN
    ---Jest nawet za duzo teraz - zwroc blad
    RAISE EXCEPTION 'Ilosc aktualna jest za duza o %',-tmp;
   END IF;
   
   ---Minimalna ilosc do zawizowania
   _ilosc=min(pozostalo,tmp);
   ---Oblicz pozostalosc
   pozostalo=pozostalo-_ilosc;
  END IF;

  CONTINUE WHEN _ilosc<=0;

  ----RAISE NOTICE 'Pozostalo % ',pozostalo;
 
  SELECT * INTO rr FROM tg_ruchy AS rt WHERE rt.tel_idelem=_idelem AND 
                                             rt.tex_idelem IS NOT DISTINCT FROM rec.tex_idelem AND
                                             rt.ttm_idtowmag=(SELECT ttm_idtowmag FROM tg_transelem WHERE tel_idelem=_idelem) AND
					                        (rt.rc_flaga&6)=4 AND
					                         prt_idpartiipz=rec.idpartii AND
                         				    rt.mm_idmiejsca IS NOT DISTINCT FROM _idmiejsca AND
											(anypaleta=TRUE OR (rt.mrpp_idpalety IS NOT DISTINCT FROM _idpaletymrp))
											LIMIT 1;
  IF (rr.rc_idruchu IS NOT NULL) THEN
   UPDATE tg_ruchy SET rc_ilosc=rc_ilosc+_ilosc,
 		               rc_iloscpoz=rc_iloscpoz+_ilosc
		           WHERE rc_idruchu=rr.rc_idruchu;
 
   ret=rr.rc_idruchu;
  ELSE
 
   INSERT INTO tg_ruchy 
    (tel_idelem,
	 tr_idtrans,
	 ttw_idtowaru,
	 ttm_idtowmag,
	 tmg_idmagazynu,
	 rc_data,
	 rc_ilosc,rc_iloscpoz,
	 rc_flaga,
	 rc_wartosc,rc_wartoscpoz,
	 k_idklienta,rc_kierunek,
     mm_idmiejsca,
	 prt_idpartiipz,
	 mrpp_idpalety,
	 tex_idelem
	) 
   VALUES 
    (_idelem,
     (SELECT tr_idtrans FROM tg_transelem WHERE tel_idelem=_idelem),
     (SELECT ttw_idtowaru FROM tg_transelem WHERE tel_idelem=_idelem),
     (SELECT ttm_idtowmag FROM tg_transelem WHERE tel_idelem=_idelem),
     (SELECT tmg_idmagazynu FROM tg_transelem JOIN tg_towmag USING (ttm_idtowmag) WHERE tel_idelem=_idelem),
     (SELECT tr_datasprzedaz FROM tg_transelem JOIN tg_transakcje USING (tr_idtrans) WHERE tel_idelem=_idelem),
      round(_ilosc,4),round(_ilosc,4),
      gm.addMRPPaletaSafeFlag(4),
	  0,0,
     (SELECT tel_idklienta FROM tg_transelem WHERE tel_idelem=_idelem),1,
     _idmiejsca,
     rec.idpartii,
	 _idpaletymrp,
     rec.tex_idelem
     ); 

   ret=(SELECT currval('tg_ruchy_s'));
  END IF;
 END LOOP;

 IF (pozostalo>0) AND (_checknerr=TRUE) THEN
  RAISE EXCEPTION 'Ilosc do dodania jest za duza o % ',pozostalo;
 END IF;

 UPDATE tg_transelem SET tel_newflaga=tel_newflaga|(1<<24) WHERE tel_idelem=_idelem;

 RETURN ret; 
END;$$;
