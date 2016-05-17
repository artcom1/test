CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
	typ ALIAS FOR $1;
	
	lp integer;

	r record;
	s record;
BEGIN

	FOR r IN SELECT st_rodzaj FROM ts_statusy WHERE st_type = typ GROUP BY st_rodzaj
	LOOP
		lp = 0;

		FOR s IN SELECT st_idstatusu, st_lp, st_flaga FROM ts_statusy WHERE st_type = typ AND st_rodzaj = r.st_rodzaj ORDER BY st_lp ASC, st_nazwa ASC
		LOOP
			IF ((s.st_flaga&1)=1) THEN
				lp = lp + 1;
				UPDATE ts_statusy SET st_lp=lp WHERE st_idstatusu=s.st_idstatusu;
			ELSE
				UPDATE ts_statusy SET st_lp=NULL WHERE st_idstatusu=s.st_idstatusu;
			END IF;
		END LOOP;
	END LOOP;

	RETURN lp;
END;
$_$;
