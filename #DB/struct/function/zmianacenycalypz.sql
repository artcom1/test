CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _idtrans ALIAS FOR $1;
 elem RECORD;
 elemy TEXT:='';
 wynik TEXT:='';
 lastid int;
BEGIN
 ---Wez wszystkie rekordy PZetowe
 FOR elem IN SELECT tel_idelem FROM tg_transelem WHERE tr_idtrans=_idtrans 
 LOOP
  lastid=elem.tel_idelem;
  wynik=gm.zmianacenypz(lastid,false);
  elemy=elemy||'|'||wynik;
 END LOOP;
 
 IF (lastid IS NOT NULL) THEN
  PERFORM gm.zmianacenypz(lastid,true);
 END IF;

 RETURN elemy;
END;
$_$;
