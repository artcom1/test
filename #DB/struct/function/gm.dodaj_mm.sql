CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
---WRTOK
DECLARE 
 _idelem     ALIAS FOR $1;
 _idtrans    ALIAS FOR $2;
 _idtowmag   ALIAS FOR $3;
 _idmag      ALIAS FOR $4;
 _data       ALIAS FOR $5;
 _idsk       ALIAS FOR $6;
 _doclear    ALIAS FOR $7;
 _wartosctow ALIAS FOR $8;      ----- Wartosc towaru do przyjecia 
 _idpartii   ALIAS FOR $9;

 ruch_data RECORD;
 ruch_datac RECORD;
 ruch_datao RECORD;
 wartosczakupu NUMERIC:=0;

 wartoscpoz NUMERIC:=0;
 iloscpoz NUMERIC:=0;
 tmp NUMERIC;
 flag INT:=0;
BEGIN

 /* --------Sprawdz istniejace---------------------------------------------- */

 SELECT sum(r.rc_ilosc) AS ip,sum(r.rc_wartosc) AS wp,count(*) AS ile,sum(r.rc_wspwartosci) AS swsp
 INTO ruch_datac 
 FROM tg_ruchy AS r
 WHERE r.tel_idelem=_idelem AND isPZet(r.rc_flaga);
 
 SELECT sum(r.rc_ilosc) AS ip,sum(r.rc_wartosc) AS wp,count(*) AS ile,sum(r.rc_wspwartosci) AS swsp 
 INTO ruch_datao 
 FROM tg_ruchy AS r 
 WHERE r.tel_idelem=_idsk;

 --RAISE NOTICE 'MMP: % % % ',ruch_datac.ip,ruch_datac.wp,ruch_datac.ile;
 --RAISE NOTICE 'MMM: % % % ',ruch_datao.ip,ruch_datao.wp,ruch_datao.ile;

 IF (ruch_datac.ip=ruch_datao.ip) AND 
    (
     ((_wartosctow IS NULL) AND (ruch_datac.wp=ruch_datao.wp)) OR
     ((_wartosctow IS NOT NULL) AND (ruch_datac.wp=_wartosctow))
    ) AND 
    (ruch_datac.ile=ruch_datao.ile) AND 
	(ruch_datac.swsp=ruch_datao.swsp) AND
    (ruch_datac.ile<>0) 
 THEN
  ---RAISE EXCEPTION 'Jest rowne % % dla %',ruch_datac,ruch_datao,_idelem;
  RETURN ruch_datac.wp;
 END IF;

 IF (_doclear=TRUE) THEN
  DELETE FROM tg_ruchy WHERE isPZet(rc_flaga) AND tel_idelem=_idelem;
 END IF;

 wartoscpoz=_wartosctow;
 iloscpoz=ruch_datao.ip;

 FOR ruch_data IN 
  SELECT r.ttw_idtowaru,r.rc_iloscpoz,r.rc_wartoscpoz,
         r.rc_dostawa,pz.rc_dataop,r.rc_seqid,
	     r.rc_idruchu AS rc_idruchum,rp.rc_idruchu AS rc_idruchup,
		 COALESCE(((r.rc_ilosc=rp.rc_ilosc) AND (r.rc_wartosc=rp.rc_wartosc)),false) AS iseq,
		 r.prt_idpartiipzpz,pz.rc_flaga AS rc_flagapz,
		 r.rc_wspwartosci AS rc_wspwartoscim,rp.rc_wspwartosci AS rc_wspwartoscip,
		 r.mrpp_idpaletym AS mrpp_idpaletym,
		 rp.mrpp_idpalety AS mrpp_idpaletyp
  FROM (
	SELECT ri.*,pz.prt_idpartiipz AS prt_idpartiipzpz,pz.mrpp_idpalety AS mrpp_idpaletym
	FROM tg_ruchy AS ri 
	JOIN tg_ruchy AS pz ON (pz.rc_idruchu=ri.rc_ruch AND isPZet(pz.rc_flaga)) 
	WHERE ri.tel_idelem=_idsk AND isFV(ri.rc_flaga)
  ) AS r 
  FULL JOIN (
	SELECT rpi.* 
	FROM tg_ruchy AS rpi 
	WHERE rpi.tel_idelem=_idelem AND isPZet(rpi.rc_flaga)
  ) AS rp 
  ON (rp.rc_seqid=r.rc_seqid AND rp.prt_idpartiipz=r.prt_idpartiipzpz)
  LEFT OUTER JOIN tg_ruchy AS pz ON (pz.rc_idruchu=r.rc_dostawa) 
  ORDER BY r.rc_idruchu
 LOOP
 
  IF (ruch_data.rc_idruchum IS NULL) THEN
   ----RAISE NOTICE 'Kasuje ';
   DELETE FROM tg_ruchy WHERE rc_idruchu=ruch_data.rc_idruchup;
   CONTINUE;
  END IF;
  
  IF (ruch_data.rc_wspwartoscim!=COALESCE(ruch_data.rc_wspwartoscip,ruch_data.rc_wspwartoscim)) THEN
   RAISE EXCEPTION 'Blad wspolczynnikow wartosci na MM-/MM+';
  END IF;
  
  IF (ruch_data.rc_idruchup IS NOT NULL) AND (ruch_data.mrpp_idpaletyp IS DISTINCT FROM ruch_data.mrpp_idpaletym) THEN
   RAISE EXCEPTION '54|%|Blad palety w obrebie MMki',ruch_data.rc_idruchup;
  END IF;
  
  IF (ruch_data.iseq=TRUE) AND (_wartosctow IS NULL) THEN
   ---RAISE NOTICE 'Pozostawiam';
   wartosczakupu=wartosczakupu+ruch_data.rc_wartoscpoz;
   --Dodano Pozniej
   iloscpoz=iloscpoz-ruch_data.rc_iloscpoz;
   wartoscpoz=wartoscpoz-ruch_data.rc_wartoscpoz;
   CONTINUE;
  END IF;
  
  IF (ruch_data.rc_iloscpoz=iloscpoz) THEN
   tmp=wartoscpoz;
  ELSE
   tmp=floorRoundMax(ruch_data.rc_iloscpoz*_wartosctow/ruch_datao.ip,wartoscpoz);
  END IF;

  iloscpoz=iloscpoz-ruch_data.rc_iloscpoz;
  wartoscpoz=wartoscpoz-tmp;

  --Sproboj zaktualizowac wartosc
  IF ((ruch_data.rc_idruchup IS NOT NULL) AND (_wartosctow IS NOT NULL)) THEN
   PERFORM zmianaNaPZRuch(ruch_data.rc_idruchup,ruch_data.rc_iloscpoz,tmp,FALSE);
   wartosczakupu=wartosczakupu+tmp;
   CONTINUE;
  END IF;

  ---RAISE NOTICE '%',ruch_data;
  
  --Kasujemy ewentualny stary
  DELETE FROM tg_ruchy WHERE rc_idruchu=ruch_data.rc_idruchup;
   
  ---Ew. flagi ze zrodla
  flag=(ruch_data.rc_flagapz&(1<<29));       --- Informacja o pochodzeniu z konsygnaty
  
  INSERT INTO tg_ruchy 
   (
    tel_idelem,tr_idtrans,
    ttw_idtowaru,ttm_idtowmag,tmg_idmagazynu,
    rc_data,
    rc_ilosc,rc_iloscpoz,
    rc_flaga,
    rc_wartosc,rc_wartoscpoz,
    rc_kierunek,
    rc_dostawa,
    rc_dataop,rc_seqid,
    prt_idpartiipz,
	mrpp_idpalety
   ) VALUES 
   (
    _idelem,_idtrans,
    ruch_data.ttw_idtowaru,_idtowmag,_idmag,
    _data,
    round(ruch_data.rc_iloscpoz,4),round(ruch_data.rc_iloscpoz,4),
    gm.addMRPPaletaSafeFlag(2|flag),
    round(COALESCE(tmp,ruch_data.rc_wartoscpoz),6),round(COALESCE(tmp,ruch_data.rc_wartoscpoz),6),
    1,
    ruch_data.rc_dostawa,
    ruch_data.rc_dataop,ruch_data.rc_seqid,
    COALESCE(_idpartii,ruch_data.prt_idpartiipzpz),
	ruch_data.mrpp_idpaletym
   ); 

  wartosczakupu=wartosczakupu+COALESCE(tmp,ruch_data.rc_wartoscpoz);
 END LOOP;

 DELETE FROM tg_ruchy WHERE isAPZet(rc_flaga) AND tel_idelem=_idelem;
 
 if (_doclear=FALSE) THEN
  RETURN gm.dodaj_mm( $1,$2,$3,$4,$5,$6,TRUE,_wartosctow);
 END IF;
 
 RETURN wartosczakupu;
END; $_$;
