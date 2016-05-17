CREATE FUNCTION correctmmseq() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
 seqid INT;
 r RECORD;
 ----
 foundilosc NUMERIC;
 recscount INT;
 idminus INT;
 idplus INT;
 idtrans INT;
BEGIN

 WHILE (TRUE)
 LOOP
  seqid=(select rc_seqid from tg_ruchy JOIN tg_transakcje using (tr_idtrans) WHERe rc_wspmag!=0 and tr_rodzaj IN (6,8) GROUP BY rc_seqid having count(*)>2 ORDER BY rc_seqid LIMIT 1);
  
  EXIT WHEN seqid IS NULL;
  
  RAISE NOTICE 'Do poprawienia %',seqid;

  recscount=0;
  foundilosc=NULL;
  idminus=NULL;
  idplus=NULL;
  idtrans=NULL;

  FOR r IN SELECT rc_idruchu,rc_ilosc,rc_wspmag,tr_skojarzona,tr_idtrans
           FROM tg_ruchy 
           JOIN tg_transakcje using (tr_idtrans) 
           WHERE rc_seqid=seqid AND tr_rodzaj IN (6,8) ORDER BY rc_wspmag DESC
  LOOP
   --Znajdz pierwszy rekord
   IF (foundilosc IS NULL) THEN
    foundilosc=r.rc_ilosc;
    recscount=recscount+1;
    idplus=r.rc_idruchu;
    idtrans=r.tr_skojarzona;
    CONTINUE;
   END IF;
   --Rekord z inna iloscia
   IF (foundilosc IS DISTINCT FROM r.rc_ilosc) THEN
    CONTINUE;
   END IF;
   IF (r.tr_idtrans IS DISTINCT FROM idtrans) THEN
    CONTINUE;
   END IF;
   ---- Drugi rekord powinien miec rc_wspmag=1
   IF (r.rc_wspmag!=(-1)) THEN
    RAISE EXCEPTION 'Nieprawidlowy rc_wspmag dla SEQID=%',seqid;
   END IF;
   recscount=recscount+1;   
   idminus=r.rc_idruchu;
  END LOOP;  

  IF (recscount!=2) THEN
    RAISE EXCEPTION 'Nieprawidlowa ilosc rekordow dla dla SEQID=%',seqid;
  END IF;

  IF (idminus IS NULL OR idplus IS NULL) THEN
    RAISE EXCEPTION 'Nieprawidlowa ilosc rekordow (v2) dla dla SEQID=%',seqid;
  END IF;

  RAISE NOTICE 'SEQID % (% %)',seqid,idminus,idplus;

  UPDATE tg_ruchy SET rc_seqid=nextval('tg_ruchy_seqid') WHERE rc_idruchu=idminus;
  UPDATE tg_ruchy SET rc_seqid=currval('tg_ruchy_seqid') WHERE rc_idruchu=idplus;
    
 END LOOP;


 RETURN TRUE;
END;
$$;
