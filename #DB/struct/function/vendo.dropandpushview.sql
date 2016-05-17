CREATE FUNCTION dropandpushview(text) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _viewname    ALIAS FOR $1;
BEGIN

 INSERT INTO 
  vendo.tmp_viewspushed
 VALUES
  (DEFAULT,_viewname,pg_get_viewdef(_viewname));

 EXECUTE 'DROP VIEW '||_viewname;

 RETURN TRUE;
END;
$_$;
