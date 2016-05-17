CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
	dataod ALIAS FOR $1; --filtr daty
	datado ALIAS FOR $2; --filtr daty
	filtry ALIAS FOR $3;

	rec RECORD;
	ret RECORD;
	lp INT;
	q TEXT;
	dt TEXT;
BEGIN
	q := filtry;
	IF (q = '') THEN
		q := '(1=1)';
	END IF;

	q = 'SELECT ck_idcyklu, zd.zd_idzdarzenia, zd.zd_datarozpoczecia, ck_datazakonczenia, ck_okres FROM tb_cyklicznosc JOIN tb_zdarzenia AS zd USING (zd_idzdarzenia) WHERE '||q||' AND isCyklInOkres('''||$1||''', '''||$2||''', date(zd.zd_datarozpoczecia), date(ck_datazakonczenia), ck_okres) = TRUE ORDER BY zd_datarozpoczecia, ck_datazakonczenia ASC ';

	--dla kazdego zdarzenia ktore posiada cykl i miesci sie w zadanym okresie...
	FOR rec IN EXECUTE q LOOP
		-- ...pobieramy rekordy z przyszlymi datami zdarzenia cyklicznego
		FOR ret IN (SELECT a.zd_idzdarzenia, ck_lp, a.datarozp, (a.datarozp + (zd.zd_datazakonczenia - zd.zd_datarozpoczecia)) AS datazak 
		            FROM getDatyCyklicznosci(rec.zd_idzdarzenia, rec.zd_datarozpoczecia, rec.ck_datazakonczenia, dataod, datado, rec.ck_okres) AS a(zd_idzdarzenia INT, ck_lp INT, datarozp TIMESTAMP WITH TIME ZONE) 
					JOIN tb_zdarzenia AS zd USING (zd_idzdarzenia) 
					WHERE NOT EXISTS (SELECT cw_idwyjatku FROM tb_cyklwyjatki WHERE ck_idcyklu = rec.ck_idcyklu AND cw_lp = a.ck_lp)) 
		LOOP			
			RETURN NEXT ret;
		END LOOP;			
	END LOOP;
	
	RETURN;
END;
$_$;
