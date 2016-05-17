CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _idplatnosc ALIAS FOR $1;
  _idbanku    ALIAS FOR $2;
  _kwota      ALIAS FOR $3;
  _kwotapln   ALIAS FOR $4;
  _idwaluty   ALIAS FOR $5;
  _datakursu  ALIAS FOR $6;
  r           RECORD;
  id          INT;
BEGIN

 IF (_idwaluty=1) THEN RETURN -1; END IF;

 IF (_kwota=0) THEN
  DELETE FROM kh_platfifo WHERE pl_idplatnosc=_idplatnosc;
  RETURN NULL;
 END IF;

 SELECT * INTO r FROM kh_platfifo WHERE pl_idplatnosc=_idplatnosc;
 IF (r.po_idfifo IS NOT NULL) THEN

  IF (r.bk_idbanku=_idbanku AND r.wl_idwaluty=_idwaluty AND r.po_wplyw=1) THEN
   --Zrob update - wszystko sie zgadza
   UPDATE kh_platfifo SET po_kwotawal=_kwota,po_kwotapln=_kwotapln,po_datakursu=_datakursu WHERE po_idfifo=r.po_idfifo AND (po_kwotawal<>_kwota OR po_kwotapln<>_kwotapln OR po_datakursu<>_datakursu);
   RETURN r.po_idfifo;
  END IF;
  
  --Cos sie nie zgadza - skasuj rekord
  DELETE FROM kh_platfifo WHERE po_idfifo=r.po_idfifo;
 END IF;

 --Wstaw nowy rekord
 INSERT INTO kh_platfifo 
  (pl_idplatnosc,bk_idbanku,wl_idwaluty,po_wplyw,po_kwotawal,po_kwotapln,po_datakursu)
 VALUES
  (_idplatnosc,_idbanku,_idwaluty,1,_kwota,_kwotapln,_datakursu);
  
 id=(SELECT currval('kh_platfifo_s'));

 RETURN id;
END;
$_$;


--
--

CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _flag ALIAS FOR $7;
BEGIN

 --Brak kantoru walut - wyczysc
 IF (((_flag>>19)&3)=0) OR (_flag&64=64) THEN
  PERFORM clearPlatFifo($1);
  RETURN NULL;
 END IF;

 --Platnosc nie jest zamknieta (a powinna byc)
 IF (((_flag>>19)&3)=2) AND (((_flag>>11)&3)<>0) THEN
  PERFORM clearPlatFifo($1);
  RETURN NULL;
 END IF;

 --Moze byc w buforze a nie jest
 IF (((_flag>>19)&3)=2) AND (((_flag>>11)&3) NOT IN (0,1)) THEN
  PERFORM clearPlatFifo($1);
  RETURN NULL;
 END IF;

 --Platnosc anulowana
 IF (((_flag>>11)&3) IN (2)) THEN
  PERFORM clearPlatFifo($1);
  RETURN NULL;
 END IF;

 RETURN updatePlusPlatFifo($1,$2,$3,$4,$5,$6);
END;
$_$;
