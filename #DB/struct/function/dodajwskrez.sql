CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
 _iloscf ALIAS FOR $2;
 r RECORD;
 te RECORD;
 iloscpoz NUMERIC;
 tmp NUMERIC;
 tmpi INT;
 iloscbezflagi NUMERIC:=0;
BEGIN
 iloscpoz=_iloscf;

 IF (iloscpoz=0) THEN
  DELETE FROM tg_ruchy WHERE isRezerwacja(rc_flaga) AND rc_seqid IN (SELECT wr_rezid FROM tg_wskrez WHERE tel_idelem_inw=_idelem);
  DELETE FROM tg_wskrez WHERE tel_idelem_inw=_idelem;
  RETURN TRUE;
 END IF;

 FOR r IN SELECT wr_ilosc_inw FROM tg_wskrez WHERE tel_idelem_inw=_idelem
 LOOP
  iloscpoz=iloscpoz-r.wr_ilosc_inw;
 END LOOP;

 IF (iloscpoz<0) THEN
  RAISE EXCEPTION 'Nie mozna w ten sposob modyfikowac inwentaryzacji z partiami!';
 END IF;

 IF (iloscpoz>0) THEN
  SELECT ttm_idtowmag INTO te FROM tg_transelem WHERE tel_idelem=_idelem;

  FOR r IN SELECT * FROM (
           SELECT rr.rc_idruchu,
	          rr.rc_iloscpoz-COALESCE((SELECT sum(wr_ilosc_inw) FROM tg_wskrez AS w WHERE w.rc_idruchupz=rr.rc_idruchu),0) AS maxile, 
		      ozn.rc_idruchu AS rc_idruchuozn
           FROM tg_ruchy AS rr
           LEFT OUTER JOIN gm.tv_oznaczoneruchy_top AS ozn ON (ozn.rc_idruchu=rr.rc_idruchu)
	   WHERE rr.rc_iloscpoz>0 AND isPZet(rr.rc_flaga) AND rr.ttm_idtowmag=te.ttm_idtowmag
	   ) AS a WHERE maxile>0 
	   ORDER BY (rc_idruchuozn IS NOT NULL) DESC
  LOOP
   IF (r.rc_idruchuozn IS NOT NULL) THEN
    tmp=min(iloscpoz,r.maxile);
    IF (tmp>0) THEN
     tmpi=(SELECT wr_idwsk FROM tg_wskrez WHERE tel_idelem_inw=_idelem AND rc_idruchupz=r.rc_idruchu);
     IF (tmpi IS NULL) THEN
      INSERT INTO tg_wskrez
       (rc_idruchupz,tel_idelem_inw,wr_ilosc_inw)
      VALUES
       (r.rc_idruchu,_idelem,tmp);
     ELSE
      UPDATE tg_wskrez SET wr_ilosc_inw=wr_ilosc_inw+tmp WHERE wr_idwsk=tmpi;
     END IF;
     iloscpoz=iloscpoz-tmp;
    END IF;
   ELSE
    iloscbezflagi=iloscbezflagi+max(0,r.maxile);
   END IF;
  END LOOP;
 END IF;

 ----iloscpoz=iloscpoz-COALESCE((SELECT sum(wr_ilosc_inw) FROM tg_wskrez WHERE tel_idelem_inw=_idelem AND rc_idruchupz IS NULL AND wr_priorytet=851),0);
 
 
 IF (iloscpoz>0) THEN
---  IF (iloscbezflagi>0) THEN
   RAISE EXCEPTION 'Nie wskazano partii do zinwentaryzowania % %',iloscpoz,_idelem;
---  END IF;
 END IF;

 RETURN TRUE;
END;
$_$;
