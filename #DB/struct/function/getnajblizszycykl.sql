CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
idcyklu ALIAS FOR $1;

data TIMESTAMP WITH TIME ZONE;
dataz TIMESTAMP WITH TIME ZONE;
ret TIMESTAMP WITH TIME ZONE;
dtemp TIMESTAMP WITH TIME ZONE;
dnow TIMESTAMP WITH TIME ZONE;

lp INT;
mn INT;
war BOOLEAN;
okres INTERVAL;
rec RECORD;
BEGIN
war := TRUE;
lp := 0;
dnow := now();

SELECT zd_datarozpoczecia, ck_okres, ck_datazakonczenia INTO data, okres, dataz FROM tb_cyklicznosc JOIN tb_zdarzenia USING (zd_idzdarzenia)
WHERE ck_idcyklu = idcyklu;

ret := data + lp * okres;

IF (okres = '+1 days'::interval) THEN
IF (date(ret) < date(dnow)) THEN
lp := date(dnow) - date(ret);
ret := date_part('year', date(dnow))::text || '-' || date_part('month', date(dnow))::text || '-' || date_part('day', date(dnow))::text ||' '|| ret::time;
END IF;
END IF;

--zwracamy daty dla okresu tygodniowego
IF (okres = '+1 week'::interval) THEN
IF (date(ret) < date(dnow)) THEN
lp := floor((date(dnow) - date(ret))::int / 7) + 1;
ret := ret + lp * ('+1 week')::interval;
END IF;
END IF;

--zwracamy daty dla okresu miesiecznego
IF (okres = '+1 month'::interval) THEN
IF (ret < date(dnow)) THEN
lp := getRoznicaLat(date(dnow), date(ret)) * 12;
ELSE
lp := 0;
END IF;
ret := data + lp * '+1 month'::interval;
IF (date(ret) < date(dnow)) THEN
WHILE (date(ret) < date(dnow)) LOOP
lp := lp + 1;
ret := data + lp * '+1 month'::interval;
END LOOP;
ELSE
WHILE ((date(ret) - '1 month'::interval) > date(dnow) AND (date(ret) - '1 month'::interval) > data) LOOP
lp := lp - 1;
ret := data + lp * '+1 month'::interval;
END LOOP;
END IF;
END IF;

--zwracamy daty dla okresu kwartalnego
IF (okres = '+3 months'::interval) THEN
IF (ret < date(dnow)) THEN
lp := getRoznicaLat(dnow, date(ret)) * 4;
ELSE
lp := 0;
END IF;
ret := data + lp * '+3 months'::interval;
IF (date(data) < date(dnow)) THEN
WHILE (date(data) < date(dnow)) LOOP
lp := lp + 1;
ret := data + lp * '+3 months'::interval;
END LOOP;
ELSE
WHILE ((date(ret) - '3 months'::interval) > date(dnow) AND (date(ret) - '3 months'::interval) > data) LOOP
lp := lp - 1;
ret := data + lp * '+3 months'::interval;
END LOOP;
END IF;
END IF;

--zwracamy daty dla okresu rocznego
IF (okres = '+1 year'::interval) THEN
IF (date(ret) < date(dnow)) THEN
lp := getRoznicaLat(date(dnow), date(ret));
IF ((data + okresc * '+1 year'::interval) < date(dnow)) THEN
lp := lp + 1;
END IF;
ELSE
lp := 0;
END IF;
ret := data + lp * '+1 year'::interval;
END IF;

mn := -1;

WHILE (war = TRUE) LOOP
ret := data + lp * okres;
IF (ret < data) THEN
mn := 1;
END IF;

IF (ret > dataz) THEN
war := FALSE;
RETURN NULL;
END IF;

IF (NOT zdarzeniacykliczne_iswyjatek(idcyklu, ret) AND ((ret < dnow AND mn < 0) OR (ret > dnow AND mn > 0))) THEN
war := FALSE;
END IF;

lp := lp + (mn * 1);
END LOOP;

RETURN ret;
END;
$_$;
