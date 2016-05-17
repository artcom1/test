CREATE FUNCTION correctmm(idtep integer, seqid integer DEFAULT NULL::integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
---WSPOK
DECLARE 
 r RECORD; 
 tmpr RECORD;
 idminus INT;
 idte INT;
 idtem INT;
 newseq INT;
 tmpint INT;
 przed RECORD;
 po RECORD;
BEGIN


 IF (seqid IS NULL) THEN

  idtem=(SELECT tel_skojarzony FROM tg_transelem WHERE tel_idelem=idtep);
  SELECT sum(rc_wartosc) AS w,sum(rc_ilosc) AS i,sum(rc_wspwartosci) AS swsp INTO przed FROM tg_ruchy WHERE isFV(rc_flaga) AND tel_idelem=idtem;

  RAISE NOTICE 'Transelems % %',idtem,idtep;
  
  SELECT count(*) INTO tmpr FROM (  
   with c as (
    with a as (
     SELECT rc_seqid,tel_idelem AS tel_idelemm,count(*) FROM tg_ruchy AS r JOIN tg_transakcje AS tr USING (tr_idtrans) WHERE tr_rodzaj=6 group by tel_idelem,rc_seqid)
    ,b as (
      SELECT rc_seqid,count(*),tel_idelem AS tel_idelemp FROM tg_ruchy AS r JOIN tg_transakcje AS tr USING (tr_idtrans) WHERE tr_rodzaj=8 group by tel_idelem,rc_seqid
    ) select * from a join b using (rc_seqid) where a.count!=b.count
   ) 
   SELECT gm.correctmm(c.tel_idelemp,c.rc_seqid) FROM c WHERE c.tel_idelemp=idtep ) AS d;

  UPDATE tg_transelem SET tel_idelem=tel_idelem WHERE tel_idelem=idtep;

  SELECT sum(rc_wartosc) AS w,sum(rc_ilosc) AS i,sum(rc_wspwartosci) AS swsp INTO po FROM tg_ruchy WHERE isFV(rc_flaga) AND tel_idelem=idtem;

  IF (przed IS DISTINCT FROM po) THEN
   RAISE EXCEPTION 'Blad operacji naprawy!';
  END IF;

  RETURN TRUE;
 END IF;
 
 RAISE NOTICE 'Koryguje % %',idtep,seqid;

 idminus=(SELECT rc_idruchu FROM tg_ruchy WHERE rc_seqid=seqid AND isFV(rc_flaga));
 idte=(SELECT tel_idelem FROM tg_ruchy WHERE rc_seqid=seqid AND isPZet(rc_flaga) LIMIT 1);
 idtem=(SELECT tel_idelem FROM tg_ruchy WHERE rc_seqid=seqid AND isFV(rc_flaga) LIMIT 1);
 
 SELECT sum(rc_wartosc) AS w,sum(rc_ilosc) AS i,sum(rc_wspwartosci) AS swsp INTO przed FROM tg_ruchy WHERE isFV(rc_flaga) AND tel_idelem=idtem;
 
 
 FOR r IN 
  SELECT * 
  FROM tg_ruchy  AS rr 
  WHERE isPZet(rr.rc_flaga) AND rr.rc_seqid=seqid 
  ORDER BY rc_ilosc desc OFFSET 1
 LOOP
  RAISE NOTICE 'Znalazlem ilosc % wartosc % dla ID % TE %',r.rc_ilosc,r.rc_wartosc,r.rc_idruchu,r.tel_idelem;

  newseq=nextval('tg_ruchy_seqid');  
	
  UPDATE tg_ruchy SET rc_ilosc=rc_ilosc-r.rc_ilosc,
                      rc_wartosc=rc_wartosc-r.rc_wartosc,
                      rc_iloscpoz=rc_iloscpoz-r.rc_ilosc,
					  rc_wartoscpoz=rc_wartoscpoz-r.rc_wartosc
				  WHERE rc_idruchu=idminus;
  
  UPDATE tg_ruchy SET rc_seqid=newseq WHERE rc_idruchu=r.rc_idruchu;

  SELECT * INTO tmpr FROM tg_ruchy WHERE rc_idruchu=idminus;
  
  tmpint=(SELECT rs_id FROM gm.tg_rezstack WHERE rc_recver_new=tmpr.rc_recver);
  IF (tmpint IS NOT NULL) THEN
   RAISE EXCEPTION 'Nie moge naprawic rekordu ze skojarzeniem do rezstack!';
  END IF;
  
  tmpr.rc_idruchu=nextval('tg_ruchy_s');
  tmpr.rc_recver=nextval('gm.tg_rezstack_ver');
  tmpr.rc_ilosc=r.rc_ilosc;
  tmpr.rc_wartosc=r.rc_wartosc;
  tmpr.rc_iloscpoz=r.rc_ilosc;
  tmpr.rc_wartoscpoz=r.rc_wartosc;
  tmpr.rc_seqid=newseq;
  tmpr.rc_wspwartosci=r.rc_wspwartosci;
  EXECUTE 'INSERT INTO tg_ruchy  VALUES '||vendo.record2string(tmpr);
  
 END LOOP;
 
 ----UPDATE tg_transelem SET tel_idelem=tel_idelem WHERE tel_idelem=idte;

 SELECT sum(rc_wartosc) AS w,sum(rc_ilosc) AS i,sum(rc_wspwartosci) AS swsp INTO po FROM tg_ruchy WHERE isFV(rc_flaga) AND tel_idelem=idtem;

 IF (przed IS DISTINCT FROM po) THEN
  RAISE EXCEPTION 'Blad operacji naprawy!';
 END IF;
 
 RETURN TRUE;
END
$$;
