CREATE FUNCTION buildrozrachunkikorekty(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans   ALIAS FOR $1;
 _idkorekty INT;
 trans      tg_transakcje;
 r          RECORD;
 id         INT;
 _isend     BOOL:=FALSE;
 val        INT;
BEGIN 

 DELETE FROM kr_rozrachunki WHERE tr_idtrans=_idtrans AND rr_no IN (4,5,6,7);

 _idkorekty=gm.getIDPoprzedniejKorekty(_idtrans,TRUE);
 SELECT * INTO trans FROM tg_transakcje WHERE tr_idtrans=_idtrans;
 LOOP
  EXIT WHEN _idkorekty IS NULL;

  FOR r IN SELECT *
           FROM kr_rozrachunki 
	   WHERE tr_idtrans=_idkorekty AND 
	         rr_flaga&7 IN (0) AND 
		 rr_wartoscpozwal<>0
	   ORDER BY rr_no 
  LOOP  
   
   IF (r.rr_no IN (2,3,6,7)) THEN
    _isend=TRUE;
   END IF;

   CONTINUE WHEN r.rr_no NOT IN (0,1,4,5);

   --------------------------------------------------------------------
   INSERT INTO kr_rozrachunki
    (k_idklienta,tr_idtrans,
     rr_idwaluty,rr_kwotawal,rr_wartoscpln,
     rr_wartoscpozwal,rr_wartoscpozpln,
     rr_iswn,rr_isbufor,rr_isnormal,
     rr_datadokumentu,rr_dataplatnosci,
     rr_flaga,
     fm_idcentrali,rr_no,
	 rr_kwotawalfornorm
    )
    VALUES
    (r.k_idklienta,_idtrans,
    r.rr_idwaluty,r.rr_wartoscpozwal,r.rr_wartoscpozpln,
    r.rr_wartoscpozwal,r.rr_wartoscpozpln,
    r.rr_iswn,(trans.tr_zamknieta&1)=0,r.rr_isnormal,
    (CASE WHEN (trans.tr_zamknieta&(1<<21))=0 THEN trans.tr_datawystaw ELSE trans.tr_datasprzedaz END),trans.tr_dataplatnosci,
    (r.rr_flaga&(7|16|32|128|256|(1<<20))|(1<<25)),
    r.fm_idcentrali,4+(r.rr_no%2),
	r.rr_kwotawalfornorm
    );
   --------------------------------------------------------------------
   id=nextval('kr_rozrachunki_s');
   INSERT INTO kr_rozrachunki
    (k_idklienta,tr_idtrans,
     rr_idwaluty,rr_kwotawal,rr_wartoscpln,
     rr_wartoscpozwal,rr_wartoscpozpln,
     rr_iswn,rr_isbufor,rr_isnormal,
     rr_datadokumentu,rr_dataplatnosci,
     rr_flaga,
     fm_idcentrali,rr_no,rr_idrozrachunku,
     rr_formaplat,
	 rr_kwotawalfornorm
    )
    VALUES
    (r.k_idklienta,_idtrans,
    r.rr_idwaluty,-r.rr_wartoscpozwal,-r.rr_wartoscpozpln,
    -r.rr_wartoscpozwal,-r.rr_wartoscpozpln,
    r.rr_iswn,(trans.tr_zamknieta&1)=0,r.rr_isnormal,
    (CASE WHEN (trans.tr_zamknieta&(1<<21))=0 THEN trans.tr_datawystaw ELSE trans.tr_datasprzedaz END),trans.tr_dataplatnosci,
    (r.rr_flaga&(7|16|32|128|256|(1<<20)))|(1<<24),
    r.fm_idcentrali,6+(r.rr_no%2),id,
    r.rr_formaplat,
	-r.rr_kwotawalfornorm
    );
   PERFORM gm.simplyRozlicz(r.rr_idrozrachunku,id,r.rr_wartoscpozwal,r.rr_wartoscpozpln,512);
  END LOOP;

  EXIT WHEN _isend=TRUE;
  _idkorekty=gm.getIDPoprzedniejKorekty(_idkorekty,TRUE);
 END LOOP;


 RETURN TRUE;
END;
$_$;
