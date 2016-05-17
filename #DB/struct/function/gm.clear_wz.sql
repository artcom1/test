CREATE FUNCTION clear_wz(integer, integer DEFAULT NULL::integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idelem ALIAS FOR $1;
 _idtex  ALIAS FOR $2;
 _inv gm.DODAJ_WZ_TYPE;
 _ret gm.DODAJ_WZ_RETTYPE;
BEGIN
 _inv.tel_iloscf=0;
 _inv.tel_idelem=_idelem;
 _inv.tex_idelem=_idtex;
 _ret=gm.dodaj_wz(_inv,TRUE);
 RETURN _ret.wartosc;
END;
$_$;
