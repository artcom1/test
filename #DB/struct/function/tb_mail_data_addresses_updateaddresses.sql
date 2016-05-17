CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $$
DECLARE 
mail_id_1 INT;
mail_id_2 INT;
BEGIN

	IF (TG_OP = 'INSERT') THEN
		mail_id_1 =  NEW.mal_mail_id;
		mail_id_2 = NEW.mal_mail_id;
	ELSIF (TG_OP = 'UPDATE') THEN
		mail_id_1 =  NEW.mal_mail_id;
		mail_id_2 = OLD.mal_mail_id;
	ELSIF (TG_OP = 'DELETE') THEN
		mail_id_1 = OLD.mal_mail_id;
		mail_id_2 = OLD.mal_mail_id;
	END IF;

	UPDATE tb_mail_data AS mail 
	SET 
		mail_address_from = (SELECT array_to_string(array_agg(_mal.mal_address), '; ') FROM tb_mail_data_addresses AS _mal WHERE _mal.mal_mail_id= mail.mail_id AND (_mal.mal_flag&3)=0),
		mail_address_to = (SELECT array_to_string(array_agg(_mal.mal_address), '; ') FROM tb_mail_data_addresses AS _mal WHERE _mal.mal_mail_id= mail.mail_id AND (_mal.mal_flag&3)<>0)
	WHERE mail.mail_id = mail_id_1 OR mail.mail_id = mail_id_2;

RETURN NULL;
END;
$$;
