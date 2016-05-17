CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _OLD ALIAS FOR $1;
 _NEW ALIAS FOR $2;
 rold vat.tb_vat;    --- Rekord stary
 rnew vat.tb_vat;    --- Rekord nowy
 roldwal vat.tb_vat;   --- Rekord stary (w walucie)
 rnewwal vat.tb_vat;   --- Rekord nowy (w walucie)
 roldwalk vat.tb_vat;   --- Rekord stary (w walucie)
 rnewwalk vat.tb_vat;   --- Rekord nowy (w walucie)
 ile INT;
 ret BOOL:=FALSE;
BEGIN

 IF (_OLD.tel_idelem IS NOT NULL) THEN
  IF (vat.disableRecalcing(_OLD.tr_idtrans,0)>0) THEN
---   RAISE NOTICE 'Need ',_OLD.tr_idtrans;
   PERFORM vat.markNeedRecalc(_OLD.tr_idtrans);
   RETURN FALSE;
  END IF;
  rold=vat.createInfo(_OLD,FALSE,FALSE);
  roldwal=vat.createInfo(_OLD,TRUE,FALSE);
  roldwalk=vat.createInfo(_OLD,TRUE,TRUE);
 END IF;

 IF (_NEW.tel_idelem IS NOT NULL) THEN
  IF (vat.disableRecalcing(_NEW.tr_idtrans,0)>0) THEN
---   RAISE NOTICE 'Need ',_O.tr_idtrans;
   PERFORM vat.markNeedRecalc(_NEW.tr_idtrans);
   RETURN FALSE;
  END IF;
  rnew=vat.createInfo(_NEW,FALSE,FALSE);
  rnewwal=vat.createInfo(_NEW,TRUE,FALSE);
  rnewwalk=vat.createInfo(_NEW,TRUE,TRUE);
 END IF;

 IF (rold==rnew) THEN
  rnew=rnew-rold;
  rold=NULL;
 END IF;
 IF (roldwal==rnewwal) THEN
  rnewwal=rnewwal-roldwal;
  roldwal=NULL;
 END IF;
 IF (roldwalk==rnewwalk) THEN
  rnewwalk=rnewwalk-roldwalk;
  roldwalk=NULL;
 END IF;

 
 IF (vat.updateVatInfo(vat.notInfo(rold)) IS NOT NULL) THEN
  ret=TRUE;
 END IF;
 IF (vat.updateVatInfo(rnew) IS NOT NULL) THEN
  ret=TRUE;
 END IF;
 IF (vat.updateVatInfo(vat.notInfo(roldwal)) IS NOT NULL) THEN
  ret=TRUE;
 END IF;
 IF (vat.updateVatInfo(rnewwal) IS NOT NULL) THEN
  ret=TRUE;
 END IF;
 IF (vat.updateVatInfo(vat.notInfo(roldwalk)) IS NOT NULL) THEN
  ret=TRUE;
 END IF;
 IF (vat.updateVatInfo(rnewwalk) IS NOT NULL) THEN
  ret=TRUE;
 END IF;

 RETURN ret;
END;
$_$;
