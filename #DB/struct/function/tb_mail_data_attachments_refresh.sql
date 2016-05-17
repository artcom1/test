CREATE FUNCTION tb_mail_data_attachments_refresh() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
mail_id_1 INT;
mail_id_2 INT;
BEGIN

	IF (TG_OP = 'INSERT') THEN
		mail_id_1 =  NEW.mat_mail_id;
		mail_id_2 = NEW.mat_mail_id;
	ELSIF (TG_OP = 'UPDATE') THEN
		mail_id_1 =  NEW.mat_mail_id;
		mail_id_2 = OLD.mat_mail_id;
	ELSIF (TG_OP = 'DELETE') THEN
		mail_id_1 = OLD.mat_mail_id;
		mail_id_2 = OLD.mat_mail_id;
	END IF;

	UPDATE tb_mail_data AS mail 
	SET 
	    mail_flag = (CASE WHEN EXISTS (SELECT * FROM tb_mail_data_attachments AS _mat WHERE _mat.mat_mail_id = mail.mail_id LIMIT 1) 
		             THEN (mail_flag | (1<<7))
					 ELSE (mail_flag & ~(1<<7))
					 END)
	WHERE mail.mail_id = mail_id_1 OR mail.mail_id = mail_id_2;

RETURN NULL;
END;
$$;
