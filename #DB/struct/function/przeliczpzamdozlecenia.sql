CREATE FUNCTION przeliczpzamdozlecenia(integer, integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
---pierwszy argument tr_idtrans, 
---drugi argument zl_idzlecenia ktore jest podpiete pod dokument
---trzeci argument zl_idzlecenia ktore bylo podpiete pod dokument
DECLARE
 dane RECORD;
BEGIN
RAISE NOTICE 'jestem w przeliczpzamdozlecenia ';
 FOR dane IN SELECT sum(Round(getWartoscNetto(te.tel_ilosc,te.tel_cenawal,te.tel_cenabwal,te.tel_flaga,te.tel_stvat)*te.tel_kurswal,2)) AS wartosc_netto  ,sum(Round(getWartoscBrutto(te.tel_ilosc,te.tel_cenawal,te.tel_cenabwal,te.tel_flaga,te.tel_stvat)*te.tel_kurswal,2)) AS wartosc_brutto  FROM tg_transelem AS te  WHERE  (te.tr_idtrans=$1) AND ((te.tel_flaga&5120)<>1024) AND (te.tel_flaga&32768=0) 
  LOOP
    IF ($2>0) THEN
    RAISE NOTICE 'zwiekszam zlecenie przelicz ';
      UPDATE tg_zlecenia SET  zl_planprzychod=zl_planprzychod+dane.wartosc_netto,zl_planprzychodbrt=zl_planprzychodbrt+dane.wartosc_brutto WHERE zl_idzlecenia=$2;
    END IF;
    IF ($3>0) THEN
        RAISE NOTICE 'zmniejszam zlecenie przelicz ';
      UPDATE tg_zlecenia SET  zl_planprzychod=zl_planprzychod-dane.wartosc_netto,zl_planprzychodbrt=zl_planprzychodbrt-dane.wartosc_brutto WHERE zl_idzlecenia=$3;
    END IF;
  END LOOP;
 RETURN TRUE;
END;
$_$;
