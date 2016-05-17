CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 id INT;
 r RECORD;
BEGIN
 -- Wczytaj dane z transelemu
 SELECT rmp_idsposobu,ttw_idtowaru INTO r FROM tg_transelem WHERE tel_idelem=idelem AND ((tel_new2flaga>>15)&3)=1 AND ((tel_new2flaga>>17)&15)=3;
 -- Jesli nie znaleziono rekordu - zwroc TRUE bo najprawdopodobniej to nie rekord naglowka rozmiarowki
 IF (r.ttw_idtowaru IS NULL) THEN
  RETURN TRUE;
 END IF;
 ---Sprawdz czy jest sposob pakowania - jesli nie ma to blad
 IF (r.rmp_idsposobu IS NULL) THEN
  RAISE EXCEPTION 'Brak sposobu pakowania na TE=%',idelem;
 END IF;
 
 IF (vendo.gettparami('C_TG_ROZMSPPAK_TMP',0)=0) THEN
  PERFORM vendo.settparami('C_TG_ROZMSPPAK_TMP',1);
  PERFORM vendo.execNoErrorNoticeQuery('CREATE TEMP TABLE IF NOT EXISTS tg_rozmsppak_tmp () INHERITS (tg_rozmsppak) ON COMMIT DELETE ROWS;
                                        CREATE TEMP TABLE IF NOT EXISTS tg_rozmsppakelems_tmp () INHERITS (tg_rozmsppakelems) ON COMMIT DELETE ROWS;');
 END IF;									

 --Pobierz ID z sekwencji
 id=nextval('tg_rozmrodzaje_s');
 
 --Dodaj do tabelki tymczasowej elementy
 INSERT INTO tg_rozmsppak_tmp (rmp_idsposobu,rmp_istmp) VALUES (id,true);
 INSERT INTO tg_rozmsppakelems_tmp 
  (rmp_idsposobu,rmk_przelicznik,ttw_idtowaru_pdx) 
 SELECT 
  id,tel_przelnopakow/1000,ttw_idtowaru
 FROM tg_transelem WHERE tel_skojzestaw=idelem;
  
 ---Znajdz ID rewizji dla podanego zestawu danych
 id=gmr.findrevision(id,r.ttw_idtowaru,FALSE);
 
 IF (id IS DISTINCT FROM r.rmp_idsposobu) THEN
  IF (throwException=TRUE) THEN
   RAISE EXCEPTION 'Dla TENDX=% nie zgadza sie sposob pakowania (%!=%)!',idelem,id,r.rmp_idsposobu;
  END IF;
  RETURN FALSE;
 END IF;
 
  
 RETURN TRUE;
END;
$$;
