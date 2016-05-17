CREATE FUNCTION updateformula(integer, text) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE
 id INT;
BEGIN
 id=(SELECT f_idformuly FROM tg_fkalkulacji WHERE ttw_idtowaru=$1);
 IF (id IS NULL) THEN
  INSERT INTO tg_fkalkulacji (ttw_idtowaru,f_formula) VALUES ($1,$2);
  RETURN currval('tg_fkalkulacji_s');
 ELSE
  UPDATE tg_fkalkulacji SET f_formula=$2 WHERE f_idformuly=id;
  RETURN id;
 END IF;
 RETURN NULL;
END;
$_$;
