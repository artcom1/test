CREATE FUNCTION onadkartotekadelegacji() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
BEGIN
	IF (TG_OP='DELETE') THEN
		UPDATE ts_kartotekadelegacji SET kd_priorytet=kd_priorytet-1 WHERE kd_priorytet>OLD.kd_priorytet;
	END IF;

	IF (TG_OP='DELETE') THEN
		RETURN OLD;
	ELSE
		RETURN NEW;
	END IF;
END;
$$;
