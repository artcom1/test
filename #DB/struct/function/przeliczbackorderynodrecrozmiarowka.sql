CREATE FUNCTION przeliczbackorderynodrecrozmiarowka(tr_nodrecrozmiarowka) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _nodrecrozmiarowka ALIAS FOR $1;
 
 _rec            RECORD;
 _data           DATE:=now();
 _zlecenie       INT;
 _rec_nodrec     RECORD;
 flaga_backorder INT;
 
 addnewbo        BOOLEAN;
 _ilosc          NUMERIC;
BEGIN

 SELECT 
 nodrec.knr_wplywmag, nodrec.kwh_idheadu, nodrec.tmg_idmagazynu, nodrec.knr_flaga, kwh.zl_idzlecenia,
 COALESCE(kwh_dataplanstop,kwh_datazak)::DATE AS data_plus,
 COALESCE(kwh_dataplanstart,kwh_datarozp)::DATE AS data_minus
 INTO _rec_nodrec
 FROM tr_nodrec AS nodrec 
 JOIN tr_kkwhead AS kwh ON (kwh.kwh_idheadu=nodrec.kwh_idheadu)
 WHERE knr_idelemu=_nodrecrozmiarowka.knr_idelemu;
   
  IF (_rec_nodrec.knr_flaga&(1<<15)=(1<<15)) THEN 
   RETURN -(1<<15);
  END IF;	
  
 addnewbo=TRUE;
 ---Wyzeruj backorder jesli zamkniete jest KKW 
 IF (_rec_nodrec.knr_flaga&4=4) THEN 
  addnewbo=FALSE; 
 END IF;
  
 IF (_rec_nodrec.knr_wplywmag=1) THEN 
  flaga_backorder=1; ----backorder plusowy
  _data=_rec_nodrec.data_plus;
 END IF;
 IF (_rec_nodrec.knr_wplywmag=-1) THEN 
  flaga_backorder=0;  ----backorder minusowy  
  _data=_rec_nodrec.data_minus;
 END IF;
  
 _zlecenie=_rec_nodrec.zl_idzlecenia;
  
 DELETE FROM tg_backorder WHERE bo_powod=3 and knr_idelemusrc=_nodrecrozmiarowka.knr_idelemu;
  
 IF (addnewbo) THEN
  FOR _rec IN 
  SELECT 
  knrr_idtowaru, 
  sum(COALESCE(knrr_iloscplan,0)) AS knrr_iloscplan, 
  sum(COALESCE(knrr_iloscrozch,0)) AS knrr_iloscrozch 
  FROM 
  (
    SELECT 
    unnest(_nodrecrozmiarowka.knrr_idtowaru) AS knrr_idtowaru, 
    unnest(_nodrecrozmiarowka.knrr_iloscplan) AS knrr_iloscplan, 
    unnest(_nodrecrozmiarowka.knrr_iloscrozch) AS knrr_iloscrozch
  ) AS t 
  GROUP BY knrr_idtowaru
  LOOP
   _ilosc=max(0,(NullZero(_rec.knrr_iloscplan)-NullZero(_rec.knrr_iloscrozch)));
   IF (_ilosc<>0) THEN
    PERFORM DodajBackOrderNodRec(_nodrecrozmiarowka.knr_idelemu,gettowmag(_rec.knrr_idtowaru,_rec_nodrec.tmg_idmagazynu,TRUE),_ilosc,3,flaga_backorder,_data,_zlecenie,0,0);
   END IF;  
  END LOOP;
 END IF;

 RETURN _nodrecrozmiarowka.knr_idelemu;
END;
$_$;
