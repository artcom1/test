CREATE FUNCTION tolgexid(text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 id INT;
BEGIN
 id=(SELECT lgex_id FROM tg_logex WHERE lgex_txt=$1);
 IF (id IS NOT NULL) THEN
  RETURN id;
 END IF;

 INSERT INTO tg_logex (lgex_txt) VALUES ($1);

 RETURN currval('tg_log_s');
END;
$_$;
