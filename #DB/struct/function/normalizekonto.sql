CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
 _konto ALIAS FOR $1;
 konto TEXT;
 kontoprev TEXT;
BEGIN
 konto=_konto;
 kontoprev='';

 WHILE (konto<>kontoprev) LOOP
  kontoprev=konto;
  konto=replace(konto,'-0','-');
 END LOOP;

 konto=replace(konto,'--','-0-');
 konto=konto||'|';
 konto=replace(konto,'-|','-0');
 konto=replace(konto,'|','');
 
 WHILE (substr(konto,1,1)='0') LOOP
  konto=substr(konto,2);
 END LOOP;

 RETURN konto;
END
$_$;
