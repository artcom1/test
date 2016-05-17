CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _nodrec ALIAS FOR $1;
 
 _rec_kkw     RECORD;
 
 _rec            RECORD;
 _data           DATE:=now();
 _zlecenie       INT;
 flaga_backorder INT;
 
 addnewbo        BOOLEAN;
 _ilosc          NUMERIC;
BEGIN

 SELECT 
 kwh.zl_idzlecenia,
 COALESCE(kwh_dataplanstop,kwh_datazak)::DATE AS data_plus,
 COALESCE(kwh_dataplanstart,kwh_datarozp)::DATE AS data_minus
 INTO _rec_kkw
 FROM tr_kkwhead AS kwh
 WHERE kwh_idheadu=_nodrec.kwh_idheadu;
   
  IF (_nodrec.knr_flaga&((1<<12)|(1<<15))=(1<<12)) THEN 
   RETURN -(1<<12); -- Nodreca rozmiarowki nie obsluguje
  END IF;	
  
 addnewbo=TRUE;
 ---Wyzeruj backorder jesli zamkniete jest KKW 
 IF (_nodrec.knr_flaga&4=4) THEN 
  addnewbo=FALSE; 
 END IF;
  
 IF (_nodrec.knr_wplywmag=1) THEN 
  flaga_backorder=1; ----backorder plusowy
  _data=_rec_kkw.data_plus;
 END IF;
 IF (_nodrec.knr_wplywmag=-1) THEN 
  flaga_backorder=0;  ----backorder minusowy  
  _data=_rec_kkw.data_minus;
 END IF;
  
 _zlecenie=_rec_kkw.zl_idzlecenia;
  
 DELETE FROM tg_backorder WHERE bo_powod=3 AND knr_idelemusrc=_nodrec.knr_idelemu;
 
 IF (addnewbo) THEN
  _ilosc=max(_nodrec.knr_iloscplan-_nodrec.knr_iloscrozch,0);
  PERFORM DodajBackOrderNodRec(_nodrec.knr_idelemu,_nodrec.ttm_idtowmag,_ilosc,3,flaga_backorder,_data,_zlecenie,_nodrec.knr_flaga,_nodrec.tmg_idmagazynu); 
 END IF;
 
 RETURN _nodrec.knr_idelemu;
END;
$_$;
