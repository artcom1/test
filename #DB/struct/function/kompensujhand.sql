CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _korekta ALIAS FOR $1;
 _fv ALIAS FOR $2;
 _ilosckor ALIAS FOR $3;
 _newflaga ALIAS FOR $4;
 ilosc NUMERIC:=0;
 ilosctmp NUMERIC;
 d RECORD;
BEGIN
 
 IF (_korekta=NULL) THEN
  RETURN 0;
 END IF;

 IF (_ilosckor*TEwspIlosci(_newflaga)>=0) THEN
  DELETE FROM tb_kompensatyhand WHERE kh_idkorekty=_korekta;
  RETURN 0;
 END IF;

 ilosc=-_ilosckor*TEwspIlosci(_newflaga);

 ---Sprawdz po istniejacych
 FOR d IN SELECT * FROM tb_kompensatyhand WHERE kh_idkorekty=_korekta
 LOOP
  ilosctmp=min(ilosc,d.kh_ilosc*TEwspIlosci(_newflaga));
  ----RAISE NOTICE 'Mam ilosctmp % i % oraz %',ilosctmp,d.kh_ilosc,_ilosckor;
  IF (ilosctmp=0) THEN
   DELETE FROM tb_kompensatyhand WHERE kh_idkompensaty=d.kh_idkompensaty;
  ELSE
   IF (ilosctmp<d.kh_ilosc*TEwspIlosci(_newflaga)) THEN
    UPDATE tb_kompensatyhand SET kh_ilosc=ilosctmp*TEwspIlosci(_newflaga) WHERE kh_idkompensaty=d.kh_idkompensaty;
   END IF;
  END IF;
  ilosc=ilosc-ilosctmp;
 END LOOP;

 ----RAISE NOTICE 'Pozostalo % ',ilosc;

 IF (ilosc>0) THEN
  ----RAISE NOTICE 'Szukam dla % i %',ilosc,_fv;
  FOR d IN SELECT tel_idelem,tel_iloscwyd FROM tg_transelem WHERE (tel_idelem=_fv OR tel_skojarzony=_fv) AND (tel_idelem<>_korekta) AND TEisOpHandel(tel_newflaga) AND NOT TEisOpMagazyn(tel_newflaga) AND tel_iloscwyd*TEwspIlosci(_newflaga)>0 ORDER BY tel_idelem ASC
  LOOP   
   ilosctmp=min(ilosc,d.tel_iloscwyd*TEwspIlosci(_newflaga));
   ----RAISE NOTICE 'Znalazlem % ',ilosctmp;
   IF (ilosctmp>0) THEN
    INSERT INTO tb_kompensatyhand (kh_ilosc,kh_idkorekty,kh_idfaktury) VALUES (ilosctmp*TEwspIlosci(_newflaga),_korekta,d.tel_idelem);
   END IF;
   ilosc=ilosc-ilosctmp;
  END LOOP;
 END IF; 

 ilosctmp=(abs(_ilosckor)-abs(ilosc))*TEwspIlosci(_newflaga);
 ----RAISE NOTICE 'Zwracam % %  %',_ilosckor,ilosc,ilosctmp;

 -- Zwracamy ilosc ktora udalo nam sie skompensowac (wartosc dodatnia!!!), gdy ujemna to znaczy ze
 RETURN ilosctmp;
END;
$_$;
