CREATE FUNCTION resynccenajmpokor(idtrans integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
---WSPOK
BEGIN

 --Tabela tymczasowa
 CREATE TEMP TABLE tmp_kpz AS
 SELECT COALESCE(id2,id1) AS id,max(idelem) AS idelem 
 FROM (
 SELECT tel_idelem AS id1,tel_skojarzony AS id2,tel_idelem AS idelem 
 FROM tg_transelem 
 WHERE tel_sprzedaz>0 AND tel_ilosc>0 AND 
        (tr_idtrans=idtrans)
 UNION
 SELECT tel_idelem AS id1,tel_skojarzony AS id2,tel_idelem AS idelem 
 FROM tg_transelem 
 WHERE tel_sprzedaz>0 AND tel_ilosc>0 AND 
	(tel_skojarzony IN (SELECT tel_skojarzony FROM tg_transelem WHERE tel_skojarzony IS NOT NULL AND tr_idtrans=idtrans))
 ) AS a 
 GROUP BY COALESCE(id2,id1);
 
 
 CREATE TEMP TABLE tmp_kpz2 AS 
 SELECT round(tel_cenadok*tel_kursdok*1000/tel_przelnilosci,4) AS cena, tmp_kpz.id, tmp_kpz.idelem, r.rc_idruchu  
 FROM tg_ruchy AS r  
 JOIN tmp_kpz ON (r.tel_idelem=tmp_kpz.id)  
 JOIN tg_transelem AS te ON (idelem=te.tel_idelem) 
 WHERE isPZet(rc_flaga) AND rc_idruchu=rc_dostawa;
  
 ---Zupdatuj ceny z tymczasowej

 UPDATE tg_ruchy SET rc_cenajmpokor=(SELECT cena FROM tmp_kpz2 WHERE tmp_kpz2.rc_idruchu=tg_ruchy.rc_idruchu) WHERE rc_idruchu IN (SELECT rc_idruchu FROM tmp_kpz2);

 ---Zupdatuj z dostawy
 ---UPDATE tg_ruchy SET rc_cenajmpokor=(SELECT rc_cenajmpokor FROM tg_ruchy AS r WHERE r.rc_idruchu=tg_ruchy.rc_dostawa) WHERE rc_cenajmpokor IS NULL AND isPZet(rc_flaga) AND tr_idtrans=idtrans;

 ---Zupdatuj bezposrednio
 UPDATE tg_ruchy SET rc_cenajmpokor=(SELECT round(tel_cenadok*tel_kursdok*1000/tel_przelnilosci,4) FROM tg_transelem AS te WHERE tg_ruchy.tel_idelem=te.tel_idelem AND tel_sprzedaz>0) 
 WHERE isPZet(rc_flaga) AND rc_cenajmpokor IS NULL AND tr_idtrans=idtrans AND rc_idruchu=rc_dostawa;


 UPDATE tg_ruchy SET rc_cenajmpokor=round(rc_wartosc*rc_wspwartosci/rc_ilosc,4) WHERE isPZet(rc_flaga) AND rc_cenajmpokor IS NULL AND tr_idtrans=idtrans AND rc_ilosc>0 AND rc_idruchu=rc_dostawa;


 DROP TABLE tmp_kpz;
 DROP TABLE tmp_kpz2;

 RETURN TRUE;
END;
$$;


SET search_path = public, pg_catalog;
