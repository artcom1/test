CREATE OR REPLACE FUNCTION 
    LANGUAGE plpgsql
    AS $_$
---WSPOK
DECLARE 
 _idtex     ALIAS FOR $1;
 _ilosc     ALIAS FOR $2;

 _idelem    ALIAS FOR $3;
 _idtrans   ALIAS FOR $4;
 _idtowaru  ALIAS FOR $5;
 _idtowmag  ALIAS FOR $6;
 _idmag     ALIAS FOR $7;
 _idklienta ALIAS FOR $8;
 _data      ALIAS FOR $9;
 _fvp       ALIAS FOR $10;
 _fvptex    ALIAS FOR $11;

 iloscpoz NUMERIC;
 wartoscpoz NUMERIC;

 t_iloscel NUMERIC;
 t_wartosc NUMERIC;

 ruch_data RECORD;
 ruch_data1 RECORD;
BEGIN

 IF (_ilosc>0) THEN
  RAISE EXCEPTION 'Proba nowej korekty minusowej na plusowym';
 END IF;

 IF (_ilosc=0) THEN
  DELETE FROM tg_ruchy WHERE tel_idelem=_idelem AND isKFV(rc_flaga) AND tex_idelem IS NOT DISTINCT FROM _idtex;
  RETURN 0;
 END IF;

 PERFORM gm.clear_wz(_idelem,_idtex);

 iloscpoz=-_ilosc;
 wartoscpoz=0;

 FOR ruch_data IN 
  SELECT k.rc_ilosc,p.rc_cenajedn,k.rc_idruchu,k.rc_wartosc+p.rc_wartoscpoz AS rc_wartosct,k.rc_wartosc,k.rc_wspwartosci
  FROM tg_ruchy AS k 
  JOIN tg_ruchy AS p ON (k.rc_ruch=p.rc_idruchu) 
  WHERE k.tel_idelem=_idelem AND isKFV(k.rc_flaga) AND k.tex_idelem IS NOT DISTINCT FROM _idtex
  ORDER BY k.rc_dataop DESC,k.rc_idruchu DESC
 LOOP
  -- Ilosc ktora pozostala
  t_iloscel=max(min(iloscpoz,ruch_data.rc_ilosc),0);
  IF (t_iloscel=ruch_data.rc_ilosc) THEN
   t_wartosc=ruch_data.rc_wartosc*ruch_data.rc_wspwartosci;
   ---RAISE NOTICE 'Wartosc 1 % ',t_wartosc;
  ELSE
   t_wartosc=floorRoundMax(ruch_data.rc_cenajedn*t_iloscel,ruch_data.rc_wartosct*ruch_data.rc_wspwartosci);
   ---RAISE NOTICE 'Wartosc 2 % ',t_wartosc;
  END IF;

  -- Konieczna jest modyfikacja ilosci
  IF (t_iloscel<ruch_data.rc_ilosc)  THEN
    
   IF (t_iloscel=0) THEN
    -- Zmiejszenie ilosci do 0
    DELETE FROM tg_ruchy WHERE rc_idruchu=ruch_data.rc_idruchu;
   ELSE 
    -- Zmniejszenie ilosci
    UPDATE tg_ruchy SET 
	 rc_ilosc=t_iloscel,
	 rc_iloscpoz=round(rc_iloscpoz-(ruch_data.rc_ilosc-t_iloscel),4),
	 rc_wartosc=t_wartosc*ruch_data.rc_wspwartosci,
	 rc_wartoscpoz=rc_wartoscpoz-(rc_wartosc-t_wartosc*ruch_data.rc_wspwartosci) 
	WHERE rc_idruchu=ruch_data.rc_idruchu;
   END IF;

  END IF;

  iloscpoz=round(iloscpoz-t_iloscel,4);
  wartoscpoz=wartoscpoz+t_wartosc;
 END LOOP;


  ---RAISE NOTICE 'Sciagam % dla idelem % i trans % ',iloscpoz,_fvp,_idtrans;

  IF (iloscpoz>0) THEN

   FOR ruch_data IN 
    SELECT rc_cenajedn,rc_idruchu,rc_iloscpoz AS rc_zostalo,rc_wartoscpoz,rc_wspwartosci
    FROM tg_ruchy AS r
    JOIN (
     SELECT te.tel_idelem,tex.tex_idelem
     FROM tg_transelem AS te
     LEFT OUTER JOIN tg_teex AS tex USING (tel_idelem)
     WHERE (tel_skojarzony=_fvp OR tel_idelem=_fvp) AND (te.tr_idtrans<>_idtrans) AND
           (tex.tex_skojarzony IS NOT DISTINCT FROM _fvptex OR tex.tex_idelem IS NOT DISTINCT FROM _fvptex)
    ) AS a ON (r.tel_idelem=a.tel_idelem AND a.tex_idelem IS NOT DISTINCT FROM r.tex_idelem) 
    WHERE rc_iloscpoz>0 AND isFV(rc_flaga) 
    ORDER BY rc_dataop DESC,rc_ruch DESC
   LOOP
    t_iloscel=round(max(min(iloscpoz,ruch_data.rc_zostalo),0),4);
    IF (t_iloscel=ruch_data.rc_zostalo) THEN
     t_wartosc=ruch_data.rc_wartoscpoz*ruch_data.rc_wspwartosci;
    ELSE
     t_wartosc=floorRoundMax(ruch_data.rc_cenajedn*t_iloscel,ruch_data.rc_wartoscpoz*ruch_data.rc_wspwartosci);
    END IF;


    IF (t_iloscel>0) THEN
     
     INSERT INTO tg_ruchy 
      (tel_idelem,tr_idtrans,ttw_idtowaru,k_idklienta,ttm_idtowmag,tmg_idmagazynu,tex_idelem,
       rc_data,rc_ilosc,rc_iloscpoz,rc_flaga,rc_wartosc,rc_wartoscpoz,rc_ruch,rc_kierunek,rc_wspwartosci)
     VALUES
      (_idelem,_idtrans,_idtowaru,_idklienta,_idtowmag,_idmag,_idtex,
       _data,round(t_iloscel,4),round(t_iloscel,4),32,t_wartosc*ruch_data.rc_wspwartosci,t_wartosc*ruch_data.rc_wspwartosci,ruch_data.rc_idruchu,-1,ruch_data.rc_wspwartosci); 
    
    END IF;

    iloscpoz=round(iloscpoz-t_iloscel,4);

   END LOOP;    
  END IF;


 IF (iloscpoz<>0) THEN
  RAISE EXCEPTION 'Nie wszystko sciagniete korekta (%)',iloscpoz;
 END IF;

 wartoscpoz=(SELECT sum(rc_wartosc) FROM tg_ruchy WHERE tel_idelem=_idelem  AND tex_idelem IS NOT DISTINCT FROM _idtex);
 RETURN round(-wartoscpoz,6);
END; $_$;
