CREATE FUNCTION isostatniadostawatowaru(idtowaru integer, iddokumentu integer, ignorekorekta boolean DEFAULT true) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 iddostawy INT;
BEGIN
 --I towar i dostawa musza byc nieNULLowe
 IF (idtowaru IS NULL OR iddokumentu IS NULL) THEN
  RETURN FALSE;
 END IF;
 
 ---Wczytaj ID dostawy z towaru
 iddostawy=(SELECT ttw_ostatniadostawa[gm.getIndexTab((SELECT fm_idcentrali FROM tg_transakcje WHERE tr_idtrans=iddokumentu))] FROM tg_towary WHERE ttw_idtowaru=idtowaru); 
 ---RAISE EXCEPTION 'Towar % dokument % ignore % dostawa %',idtowaru,iddokumentu,ignorekorekta,iddostawy;
 ---Jesli dokument sie zgadza zwroc true
 IF (iddostawy IS NOT DISTINCT FROM iddokumentu) THEN
  RETURN TRUE;
 END IF;
 ---Nie ma ID dostawy
 IF (iddostawy IS NULL) THEN
  ---RAISE EXCEPTION 'ID Dostawy jest NULL';
  RETURN FALSE;
 END IF;
 
 ---Nie uwzgledniaj korekt
 IF (ignorekorekta=FALSE) THEN
  ---RAISE EXCEPTION 'Ignore korekta';
  RETURN FALSE;
 END IF;
 
 ---Dla uwzglednienia korekt:
 ---iddokumentu to zawsze iddokumentu pierwotnego
 ---iddostawy moze to byc naniesiona wczesniejsza korekta
 ---Sproboj sprawdzic czy to nie jest biezaca korekta
 SELECT tep.tr_idtrans INTO iddostawy
 FROM tg_transakcje AS trk   ---Transelem korekty
 JOIN tg_transelem AS tek ON (tek.tr_idtrans=trk.tr_idtrans)
 JOIN tg_transelem AS tep ON (tep.tel_idelem=tek.tel_skojarzony)
 WHERE trk.tr_idtrans=iddostawy AND
       tek.ttw_idtowaru=idtowaru AND
	   tep.tr_idtrans=iddokumentu
 LIMIT 1;
 
 ---RAISE EXCEPTION 'ID %',iddostawy;
 
 --Jesli znaleziono taki rekord - tak to jest ta sama dostawa
 RETURN (iddostawy IS NOT NULL);
END;
$$;
