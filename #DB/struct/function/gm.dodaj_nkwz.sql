CREATE FUNCTION dodaj_nkwz(numeric, integer, integer, integer, integer, integer, integer, date, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
DECLARE 
 _ilosc ALIAS FOR $1;

 _idelem ALIAS FOR $2;
 _idtrans ALIAS FOR $3;
 _idtowaru ALIAS FOR $4;
 _idtowmag ALIAS FOR $5;
 _idmag ALIAS FOR $6;
 _idklienta ALIAS FOR $7;
 _data ALIAS FOR $8;
 _fvp ALIAS FOR $9;

 -------------------------------------------------------
 iloscrest   NUMERIC;
 ilosctmp    NUMERIC;
 rec         RECORD;
 ret         NUMERIC:=0;
 anyf        BOOL:=FALSE;
BEGIN

 iloscrest=_ilosc;

 FOR rec IN SELECT * FROM tg_teex AS ex 
                     WHERE ex.tel_idelem=_idelem 
		     ORDER BY ex.tex_idelem
 LOOP
  anyf=TRUE;

  ilosctmp=rec.tex_iloscf-rec.tex_iloscpkor;
  IF (_ilosc=0) THEN
   ilosctmp=0;
  END IF;

  ret=ret+gm.dodaj_nkwz_wtex(rec.tex_idelem,ilosctmp,_idelem,_idtrans,
                             _idtowaru,_idtowmag,_idmag,_idklienta,_data,
			     _fvp,rec.tex_skojarzony);

  iloscrest=iloscrest-ilosctmp;
 END LOOP;

 IF (anyf=FALSE) THEN
  RETURN gm.dodaj_nkwz_wtex(NULL,_ilosc,_idelem,_idtrans,
                             _idtowaru,_idtowmag,_idmag,_idklienta,_data,
			     _fvp,NULL);
 END IF;

 IF (iloscrest<>0) THEN
  RAISE EXCEPTION 'Blad rozpisania korekty WZ na rekordy TEX';
 END IF;

 RETURN ret;
END; 
$_$;
