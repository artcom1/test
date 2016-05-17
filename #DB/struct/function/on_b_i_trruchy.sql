CREATE FUNCTION on_b_i_trruchy() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 dyspozycja RECORD; 
 _kwc_flaga INT:=0;
BEGIN
 IF (COALESCE(NEW.dmag_iddyspozycji,0)<=0) THEN
  RAISE EXCEPTION 'Brak dyspozycji!';
 END IF;
 
 SELECT 
 -- NodRec
 knr_idelemu, knr_idelemu_idx,
 -- KKWNod
 kwe_idelemu,
 -- Kooperacja
 knw_idelemu_koop,
 --KKWNodWyk
 knw_idelemu,
 -- Pracownik
 p_idpracownika,
 -- Ilosci
 dmag_ilosc,
 -- Typ
 dmag_typ,
 --
 dmag_znacznik, dmag_flaga
 
 INTO dyspozycja FROM tr_dyspozycjamag WHERE dmag_iddyspozycji=NEW.dmag_iddyspozycji;
 
 -----------------------------------------------------------------------------
 ----- USTALANIE FLAGI -----
 
 _kwc_flaga=(dyspozycja.dmag_flaga&(3<<0));
 
 IF ((dyspozycja.dmag_flaga&(1<<8))=(1<<8)) THEN
  _kwc_flaga=_kwc_flaga|(1<<6);
 END IF;
 
 IF (dyspozycja.dmag_typ=4) THEN
  _kwc_flaga=_kwc_flaga|(1<<9);
 END IF;
 
 IF (dyspozycja.dmag_typ=6) THEN
  _kwc_flaga=_kwc_flaga|(1<<10);
 END IF;
  
 IF ((NEW.kwc_flaga&(1<<8))=0) THEN
  NEW.kwc_ilosc=dyspozycja.dmag_ilosc;
 END IF;
 -----------------------------------------------------------------------------
  
 NEW.kwc_flaga=_kwc_flaga;
 NEW.knr_idelemudst=dyspozycja.knr_idelemu;
 NEW.kwe_idelemusrc=dyspozycja.kwe_idelemu;
 NEW.p_idpracownika=dyspozycja.p_idpracownika;
 NEW.knw_idelemusrc=dyspozycja.knw_idelemu;
 NEW.kwc_znacznik=dyspozycja.dmag_znacznik;
 NEW.knr_idelemu_idx=dyspozycja.knr_idelemu_idx;
   
 RETURN NEW;
END;
$$;
