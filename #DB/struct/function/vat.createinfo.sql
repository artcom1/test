CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _REC            ALIAS FOR $1;
 _iswal          ALIAS FOR $2; --- Czy w walucie
 _retkgo         ALIAS FOR $3; --- Czy dla waluty zwracac wartosc KGO (trzeba osobno bo KGO bedzie w walucie dokumentu)
 ret             vat.tb_vat;
 isHidden        BOOL;
 hasValuesHidden BOOL;
BEGIN

 IF (_REC.tel_flaga&128=128) THEN
  RETURN NULL;
 END IF;
 
 hasValuesHidden=((_REC.tel_new2flaga&(1<<12))!=0); 
 isHidden=((_REC.tel_flaga & (1024 | 32768)) = 1024);
 
 IF (iscopied(_REC.tel_flaga)=FALSE  AND ((isHidden=true) AND (_REC.tel_skojzestaw IS NULL))) THEN
  RETURN NULL;
 END IF;

 --Oryginalny: Jest to kopia lub nie ma kopii
 --Aktualny: ma kopie lub nie ma kopii

 IF (_REC.tel_idelem IS NOT NULL) THEN
  ret.tr_idtrans=_REC.tr_idtrans;
  ret.v_stvat=_REC.tel_stvat;
  ret.v_zw=(_REC.tel_flaga & (3 | (1 << 31)));
  ret.v_zw=((ret.v_zw & 3) | (((ret.v_zw >> 31) & 1) << 2));
  ret.v_isorg=0;
  IF ((_REC.tel_flaga&(1<<15))<>0) THEN --32768
   ret.v_isorg=(1<<0);  -- Posiada kopie
   IF (_REC.tel_flaga&1024)=1024 THEN
    RETURN NULL;
   END IF;
  END IF;
  IF ((_REC.tel_flaga&(1<<12))<>0) THEN --4096
   ret.v_isorg=(1<<1); -- Jest kopia
  END IF;
  ret.v_iscorr=((_REC.tel_flaga&(1<<26))<>0);
  ret.v_ispkormakro=((_REC.tel_flaga&(1<<22))<>0);
  ret.v_iskgoforwal=FALSE;
  ----Obliczenie netto/vat/brutto
  IF (_iswal=FALSE) OR (_retkgo=TRUE) THEN
   ret.v_iswal=FALSE;
   ret.v_idwaluty=NULL;
   ret.v_kurswal=_REC.tel_kursdok;
   ---------------------------------------------------------------------------------------------
   ret.v_netnetto=_REC.tel_wnettodok;
   ret.v_netbrutto=round(_REC.tel_cenabdok * _REC.tel_ilosc, 2);
   ---------------------------------------------------------------------------------------------
   ret.v_nettokgo=round(_REC.tel_cenakgodok*_REC.tel_iloscf,2);
   ret.v_bruttokgo=round(round(net2brt(_REC.tel_cenakgodok,_REC.tel_stvat),2) *_REC.tel_iloscf, 2);
   ---------------------------------------------------------------------------------------------
   ret.v_netto=ret.v_netnetto+ret.v_nettokgo;
   ret.v_brutto=ret.v_netbrutto+ret.v_bruttokgo;
   ---------------------------------------------------------------------------------------------
   ret.v_netvatn=round(vatfromnet(ret.v_netnetto,ret.v_stvat),2);
   ret.v_netvatb=round(vatfrombrt(ret.v_netbrutto,ret.v_stvat),2);
   ---------------------------------------------------------------------------------------------
   ret.v_vatkgon=round(vatfromnet(ret.v_nettokgo,ret.v_stvat),2);
   ret.v_vatkgob=round(vatfrombrt(ret.v_bruttokgo,ret.v_stvat),2);
   ---------------------------------------------------------------------------------------------
   ret.v_vatn=round(vatfromnet(ret.v_netnetto+ret.v_nettokgo,ret.v_stvat),2);
   ret.v_vatb=round(vatfrombrt(ret.v_netbrutto+ret.v_bruttokgo,ret.v_stvat),2);
   IF (_retkgo) THEN
    ---Nie ma KGO
    IF (ret.v_nettokgo=0) AND (ret.v_bruttokgo=0) THEN
     RETURN NULL;
    END IF;
    ret.v_netnetto=0;
    ret.v_netbrutto=0;
    ret.v_netvatn=0;
    ret.v_netvatb=0;
    ret.v_netto=ret.v_nettokgo;
    ret.v_brutto=ret.v_bruttokgo;
    ret.v_vatn=ret.v_vatkgon;
    ret.v_vatb=ret.v_vatkgob;
    ret.v_iskgoforwal=TRUE;
    ret.v_iswal=TRUE;
   END IF;
  ELSE
   ret.v_iswal=TRUE;
   ret.v_kurswal=_REC.tel_kurswal;
   ret.v_netnetto=_REC.tel_wnettowal;
   ret.v_idwaluty=_REC.tel_walutawal;
   ret.v_netvatn=round(vatfromnet(ret.v_netnetto,ret.v_stvat),2);
   ret.v_netbrutto=round(_REC.tel_cenabdok * _REC.tel_ilosc, 2);
   ret.v_netvatb=round(vatfrombrt(ret.v_netbrutto,ret.v_stvat),2);
   -------------------------------------------------------
   ret.v_netto=ret.v_netnetto;
   ret.v_vatn=ret.v_netvatn;
   ret.v_vatb=ret.v_netvatb;
   ret.v_brutto=ret.v_netbrutto;
   ret.v_nettokgo=0;
   ret.v_vatkgon=0;
   ret.v_vatkgob=0;
   ret.v_bruttokgo=0;
---   RAISE NOTICE 'A %',ret;
  END IF;

  IF (_retkgo=FALSE) AND (_REC.tel_cenawal=0) AND (_REC.tel_iloscf!=0) THEN
   ret.v_ilosc0cena=1;
  ELSE
   ret.v_ilosc0cena=0;
  END IF;
  
  IF ((_REC.tel_flaga&4)=4) THEN
   ret.v_iloscpozusl=1;
  ELSE
   ret.v_iloscpozusl=0;
  END IF;

  ret.v_iloscpoz=1;

  IF ( (isHidden AND (_REC.tel_skojzestaw IS NOT NULL)) OR (hasValuesHidden=TRUE)) THEN
   ret.v_netnetto=0;
   ret.v_netbrutto=0;
   ret.v_netvatn=0;
   ret.v_netvatb=0;
   ret.v_netto=0;
   ret.v_brutto=0;
   ret.v_vatn=0;
   ret.v_vatb=0;
   ret.v_nettokgo=0;
   ret.v_vatkgon=0;
   ret.v_vatkgob=0;
   ret.v_bruttokgo=0;
   ret.v_ilosc0cena=0;
   ret.v_iloscpoz=0;
   ret.v_iloscpozusl=0;
  END IF;

  ret.v_iloscwyd=abs(_REC.tel_iloscwyd);
 END IF;

 IF (_REC.tel_new2flaga&(1<<9))<>0 THEN
  ret.v_netnetto=-ret.v_netnetto;
  ret.v_netbrutto=-ret.v_netbrutto;
  ret.v_netvatn=-ret.v_netvatn;
  ret.v_netvatb=-ret.v_netvatb;
  ret.v_netto=-ret.v_netto;
  ret.v_brutto=-ret.v_brutto;
  ret.v_vatn=-ret.v_vatn;
  ret.v_vatb=-ret.v_vatb;
  ret.v_nettokgo=-ret.v_nettokgo;
  ret.v_vatkgon=-ret.v_vatkgon;
  ret.v_vatkgob=-ret.v_vatkgob;
  ret.v_bruttokgo=-ret.v_bruttokgo;
 END IF;

 RETURN ret;
END;
$_$;
