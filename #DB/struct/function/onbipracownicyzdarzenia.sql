CREATE FUNCTION onbipracownicyzdarzenia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

	IF ((NEW.pzd_flaga&1)=1) THEN  
		DELETE FROM tb_pracownicyzdarzenia WHERE p_idpracownika=NEW.p_idpracownika AND zd_idzdarzenia=NEW.zd_idzdarzenia;
	ELSE		
		IF EXISTS (SELECT 1 FROM tb_pracownicyzdarzenia WHERE p_idpracownika=NEW.p_idpracownika AND zd_idzdarzenia=NEW.zd_idzdarzenia) THEN
			RETURN NULL;
		END IF;
	END IF;

	RETURN NEW;  
 
END;
$$;
