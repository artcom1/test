CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 inv       gm.DODAJ_PZ_TYPE;
 ret       gm.DODAJ_PZ_RETTYPE;
BEGIN
 inv.tel_idelem=$1;
 inv.tel_iloscf=0;
 inv.tel_wartosc=0;
 inv.tel_iloscrez=0;
 ret=gm.dodaj_pz(inv,TRUE);
 return ret.wartosc;
END;
$_$;
