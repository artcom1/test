CREATE FUNCTION getnajblizszeprzypominaczecykl(timestamp with time zone) RETURNS SETOF tb_cyklpprow
    LANGUAGE plpgsql
    AS $_$
DECLARE
datado ALIAS FOR $1;

dataod TIMESTAMP WITH TIME ZONE;
data TIMESTAMP WITH TIME ZONE;
dataz TIMESTAMP WITH TIME ZONE;
ret TIMESTAMP WITH TIME ZONE;
dtemp TIMESTAMP WITH TIME ZONE;

idcyklu INT;
lp INT;
war BOOLEAN;
okres INTERVAL;
roznica INTERVAL;

pp RECORD;
rec RECORD;
BEGIN
dataod := '1970-01-01 00:00';

FOR pp IN (SELECT ppm_id, zd_idzdarzenia FROM tb_pp JOIN tb_pracownicyzdarzenia ON (ppm_refid=pzd_idpracownika) JOIN tb_zdarzenia USING (zd_idzdarzenia) WHERE ppm_type = 210 AND ((zd_flaga&1536)>>9)=1) 
LOOP
war := TRUE;
lp := 0;

SELECT zd_datarozpoczecia - (zd_datarozpoczecia - zd_dataprzypomnienia), (zd_datarozpoczecia - zd_dataprzypomnienia), ck_idcyklu, ck_okres, ck_datazakonczenia - (zd_datarozpoczecia - zd_dataprzypomnienia) INTO data, roznica, idcyklu, okres, dataz FROM tb_cyklicznosc JOIN tb_zdarzenia USING (zd_idzdarzenia) WHERE tb_cyklicznosc.zd_idzdarzenia=pp.zd_idzdarzenia LIMIT 1;

IF (data <= datado AND dataz >= dataod) THEN
ret := data + lp * okres;
IF (okres = '+1 days'::interval) THEN
IF (date(ret) < dataod) THEN
lp := date(dataod) - date(ret);
ret := date_part('year', dataod)::text || '-' || date_part('month', dataod)::text || '-' || date_part('day', dataod)::text ||' '|| ret::time;
END IF;
END IF;

--zwracamy daty dla okresu tygodniowego
IF (okres = '+1 week'::interval) THEN
IF (date(ret) < dataod) THEN
lp := floor((dataod::date - date(ret))::int / 7) + 1;
ret := data + lp * ('+1 week')::interval;
END IF;
END IF;

--zwracamy daty dla okresu miesiecznego
IF (okres = '+1 month'::interval) THEN
IF (ret < dataod) THEN
lp := getRoznicaLat(dataod, date(ret)) * 12;
ELSE
lp := 0;
END IF;
ret := data + lp * '+1 month'::interval;
IF (date(ret) < dataod) THEN
WHILE (date(ret) < dataod) LOOP
lp := lp + 1;
ret := data + lp * '+1 month'::interval;
END LOOP;
ELSE
WHILE ((date(ret) - '1 month'::interval) > dataod AND (date(ret) - '1 month'::interval) > data) LOOP
lp := licz - 1;
ret := data + lp * '+1 month'::interval;
END LOOP;
END IF;
END IF;

--zwracamy daty dla okresu kwartalnego
IF (okres = '+3 months'::interval) THEN
IF (ret < dataod) THEN
lp := getRoznicaLat(dataod, date(ret)) * 4;
ELSE
lp := 0;
END IF;
ret := data + lp * '+3 months'::interval;
IF (date(data) < dataod) THEN
WHILE (date(data) < dataod) LOOP
lp := lp + 1;
ret := data + lp * '+3 months'::interval;
END LOOP;
ELSE
WHILE ((date(ret) - '3 months'::interval) > dataod AND (date(ret) - '3 months'::interval) > data) LOOP
lp := lp - 1;
ret := data + lp * '+3 months'::interval;
END LOOP;
END IF;
END IF;

--zwracamy daty dla okresu rocznego
IF (okres = '+1 year'::interval) THEN
IF (date(ret) < dataod) THEN
lp := getRoznicaLat(dataod, date(ret));
IF ((datar + okresc * '+1 year'::interval) < dataod) THEN
lp := lp + 1;
END IF;
ELSE
lp := 0;
END IF;
ret := data + lp * '+1 year'::interval;
END IF;

WHILE (war = TRUE) LOOP
ret := data + lp * okres;

IF (ret < dataz AND ret < datado) THEN
IF (NOT zdarzeniacykliczne_iswyjatek(idcyklu, ret + roznica)) THEN
dtemp := ret;
END IF;
ELSE
war := FALSE;
END IF;

lp := lp + 1;
END LOOP;

SELECT pp.ppm_id, lp - 1, dtemp INTO rec;
RETURN NEXT rec;
END IF;

END LOOP;

RETURN;
END;
$_$;
