CREATE FUNCTION updaterozrachunkitrans(_idtrans integer, _idklienta integer, _idbanku integer, _kwotawal numeric, _kurs mpq, _idwaluty integer, _zamknieta integer, _flaga integer, _newflaga integer, _datadok date, _dataplatn date, _formaplat integer, _iszaliczkowa boolean, _fm_idcentrali integer, _rrno integer, _wartoscpln numeric DEFAULT NULL::numeric, _wartoscwalfn numeric DEFAULT NULL::numeric) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 _isnormal       BOOL;
 _iskorekta      BOOL;
 _isnf           int;
 restwal         NUMERIC;
 restwalfn       NUMERIC;
 restpln         NUMERIC;
 tmpwal          NUMERIC;
 tmppln          NUMERIC;
 tmpwalfn        NUMERIC;
 r               RECORD;
 wspwnma         INT:=1;
 wspznak         INT:=1;
 iswn            BOOL:=TRUE;
 hasanynormal    BOOL:=FALSE;
 flag            INT:=0;
 rozliczonowal   NUMERIC:=0;
 rozliczonowalfn NUMERIC:=0;
 tmp             NUMERIC;
 fullwalfn       NUMERIC;
 fullwal         NUMERIC;
BEGIN 
 restwal=_kwotawal;
 restwalfn=COALESCE(_wartoscwalfn,restwal); --- Wartosc dla normalizacji
 restpln=COALESCE(_wartoscpln,round(_kwotawal*_kurs,2));

 IF (_wartoscpln IS NOT NULL) AND (_kwotawal<>0) THEN
  _kurs=calckurswaluty(_wartoscpln,_kwotawal,_idwaluty);
 END IF;
 
 ---RAISE NOTICE 'Robie update dla % i % (No %)',_kwotawal,restwalfn,_rrno;

 _iskorekta=(_zamknieta&4=4);
 _isnormal=(_zamknieta&64=64);
 _isnf=((_newflaga>>24)&1);
 
 ---- Wyznacz wspolczynnik WnMa
 IF (_flaga&512=0) THEN
  wspwnma=-1;
  restwal=-restwal;
  restwalfn=-restwalfn;
  restpln=-restpln;
  iswn=FALSE;
 END IF;
 
 IF ((_newflaga&(1<<21))!=0) THEN
  wspwnma=-wspwnma;
  restwal=-restwal;
  restwalfn=-restwalfn;
  restpln=-restpln;
  iswn=NOT iswn;
 END IF;

 IF (_iszaliczkowa) THEN
  wspwnma=-wspwnma;
  restwal=-restwal;
  restwalfn=-restwalfn;
  restpln=-restpln;
  iswn=NOT iswn;
  IF (_iskorekta=FALSE) OR (_kwotawal>0) THEN
   flag=flag|1;
  ELSE
   flag=flag|2;
  END IF;
 END IF;
 
 ---- Wyznacz wspolczynnik znaku
 IF (restwal<0) THEN
  wspznak=-1;
  restwal=-restwal;
  restwalfn=-restwalfn;
  restpln=-restpln;
 END IF;
 
 flag=flag|(_isnf<<28);

 rozliczonowal=nullZero((SELECT sum(rr_kwotawal-rr_wartoscpozwal)*wspznak FROM kr_rozrachunki WHERE tr_idtrans=_idtrans AND rr_no=_rrno AND rr_flaga&7 IN (0,1,2,4) AND rr_iswn=iswn));
 restwal=restwal-rozliczonowal;

 IF (restwal<0) OR (_kwotawal=0 AND rozliczonowal<>0) THEN
  restwal=abs(restwal);
  restwalfn=abs(restwalfn);
  RAISE EXCEPTION '16|%:%|Za duzo rozliczono w stosunku do zadanej wartosci!',_idtrans,restwal;
 END IF;

 fullwalfn=restwalfn;
 fullwal=restwal+rozliczonowal;
 
 --- Poszukaj po aktualnych rozrachunkach
 FOR r IN SELECT * 
          FROM kr_rozrachunki 
		  WHERE tr_idtrans=_idtrans AND rr_no=_rrno AND rr_flaga&7 IN (0,1,2,4) AND rr_iswn=iswn AND rr_isnormal=_isnormal 
		  ORDER BY rr_flaga&(1<<20) DESC,rr_dataplatnosci ASC,rr_idrozrachunku ASC
		  FOR UPDATE
 LOOP
  --- Tyle mam teraz
  tmpwal=r.rr_kwotawal*wspznak;
  --- Odejmij to co mam rozliczone
  tmpwal=tmpwal-(r.rr_kwotawal-r.rr_wartoscpozwal)*wspznak;
  --- Tyle powinienem zostawic (minimum z tego co zostalo i kwoty aktualnej)
  tmpwal=max(0,min(restwal,tmpwal));
  --- Dodaj to co rozliczone
  tmpwal=tmpwal+(r.rr_kwotawal-r.rr_wartoscpozwal)*wspznak;
  tmp=tmpwal;
  tmppln=floorRoundMax(tmpwal*_kurs,restpln);
  
  ---Oblicz wartosc dla normalizacji z proporcji
  IF (fullwal!=0) THEN
   tmpwalfn=floorRoundMax(tmpwal*fullwalfn/fullwal,restwalfn);
  ELSE
   tmpwalfn=0;
  END IF;  

  ----RAISE NOTICE 'Zmieniam na %*%/%',tmpwal,r.rr_kwotawalfornorm,r.rr_kwotawal;
  
  --Nie zmienila sie wartosc w walucie to nie zmieniaj tez w zlotowkach
  ---IF (tmpwal*wspznak=r.rr_kwotawal) THEN
  --- tmppln=floatroundmax(r.rr_wartoscpln*wspznak,restpln);
  ----END IF;

  --- Biore wszystko
  IF (tmpwal=restwal+rozliczonowal) THEN  
   tmppln=restpln;
   tmpwalfn=restwalfn; --- Dla ostatniego rekordu bierzemy wszystko
  END IF;
  
  ---RAISE NOTICE 'Update na % i %',tmpwal,tmpwalfn;
	
  --- Usuwam
  IF (tmpwal=0) THEN
   ---RAISE NOTICE 'Kasuje % (Flag % kwota %)',r.rr_idrozrachunku,r.rr_flaga&(1<<20),r.rr_kwotawal;
   DELETE FROM kr_rozrachunki WHERE rr_idrozrachunku=r.rr_idrozrachunku;
  ELSE
   hasanynormal=TRUE;

   IF (tmpwal<>r.rr_kwotawal*wspznak) OR 
      (tmppln<>r.rr_wartoscpln*wspznak) OR 
	  (tmpwalfn<>r.rr_kwotawalfornorm*wspznak) OR
      ((r.rr_flaga&16=0) AND (r.k_idklienta IS DISTINCT FROM _idklienta)) OR
	  ((r.rr_flaga&(1<<27)=0) AND (r.bk_idbanku IS DISTINCT FROM _idbanku)) OR
      (r.rr_datadokumentu<>_datadok) OR
      ((r.rr_flaga&32=0) AND (r.rr_dataplatnosci<>_dataplatn)) OR
      ((r.rr_flaga&(1<<26)=0) AND (r.rr_formaplat IS DISTINCT FROM _formaplat)) OR
      ((_zamknieta&1=0)<>r.rr_isbufor) OR 
      (r.rr_idwaluty<>_idwaluty) OR
	  (((r.rr_flaga>>28)&1)!=_isnf)
   THEN
    ----RAISE EXCEPTION 'Mam cos do zmiany % %',tmpwalfn,wspznak;
    UPDATE kr_rozrachunki SET rr_kwotawal=tmpwal*wspznak,
	                          rr_kwotawalfornorm=tmpwalfn*wspznak,
                              rr_wartoscpln=tmppln*wspznak,
			                  rr_wartoscpozwal=rr_wartoscpozwal+(tmpwal*wspznak-rr_kwotawal),
			                  rr_wartoscpozpln=rr_wartoscpozpln+(tmppln*wspznak-rr_wartoscpln),
			                  k_idklienta=(CASE WHEN rr_flaga&16=0 THEN _idklienta ELSE k_idklienta END),
			                  rr_datadokumentu=_datadok,
			                  rr_dataplatnosci=(CASE WHEN rr_flaga&32=0 THEN _dataplatn ELSE rr_dataplatnosci END),
			                  rr_formaplat=(CASE WHEN rr_flaga&(1<<26)=0 THEN _formaplat ELSE rr_formaplat END),
							  bk_idbanku=(CASE WHEN rr_flaga&(1<<27)=0 THEN _idbanku ELSE bk_idbanku END),
			                  rr_isbufor=(_zamknieta&1=0),
			                  rr_idwaluty=_idwaluty,
							  rr_flaga=(rr_flaga&(~(1<<28))) | (_isnf<<28)
 	WHERE rr_idrozrachunku=r.rr_idrozrachunku;
	
    PERFORM updateRozliczeniaRR(r.rr_idrozrachunku,tmpwal*wspznak,tmppln*wspznak,_kurs);
   END IF;
  END IF;

  restwal=restwal-(tmpwal-(r.rr_kwotawal-r.rr_wartoscpozwal)*wspznak);
  restwalfn=restwalfn-tmpwalfn;
  restpln=restpln-tmppln;
  rozliczonowal=rozliczonowal-(r.rr_kwotawal-r.rr_wartoscpozwal)*wspznak;
 END LOOP;

 IF (restwal<>0) AND (hasanynormal) THEN
  FOR r IN SELECT * 
           FROM kr_rozrachunki 
		   WHERE tr_idtrans=_idtrans AND rr_no=_rrno AND rr_flaga&7 IN (0,1,2) AND rr_iswn=iswn AND rr_isnormal=_isnormal 
		   ORDER BY rr_flaga&(1<<20) ASC,rr_dataplatnosci DESC,rr_idrozrachunku DESC 
		   LIMIT 1
		   FOR UPDATE
  LOOP
   tmpwal=max(0,restwal);
   tmpwalfn=max(0,restwalfn);
   tmppln=floorRoundMax(tmpwal*_kurs,restpln);

  IF (fullwal!=0) THEN   
   tmpwalfn=floorRoundMax((r.rr_kwotawal*wspznak+tmpwal)*fullwalfn/fullwal,restwalfn);
  ELSE
   tmpwalfn=0;
  END IF;
   
   ----RAISE NOTICE 'Robie % % (g: %)',tmpwal,tmpwalfn,_wartoscwalfn;

   --- Biore wszystko
   IF (tmpwal=restwal) THEN
    tmppln=restpln;
	tmpwalfn=restwalfn;
   END IF;

    ---RAISE EXCEPTION 'Mam cos do zmiany %+%*%',rr_kwotawalfornorm,tmpwalfn,wspznak;
   UPDATE kr_rozrachunki SET rr_kwotawal=rr_kwotawal+tmpwal*wspznak,
                             rr_kwotawalfornorm=rr_kwotawalfornorm+tmpwalfn*wspznak,
                             rr_wartoscpln=rr_wartoscpln+tmppln*wspznak,
			     rr_wartoscpozwal=rr_wartoscpozwal+tmpwal*wspznak,
			     rr_wartoscpozpln=rr_wartoscpozpln+tmppln*wspznak,
			     k_idklienta=(CASE WHEN rr_flaga&16=0 THEN _idklienta ELSE k_idklienta END),
			     rr_datadokumentu=_datadok,
			     rr_dataplatnosci=(CASE WHEN rr_flaga&32=0 THEN _dataplatn ELSE rr_dataplatnosci END),
			     rr_formaplat=(CASE WHEN rr_flaga&(1<<26)=0 THEN _formaplat ELSE rr_formaplat END),
   			     bk_idbanku=(CASE WHEN rr_flaga&(1<<27)=0 THEN _idbanku ELSE bk_idbanku END),
			     rr_isbufor=(_zamknieta&1=0),
			     rr_idwaluty=_idwaluty,
 			     rr_flaga=(rr_flaga&(~(1<<28))) | (_isnf<<28)				 
 			 WHERE rr_idrozrachunku=r.rr_idrozrachunku;

   PERFORM updateRozliczeniaRR(r.rr_idrozrachunku,r.rr_kwotawal+tmpwal*wspznak,r.rr_wartoscpln+tmppln*wspznak,_kurs);

   restwal=restwal-tmpwal;
   restwalfn=restwalfn-tmpwalfn;
   restpln=restpln-tmppln;
  END LOOP;
 END IF;

 IF (restwal<>0) THEN

  INSERT INTO kr_rozrachunki 
   (k_idklienta,tr_idtrans,rr_idwaluty,rr_kwotawal,rr_wartoscpln,rr_wartoscpozwal,rr_wartoscpozpln,rr_iswn,rr_isbufor,
    rr_isnormal,rr_datadokumentu,rr_dataplatnosci,rr_flaga, fm_idcentrali,rr_no,rr_formaplat,rr_kwotawalfornorm,
	bk_idbanku)
  VALUES
   (_idklienta,_idtrans,_idwaluty,restwal*wspznak,restpln*wspznak,restwal*wspznak,restpln*wspznak,iswn,(_zamknieta&1=0),
    _isnormal,_datadok,_dataplatn,flag,_fm_idcentrali,_rrno,_formaplat,restwalfn*wspznak,
	_idbanku);
  restwal=0;
  restpln=0;
  restwalfn=0;
 END IF;

 RETURN TRUE;
END
$$;
