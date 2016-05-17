CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _a ALIAS FOR $1;
 _b ALIAS FOR $2;
 ret vat.tb_vat;
BEGIN
 IF (_a.v_id IS NOT NULL AND _b.v_id IS NOT NULL) THEN
  RAISE EXCEPTION 'Blad vInfo';
 END IF;

 ret=_a;
 ret.v_id=COALESCE(ret.v_id,_b.v_id);

 -------------------------------------------------------
 ret.v_netnetto=ret.v_netnetto-_b.v_netnetto;
 ret.v_netvatn=ret.v_netvatn-_b.v_netvatn;
 ret.v_netvatb=ret.v_netvatb-_b.v_netvatb;
 ret.v_netbrutto=ret.v_netbrutto-_b.v_netbrutto;
 -------------------------------------------------------
 ret.v_nettokgo=ret.v_nettokgo-_b.v_nettokgo;
 ret.v_vatkgon=ret.v_vatkgon-_b.v_vatkgon;
 ret.v_vatkgob=ret.v_vatkgob-_b.v_vatkgob;
 ret.v_bruttokgo=ret.v_bruttokgo-_b.v_bruttokgo;
 -------------------------------------------------------
 ret.v_netto=ret.v_netto-_b.v_netto;
 ret.v_vatn=ret.v_vatn-_b.v_vatn;
 ret.v_vatb=ret.v_vatb-_b.v_vatb;
 ret.v_brutto=ret.v_brutto-_b.v_brutto;
 -------------------------------------------------------

 ret.v_iloscpoz=ret.v_iloscpoz-_b.v_iloscpoz;
 ret.v_ilosc0cena=ret.v_ilosc0cena-_b.v_ilosc0cena;
 ret.v_iloscwyd=ret.v_iloscwyd-_b.v_iloscwyd;
 ret.v_iloscpozusl=ret.v_iloscpozusl-_b.v_iloscpozusl;

 RETURN ret;
END;
$_$;
