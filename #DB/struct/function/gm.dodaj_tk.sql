CREATE FUNCTION dodaj_tk(numeric, integer, integer, integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $_$
---WSPOK
DECLARE
 _dilosc ALIAS FOR $1;
 _klient ALIAS FOR $2;
 _towmag ALIAS FOR $3;
 _tranelem ALIAS FOR $4;
 tk_data RECORD;
BEGIN

 ---Delta ilosc byla nic, nie proboj nic robic
 IF (_dilosc=0) THEN
  DELETE FROM tg_ruchy WHERE isTK(rc_flaga) AND tel_idelem=_tranelem;
  RETURN 0;
 END IF;

 SELECT rc_idruchu INTO tk_data FROM tg_ruchy WHERE isTK(rc_flaga) AND tel_idelem=_idelem;
 IF NOT FOUND THEN
  INSERT INTO tg_ruchy 
   (tel_idelem,tr_idtrans,ttw_idtowaru,ttm_idtowmag,tmg_idmagazynu,rc_data,rc_ilosc,rc_iloscpoz,rc_flaga,rc_wartosc,rc_wartoscpoz,k_idklienta,rc_kierunek,rc_wspwartosci) 
     VALUES 
   (NULL,NULL,
    (SELECT ttw_idtowaru FROM tg_towmag WHERE ttm_idtowmag=_towmag),
    _towmag,
    (SELECT tmg_idmagazynu FROM tg_towmag WHERE ttm_idtowmag=_towmag),
    now(),0,round(_dilosc,4),256,0,0,_klient,-1,1
   ); 
  ELSE
   UPDATE tg_ruchy SET
    k_idklienta=_klient,
    rc_iloscpoz=_dilosc
   WHERE rc_idruchu=tk_data.rc_idruchu;
  END IF;

 RETURN 0;
END;
$_$;
