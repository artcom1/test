CREATE FUNCTION onaiudtelefony() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
 tekst TEXT:='';
 r RECORD;
 typ INT;
 dt INT;
 id INT;
BEGIN

 IF (TG_OP='DELETE') THEN
  typ=OLD.ph_type;
  dt=OLD.ph_datatype;
  id=OLD.ph_id;
 ELSE
  typ=NEW.ph_type;
  dt=NEW.ph_datatype;
  id=NEW.ph_id;
 END IF;

 FOR r IN SELECT ph_phone,ph_wewnetrzny FROM tb_telefony WHERE ph_type=typ AND ph_datatype=dt AND ph_id=id AND ph_flaga&8=0 ORDER BY ph_idtelefonu ASC
 LOOP
  tekst=tekst||r.ph_phone;

  IF (r.ph_wewnetrzny IS NOT NULL) THEN
   tekst=tekst||'w'||r.ph_wewnetrzny;
  END IF;

  tekst=tekst||chr(201);
 END LOOP;

 tekst=substr(tekst,1,max(0,length(tekst)-1)::int);

 IF (typ=1) THEN
  IF (dt=1) THEN
   UPDATE tb_klient SET k_telefon=tekst WHERE k_idklienta=id AND (k_telefon<>tekst OR k_telefon IS NULL);
  END IF;
  IF (dt=35) THEN
   UPDATE tb_ludzieklienta SET lk_telefon=tekst WHERE lk_idczklienta=id AND (lk_telefon<>tekst OR lk_telefon IS NULL);
  END IF;
  IF (dt=11) THEN
   UPDATE tb_pracownicy SET p_telefon=tekst WHERE p_idpracownika=id AND (p_telefon<>tekst OR p_telefon IS NULL);
  END IF;
  IF (dt=66) THEN
   UPDATE tb_firma SET fm_telefon=tekst WHERE fm_index=id AND (fm_telefon<>tekst OR fm_telefon IS NULL);
  END IF;
 END IF;
 IF (typ=2) THEN
  IF (dt=1) THEN
   UPDATE tb_klient SET k_email=tekst WHERE k_idklienta=id AND (k_email<>tekst OR k_email IS NULL);
  END IF;
  IF (dt=35) THEN
   UPDATE tb_ludzieklienta SET lk_email=tekst WHERE lk_idczklienta=id AND (lk_email<>tekst OR lk_email IS NULL);
  END IF;
  IF (dt=11) THEN
   UPDATE tb_pracownicy SET p_email=tekst WHERE p_idpracownika=id AND (p_email<>tekst OR p_email IS NULL);
  END IF;
  IF (dt=66) THEN
   UPDATE tb_firma SET fm_email=tekst WHERE fm_index=id AND (fm_email<>tekst OR fm_email IS NULL);
  END IF;
 END IF;

 IF (TG_OP='OLD') THEN
  RETURN OLD;
 ELSE
  RETURN NEW;
 END IF;

END;
$$;
