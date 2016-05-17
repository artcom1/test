CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
---WSPOK
DECLARE
 _idruchufv ALIAS FOR $1;
 _ilosc     ALIAS FOR $2;
 _wartosc   ALIAS FOR $3;
 elemy      TEXT :='';
 rin        RECORD;
 iloscpoz   NUMERIC;
 wartoscpoz NUMERIC;
 cenajm     NUMERIC;
 wsp        NUMERIC:=1;
BEGIN
 
 IF (_wartosc<0) THEN
  _wartosc=-_wartosc;
  wsp=-wsp;
 END IF;
  
 iloscpoz=_ilosc;
 wartoscpoz=_wartosc;
 
 IF (_ilosc=0) THEN
  RETURN '';
 END IF;
 
 cenajm=round(_wartosc/_ilosc,2);
    
 FOR rin IN SELECT * FROM tg_ruchy WHERE isKFV(rc_flaga) AND rc_ruch=_idruchufv
 LOOP
  IF (iloscpoz=rin.rc_ilosc) THEN
   --- Znalezlismy ostatni rekord - zupdatuj go tym co zostalo
   UPDATE tg_ruchy SET rc_wartosc=wartoscpoz*wsp,rc_wartoscpoz=wartoscpoz*wsp,rc_wspwartosci=wsp WHERE rc_idruchu=rin.rc_idruchu;
   wartoscpoz=0;
  ELSE
   UPDATE tg_ruchy SET rc_wartosc=floorroundmax(cenajm*rin.rc_ilosc,wartoscpoz)*wsp,rc_wartoscpoz=floorroundmax(cenajm*rin.rc_ilosc,wartoscpoz)*wsp,rc_wspwartosci=wsp WHERE rc_idruchu=rin.rc_idruchu;
   wartoscpoz=wartoscpoz-floorroundmax(cenajm*rin.rc_ilosc,wartoscpoz);
  END IF;
  iloscpoz=iloscpoz-rin.rc_ilosc;
  elemy=elemy||'|'||rin.tel_idelem::text;
  PERFORM checkZaksiegowanieDoc(rin.tr_idtrans);
  UPDATE tg_transelem SET tel_idelem=tel_idelem WHERE tel_idelem=rin.tel_idelem;
 END LOOP;


 IF ((iloscpoz<>0) OR (wartoscpoz<>0)) THEN
  RAISE EXCEPTION 'Blad przy zmianaPZruchKWZ!';
 END IF;

 RETURN elemy;
END;
$_$;
