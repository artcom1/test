CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _NEW ALIAS FOR $1;
 r    RECORD;
 delta INT:=0;
BEGIN

 IF ((_NEW.tr_newflaga>>7)&3)=3 THEN
  RAISE EXCEPTION '47|%|Korekta na kurs i rozrachunki',NEW.tr_idtrans;
 END IF;

 --Wylaczona blokada rozrachunkow
 --Wchodzi do platnosci lub ma harmonogram splat
 IF ((_NEW.tr_zamknieta&(1<<26))=0) AND ((_NEW.tr_zamknieta&64=64) OR (_NEW.tr_flaga&(1<<26)<>0)) THEN
  --Osobny kurs vat i vat od brutto=osobny kurs vat i waluta jest rozna od PLN
  IF (gm.hasOsobnyRozrachunekVAT(_NEW.tr_zamknieta,_NEW.tr_newflaga,_NEW.wl_idwaluty)=TRUE) THEN
   --Korekta na kurs
   IF (_NEW.tr_newflaga&(1<<8))<>0 THEN
    FOR r IN SELECT netto,v_kursdok FROM vat.kv_raport_vat_wkurs WHERE tr_idtrans=_NEW.tr_idtrans ORDER BY ispkorkurs,netto ASC
    LOOP
     PERFORM gm.resyncRozrachunkiTrans(_NEW,r.netto,r.v_kursdok,(CASE WHEN delta=0 THEN _NEW.tr_vat ELSE 0 END),_NEW.tr_kursvat,delta);
     delta=delta+2;
    END LOOP;
   ELSE
    PERFORM gm.resyncRozrachunkiTrans(_NEW,_NEW.tr_wartosc,_NEW.tr_przelicznik,_NEW.tr_vat,_NEW.tr_kursvat,0);
    PERFORM gm.resyncRozrachunkiTrans(_NEW,0,0,0,0,2);
   END IF;
  ELSE
   ---Korekta na kurs
   IF (_NEW.tr_newflaga&(1<<8))<>0 THEN   -- Dokument jest korekta na kurs
    FOR r IN SELECT brutto,v_kursdok FROM vat.kv_raport_vat_wkurs WHERE tr_idtrans=_NEW.tr_idtrans ORDER BY ispkorkurs,netto ASC
    LOOP
     PERFORM gm.resyncRozrachunkiTrans(_NEW,r.brutto,r.v_kursdok,0,_NEW.tr_kursvat,delta);
     delta=delta+2;
    END LOOP;
   ELSE
    PERFORM gm.resyncRozrachunkiTrans(_NEW,_NEW.tr_dozaplaty,_NEW.tr_przelicznik,0,_NEW.tr_kursvat,0);
    PERFORM gm.resyncRozrachunkiTrans(_NEW,0,0,0,0,2);
   END IF;
  END IF;
 END IF;

 IF ((_NEW.tr_newflaga>>7)&3)=1 THEN    -- Korekta na rozrachunki, korekta nie na kurs
  FOR r IN SELECT sum(rr_kwotawal) AS wal,sum(rr_wartoscpln) AS pln,rr_no,rr_idwaluty,sum(rr_kwotawalfornorm) AS walnorm,min(bk_idbanku) AS bk_idbanku
           FROM kr_rozrachunki 	  
	   WHERE tr_idtrans=_NEW.tr_idtrans AND rr_no IN (6,7)
	   GROUP BY rr_no,rr_idwaluty
  LOOP
   PERFORM updateRozrachunkiTrans(_NEW.tr_idtrans,_NEW.k_idklienta,r.bk_idbanku,-r.wal,NULL,r.rr_idwaluty,_NEW.tr_zamknieta,_NEW.tr_flaga,_NEW.tr_newflaga,(CASE WHEN (_NEW.tr_zamknieta&(1<<21))=0 THEN _NEW.tr_datawystaw ELSE _NEW.tr_datasprzedaz END),_NEW.tr_dataplatnosci,_NEW.tr_formaplat,FALSE,_NEW.fm_idcentrali,r.rr_no-2,-r.pln,-r.walnorm);
  END LOOP;
 END IF;
 
 RETURN true;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
 PERFORM updateRozrachunkiTrans(_NEW.tr_idtrans,_NEW.k_idklienta,_NEW.bk_idbankuwal,_wartosc,_kurs,_NEW.wl_idwaluty,_NEW.tr_zamknieta,_NEW.tr_flaga,_NEW.tr_newflaga,(CASE WHEN (_NEW.tr_zamknieta&(1<<21))=0 THEN _NEW.tr_datawystaw ELSE _NEW.tr_datasprzedaz END),_NEW.tr_dataplatnosci,_NEW.tr_formaplat,FALSE,_NEW.fm_idcentrali,0+_deltano);
 IF ((_NEW.tr_newflaga&(1<<23))!=0) THEN     -- VAT w PLNach
  _vat=gm.correctRozrachunekTransByRozliczenieZaliczkowe(_vat,_NEW.wl_idwaluty,_NEW.tr_idtrans,1+_deltano);
  PERFORM updateRozrachunkiTrans(_NEW.tr_idtrans,_NEW.k_idklienta,_NEW.bk_idbankupln,round(_vat*_kursvat,2),1,1,_NEW.tr_zamknieta,_NEW.tr_flaga,_NEW.tr_newflaga,(CASE WHEN (_NEW.tr_zamknieta&(1<<21))=0 THEN _NEW.tr_datawystaw ELSE _NEW.tr_datasprzedaz END),_NEW.tr_dataplatnosci,_NEW.tr_formaplat,FALSE,_NEW.fm_idcentrali,1+_deltano,NULL,_vat);
 ELSE 
  PERFORM updateRozrachunkiTrans(_NEW.tr_idtrans,_NEW.k_idklienta,_NEW.bk_idbankuwal,_vat,_kursvat,_NEW.wl_idwaluty,_NEW.tr_zamknieta,_NEW.tr_flaga,_NEW.tr_newflaga,(CASE WHEN (_NEW.tr_zamknieta&(1<<21))=0 THEN _NEW.tr_datawystaw ELSE _NEW.tr_datasprzedaz END),_NEW.tr_dataplatnosci,_NEW.tr_formaplat,FALSE,_NEW.fm_idcentrali,1+_deltano);
 END IF;
 IF (_NEW.tr_flaga&(1<<21)<>0) THEN    ---- Dokument jest FV zaliczkowa lub ZO posiada faktury zaliczkowe
  PERFORM updateRozrachunkiTrans(_NEW.tr_idtrans,_NEW.k_idklienta,_NEW.bk_idbankuwal,_wartosc,_kurs,_NEW.wl_idwaluty,_NEW.tr_zamknieta,_NEW.tr_flaga,_NEW.tr_newflaga,(CASE WHEN (_NEW.tr_zamknieta&(1<<21))=0 THEN _NEW.tr_datawystaw ELSE _NEW.tr_datasprzedaz END),_NEW.tr_dataplatnosci,_NEW.tr_formaplat,TRUE,_NEW.fm_idcentrali,0+_deltano);
  PERFORM updateRozrachunkiTrans(_NEW.tr_idtrans,_NEW.k_idklienta,_NEW.bk_idbankuwal,_vat,_kursvat,_NEW.wl_idwaluty,_NEW.tr_zamknieta,_NEW.tr_flaga,_NEW.tr_newflaga,(CASE WHEN (_NEW.tr_zamknieta&(1<<21))=0 THEN _NEW.tr_datawystaw ELSE _NEW.tr_datasprzedaz END),_NEW.tr_dataplatnosci,_NEW.tr_formaplat,TRUE,_NEW.fm_idcentrali,1+_deltano);
 END IF;
 RETURN TRUE;
END;
$$;
