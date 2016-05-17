CREATE FUNCTION oniu_tb_zdarzenia_for_mail() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
mail RECORD;
BEGIN
	IF NEW.zd_rodzaj=13 THEN
		SELECT mail_date, mail_subject, mail_flag INTO mail FROM tb_mail_data WHERE mail_id=NEW.zd_mail_id;

		IF mail IS NOT NULL THEN
			IF ((mail.mail_flag&(3<<1))>>1) <> 1 THEN
				NEW.zd_datarozpoczecia = mail.mail_date;
				NEW.zd_datazakonczenia = mail.mail_date;
			END IF;

			NEW.zd_temat = mail.mail_subject;

			RAISE NOTICE '%', mail.mail_subject;
			RAISE NOTICE '%', NEW.zd_temat;
		END IF;
	END IF;

	RETURN NEW;
END;
$$;
