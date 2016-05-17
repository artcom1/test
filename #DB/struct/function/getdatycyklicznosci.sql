CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
	zd_idzdarzenia ALIAS FOR $1; --ID zdarzenia
	ck_datarozpoczecia ALIAS FOR $2; --data rozpoczecia cyklicznosci
	ck_datazakonczenia ALIAS FOR $3; --data zakonczenia cyklicznosci

	dataod ALIAS FOR $4; --filtr daty
	datado ALIAS FOR $5; --filtr daty

	ck_okres ALIAS FOR $6; --okres cyklicznosci

	dataz TIMESTAMP WITH TIME ZONE;
	datar TIMESTAMP WITH TIME ZONE;
	data TIMESTAMP WITH TIME ZONE;

	okresc INT;
	licz INT;
	ck_lp INT;
	ret RECORD;
BEGIN
	ck_lp := 0;
	datar := ck_datarozpoczecia;
	dataz := ck_datazakonczenia;

	--zwracamy daty dla okresu dziennego
	IF (ck_okres = '+1 days'::interval) THEN
		IF (date(datar) < dataod) THEN
			ck_lp := date(dataod) - date(datar);
			datar := date_part('year', dataod)::text || '-' || date_part('month', dataod)::text || '-' || date_part('day', dataod)::text ||' '|| datar::time;	
		END IF;

		WHILE (date(datar) <= datado AND datar <= dataz) LOOP
			SELECT zd_idzdarzenia, ck_lp, datar INTO ret;
			ck_lp := ck_lp + 1;
			RETURN NEXT ret;

			datar := datar + '+1 days'::interval;
		END LOOP;
		RETURN;
	END IF;

	--zwracamy daty dla okresu tygodniowego
	IF (ck_okres = '+1 week'::interval) THEN
		IF (date(datar) < dataod) THEN
			okresc := floor((dataod - date(datar))::int / 7) + 1;
			datar := datar + okresc * ('+1 week')::interval;
			ck_lp := okresc;
		END IF;
	
		WHILE (date(datar) <= datado AND datar <= dataz) LOOP
			SELECT zd_idzdarzenia, ck_lp, datar INTO ret;
			ck_lp := ck_lp + 1;
			RETURN NEXT ret;

			datar := datar + '+1 week'::interval;
		END LOOP;
		RETURN;
	END IF;
	
	--zwracamy daty dla okresu miesiecznego
	IF (ck_okres = '+1 month'::interval) THEN
		IF (datar < dataod) THEN
			licz := getRoznicaLat(dataod, date(datar)) * 12;
		ELSE
			licz := 0;
		END IF;
		data := datar + licz * '+1 month'::interval;
		IF (date(data) < dataod) THEN
			WHILE (date(data) < dataod) LOOP
				licz := licz + 1;
				data := datar + licz * '+1 month'::interval;
			END LOOP;
		ELSE
			WHILE ((date(data) - '1 month'::interval) > dataod AND (date(data) - '1 month'::interval) > datar) LOOP
				licz := licz - 1;
				data := datar + licz * '+1 month'::interval;
			END LOOP;		
		END IF;

		ck_lp := licz;
	
		WHILE (date(data) <= datado AND data <= dataz) LOOP
			SELECT zd_idzdarzenia, ck_lp, data INTO ret;
			ck_lp := ck_lp + 1;
			RETURN NEXT ret;
			licz := licz + 1;
			data := datar + licz * '+1 month'::interval;
		END LOOP;
		RETURN;
	END IF;

	--zwracamy daty dla okresu kwartalnego
	IF (ck_okres = '+3 months'::interval) THEN
		IF (data < dataod) THEN
			licz := getRoznicaLat(dataod, date(datar)) * 4;
		ELSE
			licz := 0;
		END IF;
		data := datar + licz * '+3 months'::interval;
		IF (date(data) < dataod) THEN
			WHILE (date(data) < dataod) LOOP
				licz := licz + 1;
				data := datar + licz * '+3 months'::interval;
			END LOOP;
		ELSE
			WHILE ((date(data) - '3 months'::interval) > dataod AND (date(data) - '3 months'::interval) > datar) LOOP
				licz := licz - 1;
				data := datar + licz * '+3 months'::interval;
			END LOOP;
		END IF;
		
		ck_lp := licz;
		
		WHILE (date(data) <= datado AND data <= dataz) LOOP
			SELECT zd_idzdarzenia, ck_lp, data INTO ret;
			ck_lp := ck_lp + 1;
			RETURN NEXT ret;
			licz := licz + 1;
			data := datar + licz * '+3 months'::interval;
		END LOOP;
		RETURN;
	END IF;

	--zwracamy daty dla okresu rocznego
	IF (ck_okres = '+1 year'::interval) THEN
		IF (date(datar) < dataod) THEN
			okresc := getRoznicaLat(dataod, date(datar));
			IF ((datar + okresc * '+1 year'::interval) < dataod) THEN
				okresc := okresc + 1;
			END IF;
		ELSE
			okresc := 0;
		END IF;
		ck_lp := okresc;
		licz := 0;
		data := datar + (okresc + licz) * '+1 year'::interval;
		WHILE (date(data) <= datado AND data <= dataz) LOOP
			IF (date(data) >= dataod) THEN
				SELECT zd_idzdarzenia, ck_lp, data INTO ret;
				ck_lp := ck_lp + 1;
				RETURN NEXT ret;
			END IF;
			licz := licz + 1;
			data := datar + (okresc + licz) * '+1 year'::interval;
		END LOOP;
		RETURN;
	END IF;

	RETURN;
END;
$_$;
