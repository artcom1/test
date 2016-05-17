CREATE FUNCTION onodlozenienarzedzia(_nrr_idruchu integer, _tel_idelem_odlozenie integer, _ilosc numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 _rec_info RECORD;
 _rec_nrr RECORD;
 _nrr_idruchu_new INT;
 _nrr_ilosc_new NUMERIC;
BEGIN

 SELECT 
 nrr_idruchu,
 kwh_idheadu, kwe_idelemu, prt_idpartii, ttw_idtowaru, knr_idelemu, 
 tel_idelem_pobranie, tel_idelem_odlozenie,
 zl_idzlecenia, ob_idobiektu, p_idpracownika, tmg_idmagazynu,
 nrr_ilosc, nrr_data_pobrania, nrr_flaga
 INTO _rec_info 
 FROM tr_narzedzie_ruch 
 WHERE nrr_idruchu=_nrr_idruchu;
 
 IF (_ilosc=_rec_info.nrr_ilosc) THEN -- Oddalem wszystko, ustawiam tylko date i transelema
  UPDATE tr_narzedzie_ruch SET nrr_data_odlozenia=now(), tel_idelem_odlozenie=_tel_idelem_odlozenie WHERE nrr_idruchu=_nrr_idruchu;
 ELSE -- Musze dzielic :-(
  _nrr_ilosc_new=_rec_info.nrr_ilosc-_ilosc;
  IF (_nrr_ilosc_new<0) THEN
   RETURN 2;   
  END IF;
  
  INSERT INTO tr_narzedzie_ruch
  (
   kwh_idheadu, kwe_idelemu, prt_idpartii, ttw_idtowaru, knr_idelemu, 
   tel_idelem_pobranie,
   zl_idzlecenia, ob_idobiektu, p_idpracownika, tmg_idmagazynu,
   nrr_ilosc, nrr_data_pobrania, nrr_flaga
  ) 
  VALUES 
  (
   _rec_info.kwh_idheadu, _rec_info.kwe_idelemu, _rec_info.prt_idpartii, _rec_info.ttw_idtowaru, _rec_info.knr_idelemu, 
   _rec_info.tel_idelem_pobranie, 
   _rec_info.zl_idzlecenia, _rec_info.ob_idobiektu, _rec_info.p_idpracownika, _rec_info.tmg_idmagazynu,
   _nrr_ilosc_new, _rec_info.nrr_data_pobrania, _rec_info.nrr_flaga
  )
  RETURNING nrr_idruchu INTO _rec_nrr;
  _nrr_idruchu_new=_rec_nrr.nrr_idruchu; 
	  
  INSERT INTO tr_narzedzie_wyk
  (nrr_idruchu, knw_idelemu, nrw_przebieg_h, nrw_przebieg_oper, nrw_flaga)
  SELECT _nrr_idruchu_new, knw_idelemu, nrw_przebieg_h, nrw_przebieg_oper, nrw_flaga
  FROM tr_narzedzie_wyk WHERE nrr_idruchu=_nrr_idruchu;   
  
  UPDATE tr_narzedzie_ruch SET nrr_data_odlozenia=now(), tel_idelem_odlozenie=_tel_idelem_odlozenie, nrr_ilosc=_ilosc WHERE nrr_idruchu=_nrr_idruchu;
 END IF;

 RETURN 1; 
END;
$$;
