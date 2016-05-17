CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 r RECORD;
 numer INT:=1;
BEGIN

 FOR r IN EXECUTE $1
 LOOP
  UPDATE kh_zapisyhead SET zk_numer=numer WHERE zk_idzapisu=r.zk_idzapisu;
  numer=numer+1;
 END LOOP;
 
 RETURN numer-1;
 END;
$_$;
