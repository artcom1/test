CREATE FUNCTION oniudkliencizdarzenia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	kzd record;
BEGIN
	IF (TG_OP='INSERT') THEN
	    IF ((SELECT count(*) FROM tb_kliencizdarzenia WHERE zd_idzdarzenia=NEW.zd_idzdarzenia AND kzd_idklientazd!=NEW.kzd_idklientazd)=0) THEN
		UPDATE tb_kliencizdarzenia SET kzd_flaga=(kzd_flaga|1) WHERE kzd_idklientazd = NEW.kzd_idklientazd;
	        UPDATE tb_zdarzenia SET k_idklienta=NEW.k_idklienta, lk_idczklienta=NEW.lk_idczklienta WHERE zd_idzdarzenia=NEW.zd_idzdarzenia;
	    END IF;
	END IF;

	IF (TG_OP='UPDATE') THEN
		IF ((NEW.kzd_flaga&1)=1) THEN
			IF ((OLD.kzd_flaga&1)=0) THEN
				UPDATE tb_kliencizdarzenia SET kzd_flaga=kzd_flaga-1 WHERE (kzd_flaga&1)=1 AND kzd_idklientazd!=NEW.kzd_idklientazd AND zd_idzdarzenia=NEW.zd_idzdarzenia;
			END IF;
			UPDATE tb_zdarzenia SET k_idklienta=NEW.k_idklienta, lk_idczklienta=NEW.lk_idczklienta WHERE zd_idzdarzenia=NEW.zd_idzdarzenia;
		END IF;
	END IF;

	IF (TG_OP='DELETE') THEN
		IF ((OLD.kzd_flaga&1)=1) THEN
			SELECT kzd_idklientazd, zd_idzdarzenia, k_idklienta, lk_idczklienta INTO kzd FROM tb_kliencizdarzenia WHERE kzd_idklientazd = (SELECT min(kzd_idklientazd) FROM tb_kliencizdarzenia WHERE zd_idzdarzenia = OLD.zd_idzdarzenia AND kzd_idklientazd != OLD.kzd_idklientazd);

			UPDATE tb_kliencizdarzenia SET kzd_flaga=(kzd_flaga|1) WHERE kzd_idklientazd = kzd.kzd_idklientazd;
			UPDATE tb_zdarzenia SET k_idklienta = kzd.k_idklienta, lk_idczklienta = kzd.lk_idczklienta WHERE zd_idzdarzenia = kzd.zd_idzdarzenia;
		END IF;
	END IF;

	IF (TG_OP='DELETE') THEN
		RETURN OLD;
	ELSE
		RETURN NEW;
	END IF;
END;
$$;
