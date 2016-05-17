CREATE FUNCTION p_on_a_iud_trruchy_narzedzia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 _rec_info RECORD;
 _rec_nrr RECORD;
 _rec_info_wyk RECORD;
 _nrr_idruchu INT;
 _kwe_idelemu INT;
BEGIN

 IF (TG_OP='INSERT') THEN
  IF ((NEW.kwc_flaga&(1<<9))=(1<<9)) THEN -- tworze tr_narzedzieruch
   
   SELECT
   dmag.kwh_idheadu, dmag.kwe_idelemu, dmag.prt_idpartiipz AS prt_idpartii, dmag.ttw_idtowaru, dmag.knr_idelemu, -- dysp	
   mag.zl_foridzlecenia AS zl_idzlecenia, mag.ob_foridobiektu AS ob_idobiektu, mag.p_foridpracownika AS p_idpracownika, mag.tmg_idmagazynu, -- dok-mag2
   kwc.tel_idelemsrc AS tel_idelem_pobranie, kwc_ilosc AS nrr_ilosc -- ruch
   INTO _rec_info
   FROM tr_ruchy AS kwc
   JOIN tr_dyspozycjamag AS dmag USING (dmag_iddyspozycji)
   JOIN tg_transelem AS tel ON (tel.tel_idelem=kwc.tel_idelemsrc)
   JOIN tg_transakcje AS tr ON (tr.tr_idtrans=tel.tr_idtrans)
   JOIN tg_magazyny AS mag ON (mag.tmg_idmagazynu=tr.tmg_idmagazynu2)
   WHERE 
   kwc_idruchu=NEW.kwc_idruchu;
  
   INSERT INTO tr_narzedzie_ruch
   (
    kwh_idheadu, kwe_idelemu, prt_idpartii, ttw_idtowaru, knr_idelemu, -- dysp	
	zl_idzlecenia, ob_idobiektu, p_idpracownika, tmg_idmagazynu, -- dok-mag2
	tel_idelem_pobranie, nrr_ilosc, -- ruch
	nrr_data_pobrania -- now()
   ) 
   VALUES 
   (
    _rec_info.kwh_idheadu, _rec_info.kwe_idelemu, _rec_info.prt_idpartii, _rec_info.ttw_idtowaru, _rec_info.knr_idelemu, -- dysp	
	_rec_info.zl_idzlecenia, _rec_info.ob_idobiektu, _rec_info.p_idpracownika, _rec_info.tmg_idmagazynu, -- dok
	_rec_info.tel_idelem_pobranie, _rec_info.nrr_ilosc, -- ruch
	now()
   )
   RETURNING nrr_idruchu INTO _rec_nrr;
   
   -- tworze tr_narzedziewyk (jesli trzeba)
   _nrr_idruchu=_rec_nrr.nrr_idruchu;   
   _kwe_idelemu=_rec_info.kwe_idelemu;
   
   FOR _rec_info_wyk IN 
   SELECT knw_idelemu FROM tr_kkwnodwyk WHERE kwe_idelemu=_kwe_idelemu AND knw_flaga&(1<<0)=0
   LOOP
    INSERT INTO tr_narzedzie_wyk (nrr_idruchu, knw_idelemu) VALUES (_nrr_idruchu,_rec_info_wyk.knw_idelemu);
   END LOOP;
  
  END IF;
 END IF;

 IF (TG_OP='UPDATE') THEN
 END IF;

 IF (TG_OP='DELETE') THEN 
  IF ((OLD.kwc_flaga&((1<<9)|(1<<10)))<>0) THEN -- usuwam dyspozycje
   DELETE FROM tr_dyspozycjamag WHERE dmag_iddyspozycji=OLD.dmag_iddyspozycji;
  END IF;
 END IF;
 
 IF (TG_OP='DELETE') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;
END;
$$;
