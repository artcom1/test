CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
 r              RECORD;
 e              RECORD;
 seq            INT;
 wsp            NUMERIC:=1;
BEGIN
 seq=nextval('tb_vatzal_s');

 FOR r IN SELECT netto,vat,brutto,tel_stvat,tel_zw FROM vatviews.kv_raport_bystawka_ret WHERE tr_idtrans=_idtrans
 LOOP

  SELECT * INTO e 
  FROM tb_vatzal 
  WHERE tr_idtrans=_idtrans AND 
		vz_stawkavat=r.tel_stvat AND vz_flagazw=r.tel_zw;
  IF FOUND THEN
   UPDATE tb_vatzal SET vz_netto=r.netto,
                        vz_vat=r.vat,
						vz_brutto=r.brutto,
						vz_sequpd=seq,
						rr_idrozrachunku=COALESCE(_idrozrachunku,rr_idrozrachunku),
						rr_idrozrachunkuvat=COALESCE(_idrozrachunkuvat,rr_idrozrachunkuvat) 
					WHERE vz_id=e.vz_id;
  ELSE
   INSERT INTO tb_vatzal
    (tr_idtrans,rr_idrozrachunku,rr_idrozrachunkuvat,vz_netto,vz_vat,vz_brutto,vz_stawkavat,vz_flagazw,vz_sequpd)
   VALUES
    (_idtrans,_idrozrachunku,_idrozrachunkuvat,r.netto,r.vat,r.brutto,r.tel_stvat,r.tel_zw,seq);
  END IF;
     
 END LOOP;

 DELETE FROM tb_vatzal 
 WHERE tr_idtrans=_idtrans AND 
	   vz_sequpd<>seq;
    
 RETURN TRUE;
END;
$$;
