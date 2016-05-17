CREATE FUNCTION prepareforwmsmm(simid integer, doc integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 docskoj INT;
BEGIN

 docskoj=(SELECT tr_skojwyn FROM tg_transakcje WHERE tr_idtrans=doc);

 --Skasuj te elementy gdzie miejsce magazynowe jest miejscem magazynowym dokumentu
  WITH a AS (
   SELECT mm_idmiejsca FROM ts_miejscamagazynowe WHERE tr_idtransfor IS NOT NULL
 ) DELETE FROM gms.tm_simcoll 
          USING a 
		  WHERE sc_sid=vendo.tv_mysessionpid() AND 
                sc_simid=simid AND 
				sc_idmiejsca=a.mm_idmiejsca;

 --Skasuj informacje o rekordach do uzycia (nie powinno ich w zasadzie byc bo WMSMM nie ma transelemow i ruchow)								  
 DELETE FROM gms.tm_touse WHERE sc_sid=vendo.tv_mysessionpid() AND 
                                sc_simid=simid AND 
								rc_idruchuwz NOT IN (SELECT rc_idruchu FROM tg_ruchy WHERE tr_idtrans=docskoj);
								
 ---Ilosc ktora byla na WZetce przepisz do iloscipoz (poprzez ustawienie swz_iloscpozondel)
 WITH a AS (
  SELECT sc_id FROM gms.tm_simcoll WHERE sc_sid=vendo.tv_mysessionpid() AND sc_simid=simid
 ) 
 UPDATE gms.tm_simwz 
        SET swz_iloscpriorondel=swz_iloscpriorondel+swz_iloscrest_pnull+swz_iloscrest_p,
		    swz_iloscpozondel=swz_iloscpozondel+swz_iloscrest_pnull+swz_iloscrest_p
        FROM a
        WHERE gms.tm_simwz.sc_id=a.sc_id AND 
		      tr_idtrans IS NOT DISTINCT FROM docskoj;

 ---Ilosc ktora byla na WZetce przepisz do iloscipoz (poprzez ustawienie swz_iloscpozondel)
 WITH a AS (
  SELECT sc_id FROM gms.tm_simcoll WHERE sc_sid=vendo.tv_mysessionpid() AND sc_simid=simid
 ) 
 UPDATE gms.tm_simwz 
        SET swz_iloscpozondel=swz_iloscpozondel+swz_iloscrest_pnull+swz_iloscrest_p
        FROM a
        WHERE gms.tm_simwz.sc_id=a.sc_id AND 
		      tr_idtrans IS DISTINCT FROM docskoj;
			  

 --Przenies ilosci z WZ na ilosci pozostale
 --Zasymulujemy w ten sposob sytuacje w ktorej wszystkie WZetki w buforze i ich ilosci niepotwierdzone sa niewydane 
 ---UPDATE gms.tm_simcoll SET sc_iloscpoz=sc_iloscpoz+
 ---                                       sc_ilosc[0].p+
 ---								   sc_ilosc[0].pnull+
 ---									   sc_ilosc[0].lnull+
 ---									   sc_ilosc[0].l
 ---                      WHERE sc_sid=vendo.tv_mysessionpid() AND 
 ---                            sc_simid=simid;
 
 ---Skasuj informacje o WZetkach, ilosci zostana w symulacji w wyniku poprzedniego kroku
 WITH a AS (SELECT sc_id FROM gms.tm_simcoll WHERE sc_sid=vendo.tv_mysessionpid() AND sc_simid=simid)
 DELETE FROM gms.tm_simwz USING a WHERE gms.tm_simwz.sc_id=a.sc_id;
 
 UPDATE gms.tm_simcoll 
 SET sc_ilosc[1]='(0,0,0,0)'::gms.tm_ilosci,
     sc_ilosc[2]='(0,0,0,0)'::gms.tm_ilosci
 WHERE sc_sid=vendo.tv_mysessionpid() AND 
       sc_simid=simid AND
	   (sc_ilosc[1]!='(0,0,0,0)'::gms.tm_ilosci OR
	    sc_ilosc[2]!='(0,0,0,0)'::gms.tm_ilosci);

		
 RETURN TRUE;
END
$$;
