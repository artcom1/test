CREATE FUNCTION updaterozrachunkikompensaty(integer, integer, numeric, mpq, integer, integer, date, integer, boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
BEGIN
 IF ($3=0) AND ($9=FALSE) THEN
  DELETE FROM kr_rozrachunki WHERE pl_idplatnosc=$1 AND rr_flaga&7=5;
  RETURN 0;
 END IF;
 PERFORM updateRozrachunkiKompensaty($1,$2,$3,$4,$5,$6,$7,$8,TRUE,$9);
 PERFORM updateRozrachunkiKompensaty($1,$2,$3,$4,$5,$6,$7,$8,FALSE,$9);
 RETURN 0;
END
$_$;


--
--

CREATE FUNCTION updaterozrachunkikompensaty(integer, integer, numeric, mpq, integer, integer, date, integer, boolean, boolean) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idplat      ALIAS FOR $1;
 _idklienta   ALIAS FOR $2;
 wartoscwal  ALIAS FOR $3;
 _kurs        ALIAS FOR $4;
 _idwaluty    ALIAS FOR $5;
 _flaga       ALIAS FOR $6;
 _data        ALIAS FOR $7;
 _idcentrali  ALIAS FOR $8;
 _iswn        ALIAS FOR $9;
 _always      ALIAS FOR $10;
 r            RECORD;
 tmpwal       NUMERIC;
 tmppln       NUMERIC;
 hasany       BOOL:=false;
 wspznak      INT:=1;
 kurs         NUMERIC:=1;
 _wartoscwal  NUMERIC;
BEGIN

 _wartoscwal=wartoscwal;

 IF (_wartoscwal=0) AND (_always=FALSE) THEN
  DELETE FROM kr_rozrachunki WHERE pl_idplatnosc=_idplat AND rr_flaga&7=5;
  RETURN 0;
 END IF;

 IF (_iswn=FALSE) THEN
  wspznak=-1;
 END IF;

 IF (_wartoscwal<0) THEN
  wspznak=-wspznak;
  _wartoscwal=-_wartoscwal;
 END IF;

 tmpwal=max(0,_wartoscwal);

 FOR r IN SELECT * FROM kr_rozrachunki WHERE pl_idplatnosc=_idplat AND rr_flaga&7=5 AND rr_iswn=_iswn ORDER BY rr_idrozrachunku
 LOOP
  IF (r.rr_kwotawal=0) THEN
   kurs=1;
  ELSE
   kurs=round(r.rr_wartoscpln/r.rr_kwotawal,4);
  END IF;
  IF (tmpwal*wspznak=r.rr_kwotawal) THEN
   tmppln=r.rr_wartoscpln*wspznak;
  ELSE
   tmppln=floorRoundMax(tmpwal*kurs,round(tmpwal*kurs,2));
  END IF;
  
  IF (hasany=FALSE) THEN
   IF (tmpwal<>r.rr_kwotawal*wspznak) OR 
      (tmppln<>r.rr_wartoscpln*wspznak) OR 
      (r.k_idklienta<>_idklienta) OR
      (r.rr_datadokumentu<>_data) OR
      (r.rr_dataplatnosci<>_data) OR
      (r.rr_idwaluty<>_idwaluty)
   THEN
    UPDATE kr_rozrachunki SET rr_kwotawal=tmpwal*wspznak,
                              rr_wartoscpln=tmppln*wspznak,
                              rr_wartoscpozwal=rr_wartoscpozwal+(tmpwal*wspznak-rr_kwotawal),
                              rr_wartoscpozpln=rr_wartoscpozpln+(tmppln*wspznak-rr_wartoscpln),
                              k_idklienta=_idklienta,
                              rr_datadokumentu=_data,
                              rr_dataplatnosci=_data,
                              rr_isbufor=false,
                              rr_idwaluty=_idwaluty
    WHERE rr_idrozrachunku=r.rr_idrozrachunku;
    PERFORM updateRozliczeniaRR(r.rr_idrozrachunku,tmpwal*wspznak,tmppln*wspznak,_kurs);
   END IF;
  ELSE
   DELETE FROM kr_rozrachunki WHERE rr_idrozrachunku=r.rr_idrozrachunku;
  END IF;
  hasany=TRUE;
 END LOOP;

 IF (hasany=FALSE) THEN
  tmppln=floorRoundMax(tmpwal*kurs,round(tmpwal*kurs,2));

  INSERT INTO kr_rozrachunki 
   (k_idklienta,pl_idplatnosc,rr_idwaluty,rr_kwotawal,rr_wartoscpln,rr_wartoscpozwal,rr_wartoscpozpln,rr_iswn,rr_isbufor,rr_isnormal,rr_datadokumentu,rr_dataplatnosci, fm_idcentrali,rr_flaga)
  VALUES
   (_idklienta,_idplat,_idwaluty,tmpwal*wspznak,tmppln*wspznak,tmpwal*wspznak,tmppln*wspznak,_iswn,false,true,_data,_data,_idcentrali,5);
 END IF;

 RETURN 0;
END
$_$;
