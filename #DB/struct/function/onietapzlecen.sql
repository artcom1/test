CREATE FUNCTION onietapzlecen() RETURNS opaque
    LANGUAGE plpgsql
    AS $$
BEGIN

 UPDATE tg_zlecenia SET sz_idetapu=NEW.sz_idetapu WHERE zl_idzlecenia=NEW.zl_idzlecenia;

 RETURN NEW;
END;
$$;
