CREATE FUNCTION dodaj_kpz(numeric, integer, integer, integer, integer, integer, integer, date, integer, numeric, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE
 _ilosc      ALIAS FOR $1;   ---- ilosc korekty na minus (>=0)

 _idelem     ALIAS FOR $2;   --- ID tranelemu
 _idtrans    ALIAS FOR $3;   --- ID transakcji
 _idtowaru   ALIAS FOR $4;   --- ID towaru
 _idtowmag   ALIAS FOR $5;   --- ID towmag
 _idmag      ALIAS FOR $6;   --- ID magazynu
 _idklienta  ALIAS FOR $7;   --- ID klienta
 _data       ALIAS FOR $8;   --- Data sprzedazy
 _fvp        ALIAS FOR $9;   --- ID korygowanego tranelemu (PZetu) 
 _wartosc    ALIAS FOR $10;  --- wartosc korekty na minus (>=0)
 _idpartii   ALIAS FOR $11;  --- ID partii
 -------------------------------------------------------
 rec         RECORD;
 ret         NUMERIC:=0;
 anyf        BOOL:=FALSE;
 ilosctmp    NUMERIC;
 wartosctmp  NUMERIC;
 iloscrest   NUMERIC;
 wartoscrest NUMERIC;
BEGIN

 iloscrest=_ilosc;
 wartoscrest=_wartosc;

 FOR rec IN SELECT * FROM tg_teex AS ex 
                     WHERE ex.tel_idelem=_idelem 
		     ORDER BY ex.tex_idelem
 LOOP
  anyf=TRUE;

  ilosctmp=-rec.tex_iloscf;
  IF (_ilosc=0) THEN
   ilosctmp=0;
  END IF;

  ---Oblicz wartosc
  IF (ilosctmp=0) THEN
   wartosctmp=0;
  ELSIF (ilosctmp=iloscrest) THEN
   wartosctmp=wartoscrest;
  ELSE
   wartosctmp=floorRoundMax(_wartosc*ilosctmp/_ilosc,wartoscrest);
  END IF;

  iloscrest=iloscrest-ilosctmp;
  wartoscrest=wartoscrest-wartosctmp;

  IF (iloscrest<0) THEN
   RAISE EXCEPTION 'Blad Ex Korekty PZ';
  END IF;


  ret=ret+gm.dodaj_kpz_wtex(rec.tex_idelem,
                            ilosctmp,
			    _idelem,
			    _idtrans,
			    _idtowaru,
			    _idtowmag,
			    _idmag,
			    _idklienta,
			    _data,
			    _fvp,
			    rec.tex_skojarzony,
			    wartosctmp,
			    rec.prt_idpartii);

 END LOOP;

--- RAISE EXCEPTION 'Ok jest';

 IF (anyf=FALSE) THEN
  RETURN gm.dodaj_kpz_wtex(NULL,_ilosc,_idelem,_idtrans,_idtowaru,_idtowmag,_idmag,_idklienta,_data,_fvp,NULL,_wartosc,_idpartii);
 END IF;

 return ret;
END;
$_$;
