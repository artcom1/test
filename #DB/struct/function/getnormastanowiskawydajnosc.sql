CREATE FUNCTION getnormastanowiskawydajnosc(integer, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _the_idelem   ALIAS FOR $1;
 _ob_idobiektu ALIAS FOR $2;
 wynik      NUMERIC:=0;
BEGIN
 wynik=(SELECT COALESCE(tsp.tsp_wydajnosc,te.the_wydajnosc) AS tsp_tpz FROM tr_technoelem AS te LEFT JOIN tr_technostpracy AS tsp USING (the_idelem) LEFT JOIN tg_obiekty AS ob ON (ob.ob_idobiektu=tsp.ob_idobiektu) WHERE te.the_idelem=_the_idelem AND (tsp.tsp_flaga&4=0 OR tsp.tsp_flaga=null) AND (tsp.ob_idobiektu=null OR tsp.ob_idobiektu=_ob_idobiektu OR (tsp.tsp_flaga&8=8 AND ob.rb_idrodzaju=(SELECT rb_idrodzaju FROM tg_obiekty WHERE ob_idobiektu=_ob_idobiektu)) ) ORDER BY tsp_flaga&8 LIMIT 1);
 RETURN wynik;
END;
$_$;
