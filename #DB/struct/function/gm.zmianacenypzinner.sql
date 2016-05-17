CREATE FUNCTION zmianacenypzinner(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
---WSPOK
DECLARE
 _idelem ALIAS FOR $1;
 pz_data RECORD;
 elemy TEXT:=''; ---''
 wartoscpoz NUMERIC;
 iloscpoz NUMERIC;
 wartosctmp NUMERIC;
 ilosctmp NUMERIC;
 ruchlast INT;
 wartoscstart NUMERIC;
 iloscstart NUMERIC;
 wsp NUMERIC:=1;
BEGIN
 ---Oblicz nowa cene jednostkowa
 iloscstart=(SELECT (tel_iloscf-tel_iloscpkor)*tel_sprzedaz FROM tg_transelem WHERE tel_idelem=_idelem);
 wartoscstart=(SELECT (tel_wartosczakupu+tel_narzut)*tel_sprzedaz FROM tg_transelem WHERE tel_idelem=_idelem);
 iloscpoz=iloscstart;
 wartoscpoz=wartoscstart;
  
 IF (wartoscpoz<0) THEN
  wsp=-wsp;
  wartoscpoz=-wartoscpoz;
 END IF;

 --- Wez ID interesujacego nas ruchu (zakladamy ze jest jeden)
 FOR pz_data IN SELECT rc_idruchu,rc_ilosc,rc_wartosc,rc_wspwartosci 
                FROM tg_ruchy 
				WHERE tel_idelem=_idelem AND isPZet(rc_flaga) 
				ORDER BY tex_idelem,isPZet(rc_flaga) DESC,rc_idruchu DESC
 LOOP
  ruchlast=pz_data.rc_idruchu; 
  ilosctmp=min(iloscpoz,pz_data.rc_ilosc);
  
  IF (wsp IS DISTINCT FROM pz_data.rc_wspwartosci) THEN
   RAISE EXCEPTION 'Nie zgadza sie wspolczynnik wartosci na ruchu';
  END IF;

  IF (ilosctmp=iloscpoz) THEN
   wartosctmp=wartoscpoz;
  ELSE
   wartosctmp=floorRoundMax(wartoscstart*ilosctmp/iloscstart,wartoscpoz);
  END IF;

  ----RAISE NOTICE 'Mam % % % % ',wartoscstart,ilosctmp,iloscstart,wartoscpoz;


  elemy=elemy||'|'||zmianaNaPZRuch(pz_data.rc_idruchu,ilosctmp,wartosctmp*wsp,false);

  iloscpoz=iloscpoz-ilosctmp;
  wartoscpoz=wartoscpoz-wartosctmp;
 END LOOP;

 IF (iloscpoz>0) AND (ruchlast IS NOT NULL) THEN
  --- Zwieksz ostatni ruch o pozostalosc
  elemy=elemy||'|'||zmianaNaPZRuch(ruchlast,ilosctmp+iloscpoz,(wartosctmp+wartoscpoz)*wsp,false);
 END IF;

 --I na koncu zrob update transelemu
 UPDATE tg_transelem SET tel_idelem=tel_idelem WHERE tel_idelem=_idelem;
 UPDATE tg_ruchy SET rc_flaga=rc_flaga&(~(1<<21)),rc_cenajmpokor=NULL WHERE tel_idelem=_idelem;

 PERFORM gm.ResyncCenaJMPoKor((SELECT tr_idtrans FROM tg_transelem WHERE tel_idelem=_idelem));

 RETURN elemy;
END;
$_$;
