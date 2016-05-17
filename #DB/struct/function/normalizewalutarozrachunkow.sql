CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans       ALIAS FOR $1;
 _idplat        ALIAS FOR $2;
 _idwalutynew   ALIAS FOR $3;
 _wartoscwalnew ALIAS FOR $4;
 _kursnew       ALIAS FOR $5;
 _iswn          ALIAS FOR $6;
 r RECORD;
 restwal        NUMERIC;
 restpln        NUMERIC;
 tmpwal         NUMERIC;
 tmppln         NUMERIC;
 wsp            INT:=1;
 lastid         INT;
BEGIN
 restwal=_wartoscwalnew;
 restpln=round(restwal*_kursnew,2);

 IF (_iswn=FALSE) THEN
  wsp=-wsp;
 END IF;

 FOR r IN SELECT * FROM kr_rozrachunki WHERE (tr_idtrans=COALESCE(_idtrans,-1) OR pl_idplatnosc=COALESCE(_idplat,-1)) AND rr_flaga&7 IN (0,1,2,4) AND rr_iswn=_iswn ORDER BY rr_flaga&(1<<20) DESC,rr_dataplatnosci ASC,rr_idrozrachunku ASC
 LOOP
  IF (r.rr_idwaluty<>_idwalutynew) THEN
   IF (r.rr_flaga&7 IN (4)) THEN
    RAISE EXCEPTION '20|%|Nie mozna zmieniac waluty na dokumencie z rozliczeniami faktur zaliczkowych',_idtrans;
   END IF;
   IF (r.rr_wartoscpozpln<>r.rr_wartoscpln) THEN
    IF (_idtrans IS NOT NULL) THEN
     RAISE EXCEPTION '21|%|Dokument czesciowo rozliczony',_idtrans;
    ELSE
     RAISE EXCEPTION '22|%|Platnosc czesciowo rozliczona',_idplat;
    END IF;
   END IF;
   tmppln=floorRoundMax(r.rr_wartoscpln*wsp,restpln);
   tmpwal=floorRoundMax(tmppln/_kursnew,restwal);
   tmppln=floorRoundMax(tmpwal*_kursnew,restpln);
   lastid=r.rr_idrozrachunku;


   UPDATE kr_rozrachunki SET rr_kwotawal=tmpwal*wsp,
                             rr_wartoscpln=tmppln*wsp,
			     rr_wartoscpozwal=tmpwal*wsp,
			     rr_wartoscpozpln=tmppln*wsp,
			     rr_idwaluty=_idwalutynew
 			 WHERE rr_idrozrachunku=r.rr_idrozrachunku;
  ELSE
   tmppln=r.rr_wartoscpln;
   tmpwal=r.rr_kwotawal;
  END IF;
  restwal=restwal-tmpwal;
  restpln=restpln-tmppln;
 END LOOP;

 IF (restwal<>0 OR restpln<>0) THEN
  UPDATE kr_rozrachunki SET rr_kwotawal=rr_kwotawal+restwal*wsp,
                            rr_wartoscpln=rr_wartoscpln+restpln*wsp,
	                    rr_wartoscpozwal=rr_wartoscpozwal+restwal*wsp,
		            rr_wartoscpozpln=rr_wartoscpozpln+restpln*wsp
 			 WHERE rr_idrozrachunku=lastid;
 END IF;

 RETURN TRUE;
END; $_$;
