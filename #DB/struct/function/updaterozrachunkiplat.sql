CREATE FUNCTION updaterozrachunkiplat(_idplat integer, _idklienta integer, _idbanku integer, _kwotawal numeric, _kurs mpq, _idwaluty integer, _flaga integer, _wplyw integer, _data date, _forma integer, _fm_idcentrali integer, _kwotapln numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 restwal       NUMERIC;
 restpln       NUMERIC;
 tmpwal        NUMERIC;
 tmppln        NUMERIC;
 r             RECORD;
 wspwnma       INT:=1;
 wspznak       INT:=1;
 iswn          BOOL:=TRUE;
 hasanynormal  BOOL:=FALSE;
 id            INT;
 flag          INT:=0;
 _isnf         INT;
BEGIN
 restwal=_kwotawal;
 restpln=round(COALESCE(_kwotapln,_kwotawal*_kurs),2);

 _isnf=((_flaga>>29)&1);
 
 IF (_flaga&64=64) THEN
  restwal=0;
  restpln=0;
 END IF;

 IF (_wplyw>0) THEN
  wspwnma=-1;
  restwal=-restwal;
  restpln=-restpln;
  iswn=FALSE;
 END IF;

 ---- Wyznacz wspolczynnik znaku
 IF (restwal<0) THEN
  wspznak=-1;
  restwal=-restwal;
  restpln=-restpln;
 END IF; 
--- RAISE NOTICE 'Wsp % % %',restwal, wspwnma,wspznak;

 --- Poszukaj po aktualnych rozrachunkach
 FOR r IN SELECT * FROM kr_rozrachunki WHERE pl_idplatnosc=_idplat AND rr_flaga&7=0
 LOOP
  tmpwal=max(0,min(restwal,r.rr_kwotawal*wspznak));
  tmppln=floorRoundMax(tmpwal*_kurs,restpln);

  --- Biore wszystko
  IF (tmpwal=restwal) THEN
   tmppln=restpln;
  END IF;

  --- Usuwam
  IF (tmpwal=0) THEN
   DELETE FROM kr_rozrachunki WHERE rr_idrozrachunku=r.rr_idrozrachunku;
  ELSE
   hasanynormal=TRUE;

   IF (tmpwal<>r.rr_kwotawal*wspznak) OR 
      (tmppln<>r.rr_wartoscpln*wspznak) OR 
      (r.k_idklienta<>_idklienta) OR
      (r.rr_datadokumentu<>_data) OR
      (r.rr_formaplat IS DISTINCT FROM _forma) OR
      (r.rr_dataplatnosci<>_data) OR
      (r.rr_idwaluty<>_idwaluty) OR
	  (r.bk_idbanku IS DISTINCT FROM _idbanku) OR
	  (((r.rr_flaga>>28)&1)!=_isnf)
   THEN
    UPDATE kr_rozrachunki SET rr_kwotawal=tmpwal*wspznak,
                             rr_wartoscpln=tmppln*wspznak,
     rr_wartoscpozwal=rr_wartoscpozwal+(tmpwal*wspznak-rr_kwotawal),
     rr_wartoscpozpln=rr_wartoscpozpln+(tmppln*wspznak-rr_wartoscpln),
     k_idklienta=_idklienta,
     rr_datadokumentu=_data,
     rr_formaplat=_forma,
     rr_dataplatnosci=_data,
     rr_isbufor=false,
     rr_idwaluty=_idwaluty,
	 bk_idbanku=_idbanku
    WHERE rr_idrozrachunku=r.rr_idrozrachunku;
    PERFORM updatePlatFifoRR(r.rr_idrozrachunku,_idplat,tmpwal,tmppln,_idwaluty,(r.rr_flaga&(1<<22))<>0);
    PERFORM updateRozliczeniaRR(r.rr_idrozrachunku,tmpwal*wspznak,tmppln*wspznak,_kurs);
   END IF;
  END IF;

  restwal=restwal-tmpwal;
  restpln=restpln-tmppln;
 END LOOP;

 IF (restwal<>0) AND (hasanynormal) THEN
  FOR r IN SELECT * FROM kr_rozrachunki WHERE pl_idplatnosc=_idplat AND rr_flaga&7=0 ORDER BY rr_dataplatnosci DESC,rr_idrozrachunku DESC LIMIT 1
  LOOP
   tmpwal=max(0,restwal);
   tmppln=floorRoundMax(tmpwal*_kurs,restpln);

   --- Biore wszystko
   IF (tmpwal=restwal) THEN
    tmppln=restpln;
   END IF;

   UPDATE kr_rozrachunki SET rr_kwotawal=rr_kwotawal+tmpwal*wspznak,
                             rr_wartoscpln=rr_wartoscpln+tmppln*wspznak,
     rr_wartoscpozwal=rr_wartoscpozwal+tmpwal*wspznak,
     rr_wartoscpozpln=rr_wartoscpozpln+tmppln*wspznak,
     k_idklienta=_idklienta,
     rr_datadokumentu=_data,
     rr_formaplat=_forma,
	 bk_idbanku=_idbanku,
     rr_dataplatnosci=_data,
     rr_isbufor=false,
     rr_idwaluty=_idwaluty,
     rr_flaga=(rr_flaga&(~(1<<28))) | (_isnf<<28)				 
  WHERE rr_idrozrachunku=r.rr_idrozrachunku;
   PERFORM updatePlatFifoRR(r.rr_idrozrachunku,_idplat,r.rr_kwotawal*wspznak+tmpwal,r.rr_wartoscpln*wspznak+tmppln,_idwaluty,(r.rr_flaga&(1<<22))<>0);
   PERFORM updateRozliczeniaRR(r.rr_idrozrachunku,r.rr_kwotawal+tmpwal*wspznak,r.rr_wartoscpln+tmppln*wspznak,_kurs);
   restwal=restwal-tmpwal;
   restpln=restpln-tmppln;
  END LOOP;
 END IF;

 IF (restwal<>0) THEN
  id=nextval('kr_rozrachunki_s');

  IF ((SELECT bk_flaga&(64|256|512) FROM kh_platnosci JOIN ts_banki USING (bk_idbanku) WHERE pl_idplatnosc=_idplat)=64|256|512) THEN
   flag=flag|(1<<22);
  END IF;
  
  flag=flag|(_isnf<<28);
  
  INSERT INTO kr_rozrachunki 
   (rr_idrozrachunku,k_idklienta,pl_idplatnosc,rr_idwaluty,rr_kwotawal,rr_wartoscpln,rr_wartoscpozwal,rr_wartoscpozpln,rr_iswn,rr_isbufor,
    rr_isnormal,rr_datadokumentu,rr_dataplatnosci, fm_idcentrali,rr_flaga,rr_formaplat,
	bk_idbanku)
  VALUES
   (id,_idklienta,_idplat,_idwaluty,restwal*wspznak,restpln*wspznak,restwal*wspznak,restpln*wspznak,(wspwnma=1),false,
    true,_data,_data,_fm_idcentrali,flag,_forma,
	_idbanku);  

  IF ((flag&(1<<22))<>0) THEN
   PERFORM updatePlatFifoRR(id,_idplat,restwal,restpln,_idwaluty,TRUE);
   PERFORM updateRozliczeniaRR(id,restwal*wspznak,restpln*wspznak,_kurs);
  END IF;

  restwal=0;
  restpln=0;
 END IF;

 RETURN TRUE;
END;
$$;
