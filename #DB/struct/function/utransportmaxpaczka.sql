CREATE FUNCTION utransportmaxpaczka(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _lt_idtransportu ALIAS FOR $1;
 _rodzaj INT;
 _bity INT:=0;
BEGIN
 _rodzaj=(SELECT COALESCE(MAX(pp_typ),0) FROM tg_paczkiprzewozowe WHERE lt_idtransportu=_lt_idtransportu);
 -- Na podstawie enum ePaczkaPrzewozowaTyp
 --- 0 - brak
 --- 1 - koperta
 --- paczka: (1<<1)|(1<<8)|(1<<9)|(1<<10)|(1<<11)|(1<<12)|(1<<13)
 --- 252 (4+8+16+32+64+128) - paleta
 
 IF (_rodzaj=0) THEN
  _bity=0;
 END IF;

 IF (_rodzaj=1) THEN
  _bity=(1<<7);
 END IF;

 IF (_rodzaj&((1<<1)|(1<<8)|(1<<9)|(1<<10)|(1<<11)|(1<<12)|(1<<13))!=0) THEN
  _bity=(2<<7);
 END IF;

 IF ((_rodzaj&252)!=0) THEN
  _bity=(3<<7);
 END IF;  
 
 UPDATE tg_transport SET lt_flaga=((lt_flaga&(~(3<<7)))|(_bity)) WHERE lt_idtransportu=_lt_idtransportu;

 RETURN TRUE;
END;
$_$;
