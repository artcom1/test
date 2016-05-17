CREATE FUNCTION renumeracjaetapowzlecen(integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
	typ ALIAS FOR $1; 
	lp integer;
	r record;

	oldtyp integer;
BEGIN
	lp = 0;

	FOR r IN SELECT szl_idstatusu, szl_lp, szl_opis, szl_rodzajzlecenia FROM ts_statuszlecenia WHERE (szl_flaga&112)=(typ<<4) ORDER BY szl_lp ASC, szl_opis ASC
	LOOP
		IF (r.szl_rodzajzlecenia<0 OR oldtyp<0 OR r.szl_rodzajzlecenia=oldtyp) THEN
			lp = lp + 1;
		END IF;
		IF (lp = 0) THEN
			lp = 1;
		END IF;
		UPDATE ts_statuszlecenia SET szl_lp=lp WHERE szl_idstatusu=r.szl_idstatusu AND (szl_flaga&112)=(typ<<4);

		oldtyp = r.szl_rodzajzlecenia;
	END LOOP;

	RETURN lp;
END;
$_$;
