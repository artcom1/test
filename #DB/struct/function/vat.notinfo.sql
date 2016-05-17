CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _a ALIAS FOR $1;
 ret vat.tb_vat;
BEGIN

 IF (_a.tr_idtrans IS NULL) THEN
  RETURN _a;
 END IF;

 ret=_a;

 ret.v_netnetto=-ret.v_netnetto;
 ret.v_netvatn=-ret.v_netvatn;
 ret.v_netvatb=-ret.v_netvatb;
 ret.v_netbrutto=-ret.v_netbrutto;
 --------------------------------------
 ret.v_nettokgo=-ret.v_nettokgo;
 ret.v_vatkgon=-ret.v_vatkgon;
 ret.v_vatkgob=-ret.v_vatkgob;
 ret.v_bruttokgo=-ret.v_bruttokgo;
 --------------------------------------
 ret.v_netto=-ret.v_netto;
 ret.v_vatn=-ret.v_vatn;
 ret.v_vatb=-ret.v_vatb;
 ret.v_brutto=-ret.v_brutto;
 --------------------------------------

 ret.v_iloscpoz=-ret.v_iloscpoz;
 ret.v_ilosc0cena=-ret.v_ilosc0cena;
 ret.v_iloscwyd=-ret.v_iloscwyd;
 ret.v_iloscpozusl=-ret.v_iloscpozusl;

 RETURN ret;
END;
$_$;
