CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelzapisu ALIAS FOR $1;
 _idkonta    ALIAS FOR $2;
 _idklienta  ALIAS FOR $3;
 _kwotawal   ALIAS FOR $4;
 _iswn       ALIAS FOR $5;
 _datadok    ALIAS FOR $6;
 _dataplato  ALIAS FOR $7;
 _idwaluty   ALIAS FOR $8;
 _kurswal    ALIAS FOR $9;
 _kwotapln   ALIAS FOR $10;
 restwal       NUMERIC;
 restpln       NUMERIC;
 tmpwal        NUMERIC;
 tmppln        NUMERIC;
 r             RECORD;
 wspznak       INT:=1;
 iswn          BOOL:=TRUE;
 hasanynormal  BOOL:=FALSE;
 iswspolny     BOOL:=FALSE;
 _dataplat     DATE;
BEGIN
 restwal=_kwotawal;
 restpln=_kwotapln;
 iswn=_iswn;
 _dataplat=COALESCE(_dataplato,_datadok);
 
 IF (_iswn=FALSE) THEN
  restwal=-restwal;
  restpln=-restpln;
 END IF;

 ---- Wyznacz wspolczynnik znaku
 IF (restwal<0) THEN
  wspznak=-1;
  restwal=-restwal;
  restpln=-restpln;
 END IF;

 --- Poszukaj po aktualnych rozrachunkach
 FOR r IN SELECT * FROM kr_rozrachunki WHERE zp_idelzapisu=_idelzapisu AND rr_flaga&7 IN (0,3,5) AND rr_iswn=_iswn
 LOOP
  IF ((r.rr_flaga>>7)&79<>0) THEN
   tmpwal=r.rr_kwotawal*wspznak;
   tmppln=r.rr_wartoscpln*wspznak;
   iswspolny=TRUE;

   IF (r.k_idklienta<>_idklienta) THEN
    RAISE EXCEPTION '28|%:%:%|Nie mozna zmienic klienta',_idelzapisu,r.k_idklienta,_idklienta;
   END IF;

   IF  (r.kt_idkonta<>_idkonta) OR (r.rr_idwaluty<>_idwaluty)
    THEN
     UPDATE kr_rozrachunki SET kt_idkonta=_idkonta
      WHERE rr_idrozrachunku=r.rr_idrozrachunku;
   END IF;
  ELSE
   tmpwal=max(0,min(restwal,r.rr_kwotawal*wspznak));
   tmppln=max(0,min(restpln,r.rr_wartoscpln*wspznak));

   IF (tmpwal=restwal) THEN
    tmppln=restpln;
   END IF;

   --- Usuwam
   IF (tmpwal=0) THEN
    RAISE NOTICE 'Usuwam rekord ';
    DELETE FROM kr_rozrachunki WHERE rr_idrozrachunku=r.rr_idrozrachunku;
   ELSE
    hasanynormal=TRUE;

    IF (tmpwal<>r.rr_kwotawal*wspznak) OR 
       (tmppln<>r.rr_wartoscpln*wspznak) OR
       (r.kt_idkonta<>_idkonta) OR
       (r.k_idklienta<>_idklienta) OR
       (r.rr_datadokumentu<>_datadok) OR
       (r.rr_dataplatnosci<>_dataplat) OR
       (r.rr_idwaluty<>_idwaluty)
    THEN
     UPDATE kr_rozrachunki SET rr_kwotawal=tmpwal*wspznak,
                               rr_wartoscpln=tmppln*wspznak,
          rr_wartoscpozwal=rr_wartoscpozwal+(tmpwal*wspznak-rr_kwotawal),
         rr_wartoscpozpln=rr_wartoscpozpln+(tmppln*wspznak-rr_wartoscpln),
       kt_idkonta=_idkonta,
       k_idklienta=_idklienta,
       rr_idwaluty=_idwaluty,
       rr_isbufor=false,
       rr_datadokumentu=(CASE WHEN rr_flaga&1920=0 THEN _datadok ELSE rr_datadokumentu END),
                      rr_dataplatnosci=(CASE WHEN rr_flaga&1920=0 THEN _dataplat ELSE rr_dataplatnosci END)
  WHERE rr_idrozrachunku=r.rr_idrozrachunku;
     PERFORM updateRozliczeniaRR(r.rr_idrozrachunku,tmpwal*wspznak,tmppln*wspznak,1);
    END IF;
   END IF;
  END IF;

  restwal=restwal-tmpwal;
  restpln=restpln-tmppln;
 END LOOP;


 IF (iswspolny=TRUE) THEN
  RETURN TRUE;
  RAISE EXCEPTION 'Blad przy rozrachunkach KH-M-F';
 END IF;

 IF ((restwal<>0) OR (restpln<>0)) AND (hasanynormal) THEN
  FOR r IN SELECT * FROM kr_rozrachunki WHERE zp_idelzapisu=_idelzapisu AND rr_flaga&7=0 AND rr_iswn=_iswn ORDER BY rr_dataplatnosci DESC,rr_idrozrachunku DESC LIMIT 1
  LOOP
   tmpwal=max(0,restwal);
   tmppln=max(0,restpln);

   UPDATE kr_rozrachunki SET rr_kwotawal=rr_kwotawal+tmpwal*wspznak,
                             rr_wartoscpln=rr_wartoscpln+tmppln*wspznak,
     rr_wartoscpozwal=rr_wartoscpozwal+tmpwal*wspznak,
     rr_wartoscpozpln=rr_wartoscpozpln+tmppln*wspznak,
     kt_idkonta=_idkonta,
     k_idklienta=_idklienta,
     rr_idwaluty=_idwaluty,
     rr_isbufor=false,
      rr_datadokumentu=(CASE WHEN rr_flaga&1920=0 THEN _datadok ELSE rr_datadokumentu END),
                     rr_dataplatnosci=(CASE WHEN rr_flaga&1920=0 THEN _dataplat ELSE rr_dataplatnosci END)
  WHERE rr_idrozrachunku=r.rr_idrozrachunku;

   PERFORM updateRozliczeniaRR(r.rr_idrozrachunku,r.rr_kwotawal+tmpwal*wspznak,r.rr_wartoscpln+tmppln*wspznak,1);
   restwal=restwal-tmpwal;
  END LOOP;
 END IF;

 IF (restwal<>0) THEN

  INSERT INTO kr_rozrachunki 
   (k_idklienta,zp_idelzapisu,kt_idkonta,rr_idwaluty,rr_kwotawal,rr_wartoscpln,rr_wartoscpozwal,rr_wartoscpozpln,rr_iswn,rr_isbufor,rr_isnormal,rr_datadokumentu,rr_dataplatnosci, fm_idcentrali)
  VALUES
   (_idklienta,_idelzapisu,_idkonta,_idwaluty,restwal*wspznak,restpln*wspznak,restwal*wspznak,restpln*wspznak,iswn,false,true,_datadok,_dataplat,(SELECT fm_idcentrali FROM kh_lata JOIN kh_konta USING (ro_idroku) WHERE kt_idkonta=_idkonta));

  restwal=0;
  restpln=0;
 END IF;

 RETURN TRUE;
END;
$_$;
