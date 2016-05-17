CREATE FUNCTION recalcplatfifo(integer, date) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
    _idbanku ALIAS FOR $1;
    _data ALIAS FOR $2;

    r RECORD;
BEGIN

 DELETE FROM kh_platfifo WHERE pl_idplatnosc IN (SELECT pl_idplatnosc FROM kh_platnosci WHERE bk_idbanku=_idbanku AND pl_datawplywu>=_data AND pl_wplyw<0);
 DELETE FROM kh_platfifo WHERE bk_idbanku=_idbanku AND po_datakursu>=_data AND po_wplyw>0;

 UPDATE kh_platnosci SET pl_idplatnosc=pl_idplatnosc WHERE bk_idbanku=_idbanku AND pl_datawplywu>=_data AND pl_wplyw>0;

 FOR r IN SELECT pl_idplatnosc,pl_datawplywu FROM kh_platnosci WHERE bk_idbanku=_idbanku AND pl_datawplywu>=_data AND pl_wplyw<0 ORDER BY pl_datawplywu,pl_idplatnosc
 LOOP
  RAISE NOTICE 'Platnosc % %',r.pl_idplatnosc,r.pl_datawplywu;
  UPDATE kh_platnosci SET pl_idplatnosc=pl_idplatnosc WHERE pl_idplatnosc=r.pl_idplatnosc;
 END LOOP;
  
 RETURN TRUE;
END;
$_$;
