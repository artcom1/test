CREATE FUNCTION initmysession() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 ret INT:=vendo.tv_mysessionpid();
BEGIN

 IF (ret IS NOT NULL) THEN
  RETURN ret;
 END IF;

 CREATE TEMP SEQUENCE v_counter;

 INSERT INTO vendo.tm_vusers
  (id,
   backend_pid,
   table_oid,
   p_idpracownika
  ) VALUES
  (nextval('vendo.tm_vusers_s'),
   pg_backend_pid(),
   (SELECT oid FROM pg_class WHERE relname='v_counter' AND pg_table_is_visible(oid)),
   (SELECT min(p_idpracownika) FROM tb_pracownicy WHERE p_idpracownika>0)
  );

  
 RETURN vendo.tv_mysessionpid();
END;
$$;
